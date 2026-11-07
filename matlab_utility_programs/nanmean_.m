function [m] = nanmean_(x)
% NANMEAN_  Column means ignoring NaN (no Statistics Toolbox needed).
%
%   NEW (German adaptation). The US shares have no missing values, so the
%   original code used mean(). HICP-based shares are NaN in the first year
%   (no December link before January 1996), so the average weights must skip
%   missing months.
  ok = ~isnan(x);
  x(~ok) = 0;
  m = sum(x,1) ./ sum(ok,1);
end
