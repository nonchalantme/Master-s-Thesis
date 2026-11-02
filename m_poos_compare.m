% Compare poos to full sample estimates
%


clear all;
small = 1.0e-10;
big = 1.0e+6;                  
rng(63761);
 
 % -- File Directories  
  outdir = '/Users/HP/OneDrive/Master Thesis/Watson, core iflation/matlabfiles/matlab/out/';
  figdir = '/Users/HP/OneDrive/Master Thesis/Watson, core iflation/matlabfiles/matlab/fig/';
  matdir = '/Users/HP/OneDrive/Master Thesis/Watson, core iflation/matlabfiles/matlab/mat/';   
  
%   % -- Read in Data --- 
%   load_data = 1;  % 1 if reloading data from Excel, etc 
%   mtoq_agg = 0;   % Temporal aggregation indicator of monthly to quarterly data
%   pcomp_data_calendar_m_and_q;  
%   % Data Series Used
%   dp_agg = dp_agg_q;
%   dp_agg_xfe = dp_agg_xfe_q;
%   dp_agg_xe = dp_agg_xe_q;
%   dp_disagg = dp_disagg_3comp_q;
%   share_avg = share_avg_3comp_q;
%   calvec = calvec_q;
%   dnobs = dnobs_q;
%   calds = calds_q;
%   nper = 4;
%   mlabel = '_mucsv_tvp_3c_Q0';  
  
 % -- Read in Data --- 
  load_data = 1;  % 1 if reloading data from Excel, etc 
  mtoq_agg = 3;   % Temporal aggregation indicator of monthly to quarterly data
  pcomp_data_calendar_m_and_q;
  %  Data Series Used
  dp_agg = dp_agg_q;
  dp_agg_xfe = dp_agg_xfe_q;
  dp_agg_xe = dp_agg_xe_q;
  dp_disagg = dp_disagg_3comp_q;
  share_avg = share_avg_3comp_q;
  calvec = calvec_q;
  dnobs = dnobs_q;
  calds = calds_q;
  nper = 4;
  mlabel = '_mucsv_tvp_17c_Q3';
  
%  % -- Read in Data --- 
%   load_data = 1;  % 1 if reloading data from Excel, etc 
%   mtoq_agg = 0;   % Temporal aggregation indicator of monthly to quarterly data
%   pcomp_data_calendar_m_and_q;  
%   % Data Series Used
%   dp_agg = dp_agg_m;
%   dp_agg_xfe = dp_agg_xfe_m;
%   dp_agg_xe = dp_agg_xe_m;
%   dp_disagg = dp_disagg_3comp_m;
%   share_avg = share_avg_3comp_m;
%   calvec = calvec_m;
%   dnobs = dnobs_m;
%   calds = calds_m;
%   nper = 12;
%   mlabel = '_mucsv_tvp_3c_M';
  
  % Dates
  first_date = [1960 1];
  last_date = calds(end,:);
  ismpl = smpl(calvec,first_date,last_date,nper);
  calvec_ismpl = calvec(ismpl==1);
  calds_ismpl = calds(ismpl==1,:);
  dnobs_ismpl = size(calvec_ismpl,1);
  
  str_tmp = [matdir 'agg_tau_mean_pct_poos' mlabel]; 
  load(str_tmp);
  filt = agg_tau_mean_pct;
  
  str_tmp = [matdir 'agg_tau_mean_pct' mlabel]; 
  load(str_tmp);
  qfilt = agg_tau_mean_pct;
  
  y = dp_agg(ismpl==1);
  
  
  [calds_ismpl/1000 y qfilt(:,1) filt(:,1) qfilt(:,1)-filt(:,1) ]
  
  