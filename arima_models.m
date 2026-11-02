% arima_models for individual series -- 
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
  tflag = 1;
  bwidth = 10*nper;
  
  labvec = {'Headline Inflation';'Core XFE';'Core XE'};
  labvec = [labvec;labelvec_short_disagg];
  dp = [dp_agg dp_agg_xfe dp_agg_xe dp_disagg];
  dpa = NaN(size(dp));
  
  for i = 1:size(dp,2);
      y = dp(:,i);
      ya = adjout_local(y,thr,tflag,bwidth);
      dpa(:,i) = ya;
  end;
  
  
  % Estimate 
  % Results for Quarterly Series
  %ismpl1 = smpl(calvec_q,[1959 2],calds(end,:),nper);
  ismpl1 = smpl(calvec_q,[1995 1],calds(end,:),nper);
  ismpl1 = smpl(calvec_q,[1959 2],[1970 1],nper);
  ismpl1 = smpl(calvec_q,[1970 1],[1995 1],nper);
  
  for i = 1:size(dp,2);
      ya = dpa(:,i);
      str = char(labvec(i));
      fprintf(['Inflation Series: ' str '\n']);
      ya = ya(ismpl1==1);
      Mdl = regARIMA(0,1,4);
      Mdl.Intercept = 0;  % Constrain intercept to equat zero
      [EstMdl,EstParamCov,logL,info] = estimate(Mdl,ya,'Display','params');
      ma_coef = cell2mat(EstMdl.MA);
      b = ma_coef(2:end)';
      vb = EstParamCov(3:5,3:5);
      wstat = b'*inv(vb)*b;
      pvalue = 1-chi2cdf(wstat,3);
      fprintf('Wald Stat and pvalue %6.1f  %5.3f \n',[wstat pvalue]);
  end;
 

  