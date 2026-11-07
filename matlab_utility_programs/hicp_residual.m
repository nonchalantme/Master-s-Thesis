function [pres,wres] = hicp_residual(ppar,wpar,psub,wsub,wyears,calds)
% HICP_RESIDUAL  Price index and weight of "parent minus sub-components".
%
%   NEW (German adaptation). Analogue of the US step that backs out
%   "housing excl. gas & electric utilities" from housing & utilities.
%   Here: e.g. other housing = CP04 - CP041 - CP045, other transport =
%   CP07 - CP0711 - CP0722 - CP073. Under the HICP formula, within year y
%
%     wpar*ppar(t)/ppar(Dec) = sum_s wsub(s)*psub(t,s)/psub(Dec,s) + wres*pres(t)/pres(Dec)
%
%   so the residual's relative to December is exact; it is then chain-linked
%   through Decembers like any HICP index.
%
%   Input:   ppar  = T x 1 parent index;    wpar = Y x 1 parent weights
%            psub  = T x m sub-indexes;      wsub = Y x m sub weights
%            wyears, calds as in hicp_chain
%   Output:  pres  = T x 1 residual index (100 in first linkable December)
%            wres  = Y x 1 residual weights (wpar - sum(wsub))

  wres = wpar - sum(wsub,2);
  if any(wres <= 0)
      error('hicp_residual: residual weight <= 0 in some year');
  end
  epar = hicp_expend(ppar,wpar,wyears,calds);
  esub = hicp_expend(psub,wsub,wyears,calds);
  T = size(ppar,1);
  rel = NaN(T,1);
  for t = 1:T
      iy = find(wyears == calds(t,1),1);
      if isempty(iy); continue; end
      rel(t) = (epar(t) - sum(esub(t,:),2)) / wres(iy);
  end
  pres = NaN(T,1);
  ibase = find(calds(:,2) == 12 & [~isnan(rel(2:end)); false],1);
  if isempty(ibase); return; end
  pres(ibase) = 100;
  for t = ibase+1:T
      if isnan(rel(t)); break; end
      idec = find(calds(:,1) == calds(t,1)-1 & calds(:,2) == 12,1);
      pres(t) = pres(idec) * rel(t);
  end
end
