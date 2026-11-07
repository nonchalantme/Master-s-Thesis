function [pagg] = hicp_chain(p,w_ann,wyears,calds)
% HICP_CHAIN  Aggregate component price indexes the way the HICP does:
%             annual weights, Laspeyres-type within the year, chain-linked
%             through December of the previous year.
%
%   NEW (German adaptation). Used to (i) build aggregates that Eurostat does
%   not publish in the data file (energy = CP045+CP0722, food incl. alcohol &
%   tobacco = CP01+CP02) and (ii) check that the components reproduce the
%   published HICP totals (replaces the US "nominal components add up" check).
%
%        pagg(t) = pagg(Dec y-1) * sum_i w(i,y) p(t,i)/p(Dec y-1,i) / sum_i w(i,y)
%
%   Input:   p      = T x k monthly component indexes (NOT seasonally adjusted)
%            w_ann  = Y x k annual weights, rows = years in wyears
%            wyears = Y x 1
%            calds  = T x 2 [year month]
%   Output:  pagg   = T x 1, = 100 in the first December that can be linked,
%                     NaN before it

  T = size(p,1);
  pagg = NaN(T,1);
  e = hicp_expend(p,w_ann,wyears,calds);
  wsum = NaN(T,1);
  for t = 1:T
      iy = find(wyears == calds(t,1),1);
      if ~isempty(iy); wsum(t) = sum(w_ann(iy,:)); end
  end
  rel = sum(e,2) ./ wsum;          % price relative to December of y-1
  % Base: first December whose following January is linkable
  ibase = find(calds(:,2) == 12 & [~isnan(rel(2:end)); false],1);
  if isempty(ibase); return; end
  pagg(ibase) = 100;
  for t = ibase+1:T
      if isnan(rel(t)); break; end
      idec = find(calds(:,1) == calds(t,1)-1 & calds(:,2) == 12,1);
      pagg(t) = pagg(idec) * rel(t);
  end
end
