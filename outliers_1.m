% outliers_1.m -- 
% 9/11/2015, MWW
%


clear all;
small = 1.0e-10;
big = 1.0e+6;                 
 
  % -- File Directories  
  outdir = '/Users/HP/OneDrive/Master Thesis/Watson, core iflation/matlabfiles/matlab/out/';
  figdir = '/Users/HP/OneDrive/Master Thesis/Watson, core iflation/matlabfiles/matlab/fig/';
  matdir = '/Users/HP/OneDrive/Master Thesis/Watson, core iflation/matlabfiles/matlab/mat/';
    
  % -- Read in Data --- 
  load_data = 1;  % 1 if reloading data from Excel, etc 
  mtoq_agg = 3;   % Temporal aggregation indicator of monthly to quarterly data
  pcomp_data_calendar_m_and_q;
  
  % Look for outliers in inflation rates
  str_label = 'Q0';
  dp_agg = dp_agg_q;
  dp_agg_xfe = dp_agg_xfe_q;
  dp_agg_xe = dp_agg_xe_q;
  dp_disagg = dp_disagg_q;
  calvec = calvec_q;
  dnobs = dnobs_q;
  calds = calds_q;
  nper = 4;
  
%   str_label = 'Q0';
%   dp_agg = dp_agg_m;
%   dp_agg_xfe = dp_agg_xfe_m;
%   dp_agg_xe = dp_agg_xe_m;
%   dp_disagg = dp_disagg_m;
%   calvec = calvec_m;
%   dnobs = dnobs_m;
%   calds = calds_m;
%   nper = 12;
  
  % Outlier Adjustment
  thr = 3;
  tflag = 0;
  bwidth = 10*nper;
  
  labvec = {'Headline Inflation';'Core XFE';'Core XE'};
  labvec = [labvec;labelvec_short_disagg];
  dp = [dp_agg dp_agg_xfe dp_agg_xe dp_disagg];
  for i = 1:size(dp,2);
      y = dp(:,i);
      ya = adjout_local(y,thr,tflag,bwidth);
      str = char(labvec(i));
      str
      tmp = [calds(isnan(ya)==1,:) y(isnan(ya)==1,:)];
      % Check for consecutive outliers with opposite signs:
      fprintf('All Outliers \n');
      for j = 1:size(tmp,1);
        fprintf('%4i %2i %5.1f \n',tmp(j,:));  
      end;
      cv = calvec(isnan(ya)==1,:);
      fprintf('Consecutive Outliers of opposite sign \n');
      for j = 2:size(tmp,1);
          if sign(tmp(j,3))*sign(tmp(j-1,3)) == -1;
              if cv(j)-cv(j-1) < (1/nper) + small;
                  fprintf('%4i %2i %5.1f \n',tmp(j-1,:));
                  fprintf('%4i %2i %5.1f \n',tmp(j,:));
              end;
          end;
      end;    
      plot(calvec,y);
      title(str);
      waitforbuttonpress;
  end;
      
  
  
  
  
  
%  
%  function [x] = adjout(y,thr,tflag)
% -- Adjust for outliers using fraction of IQR
%      
%       y = Data series
%       thr = threshold in multiples of IQR
%       tflag = 0  == replace with missing value 
%               1  == replace with maximum or minimum value
%               2  == replace with median value
%               3  == replace with local median (obs + or - 3 on each side)
%               4  == replace with one-sided median (5 preceding obs)
  