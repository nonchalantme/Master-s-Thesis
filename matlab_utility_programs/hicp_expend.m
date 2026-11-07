function [expend] = hicp_expend(p,w_ann,wyears,calds)
% HICP_EXPEND  Monthly expenditure proxies implied by annual HICP weights.
%
%   NEW (German adaptation). The US code uses nominal PCE by component to
%   form expenditure shares. The HICP has no monthly nominal expenditure, only
%   annual item weights w(i,y) (per mille), price-updated by Eurostat to
%   December of year y-1. Within year y the HICP is a Laspeyres-type index
%   linked in December, so component i's implied expenditure in month t of
%   year y is proportional to
%
%        expend(t,i) = w(i,y) * p(t,i) / p(Dec y-1,i)
%
%   Shares expend(t,i)/sum_j expend(t,j) are the exact effective weights of
%   the official HICP formula, and they move every month with relative prices
%   (like nominal spending shares do).
%
%   Input:   p      = T x k monthly price indexes (NOT seasonally adjusted)
%            w_ann  = Y x k annual weights (rows = years in wyears)
%            wyears = Y x 1 years of the weight rows
%            calds  = T x 2 [year month] calendar of p
%   Output:  expend = T x k, NaN where no December link is available

  [T,k] = size(p);
  if size(w_ann,2) ~= k
      error('hicp_expend: p and w_ann must have the same number of columns');
  end
  expend = NaN(T,k);
  for t = 1:T
      y = calds(t,1);
      iy = find(wyears == y,1);
      idec = find(calds(:,1) == y-1 & calds(:,2) == 12,1);
      if isempty(iy) || isempty(idec); continue; end
      expend(t,:) = w_ann(iy,:) .* p(t,:) ./ p(idec,:);
  end
end
