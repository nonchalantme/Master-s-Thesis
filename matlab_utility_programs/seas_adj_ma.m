function [xsa,sf,isseas,fstat] = seas_adj_ma(x,calds,nyr_win,fcrit)
% SEAS_ADJ_MA  Simple, robust ratio-to-moving-average seasonal adjustment
%              of monthly price indexes (X-11 style, multiplicative).
%
%   NEW (German adaptation). BEA's PCE price indexes are published
%   seasonally adjusted; the HICP is not. The US methodology therefore
%   implicitly uses SA data, so the German data must be adjusted before
%   computing inflation (particularly with mtoq_agg = 3, where quarterly
%   values are taken from the last month of each quarter).
%
%   For a thesis, X-13ARIMA-SEATS / JDemetra+ is the reference method; this
%   function is a transparent fallback that needs no toolbox. Steps, per
%   series, on y = log(x):
%     1. Test for stable seasonality: F-test of month dummies in the
%        regression of dy on a constant + 11 month dummies. If F < fcrit the
%        series is left unadjusted (sf = 0).
%     2. Trend = centered 2x12 moving average of y.
%     3. SI = y - trend. For each calendar month, the seasonal factor in
%        year Y is the MEDIAN of that month's SI over years Y-nyr_win ...
%        Y+nyr_win (truncated at the sample ends). The median makes the factor
%        robust to one-off events (e.g. the July-Dec 2020 German VAT cut,
%        the 2022 energy shock).
%     4. Factors are normalised to average zero over any 12 consecutive months.
%     5. xsa = exp(y - sf).
%
%   Input:   x       = T x k index levels (> 0), NaN allowed at the ends
%            calds   = T x 2 [year month]
%            nyr_win = half-window in years for the seasonal median (e.g. 3
%                      -> 7-year window, so factors can evolve slowly)
%            fcrit   = critical value for the seasonality F-test (2.3 is
%                      about the 1% value of F(11, 300))
%   Output:  xsa     = T x k adjusted levels
%            sf      = T x k log seasonal factors (0 if not adjusted)
%            isseas  = 1 x k, 1 if the series was adjusted
%            fstat   = 1 x k F statistics

  [T,k] = size(x);
  xsa = x; sf = zeros(T,k); isseas = zeros(1,k); fstat = NaN(1,k);
  mon = calds(:,2); yrs = calds(:,1);
  for j = 1:k
      y = log(x(:,j));
      ok = ~isnan(y);
      if sum(ok) < 60; continue; end            % need at least 5 years

      % --- 1. F-test for seasonality on monthly log changes
      dy = [NaN; diff(y)];
      iv = ~isnan(dy);
      D = zeros(T,12);
      for m = 1:12; D(:,m) = (mon == m); end
      Y = dy(iv); X1 = D(iv,:); n = numel(Y);
      e1 = Y - X1*(X1\Y);   rss1 = e1'*e1;
      e0 = Y - mean(Y);     rss0 = e0'*e0;
      fstat(j) = ((rss0-rss1)/11) / (rss1/(n-12));
      if fstat(j) < fcrit; continue; end
      isseas(j) = 1;

      % --- 2. Centered 2x12 moving average trend
      tr = NaN(T,1);
      for t = 7:T-6
          seg = y(t-6:t+6);
          if all(~isnan(seg))
              tr(t) = (0.5*seg(1) + sum(seg(2:12)) + 0.5*seg(13))/12;
          end
      end
      si = y - tr;

      % --- 3. Seasonal factors: moving median by calendar month
      sraw = NaN(T,1);
      for t = find(ok)'
          sel = (mon == mon(t)) & abs(yrs - yrs(t)) <= nyr_win & ~isnan(si);
          if sum(sel) < 3                        % too few: use all years
              sel = (mon == mon(t)) & ~isnan(si);
          end
          sraw(t) = median(si(sel));
      end

      % --- 4. Normalise over 12 consecutive months
      iok = find(ok);
      t1 = iok(1); t2 = iok(end);
      s = zeros(T,1);
      for t = t1:t2
          a = max(t1, min(t-6, t2-11));
          s(t) = sraw(t) - mean(sraw(a:a+11));
      end
      s(~ok) = 0;
      sf(:,j) = s;
      xsa(:,j) = exp(y - s);
  end
end
