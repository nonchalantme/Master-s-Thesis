% Summary Calculations -- Figures 1, 2, 3, 4, and 10
% May 17, 2015
%


clear all;
small = 1.0e-10;
big = 1.0e+6;                  
rng(63761);
 
 % -- File Directories  
  outdir = '/Users/HP/OneDrive/Master Thesis/Watson, core iflation/matlabfiles/matlab/out/';
  figdir = '/Users/HP/OneDrive/Master Thesis/Watson, core iflation/matlabfiles/matlab/fig/';
  matdir = '/Users/HP/OneDrive/Master Thesis/Watson, core iflation/matlabfiles/matlab/mat/';
  
 % -- Read in Data --- 
  load_data = 1;  % 1 if reloading data from Excel, etc 
  mtoq_agg = 0;   % Temporal aggregation indicator of monthly to quarterly data
  pcomp_data_calendar_m_and_q;  
  % Data Series Used
  dp_agg = dp_agg_q;
  dp_agg_xfe = dp_agg_xfe_q;
  dp_agg_xe = dp_agg_xe_q;
  dp_disagg = dp_disagg_q;
  share_avg = share_avg_q;
  calvec = calvec_q;
  dnobs = dnobs_q;
  calds = calds_q;
  nper = 4;
  label_suffix = '_Q0';  
  
  ulabel = ['dp_agg' label_suffix];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'tau_f_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'var_dtau_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'vartotal_eps_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'var_eps_mean_pct' ulabel]; load(str_tmp);
  tau_1 = tau_mean_pct;
  var_dtau_1 = var_dtau_mean_pct;
  var_eps_1 = var_eps_mean_pct;
  
  ulabel = ['dp_agg_poos' label_suffix];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'var_dtau_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'vartotal_eps_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'var_eps_mean_pct' ulabel]; load(str_tmp);
  tau_2 = tau_mean_pct;
  var_dtau_2 = var_dtau_mean_pct;
  var_eps_2 = var_eps_mean_pct;
  