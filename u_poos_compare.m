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
  
%  % -- Read in Data --- 
%   load_data = 1;  % 1 if reloading data from Excel, etc 
%   mtoq_agg = 0;   % Temporal aggregation indicator of monthly to quarterly data
%   pcomp_data_calendar_m_and_q;  
%   % Data Series Used
%   dp_agg = dp_agg_q;
%   dp_agg_xfe = dp_agg_xfe_q;
%   dp_agg_xe = dp_agg_xe_q;
%   dp_disagg = dp_disagg_q;
%   share_avg = share_avg_q;
%   calvec = calvec_q;
%   dnobs = dnobs_q;
%   calds = calds_q;
%   nper = 4;
%   label_suffix = '_Q0';  
  
%  % -- Read in Data --- 
%   load_data = 1;  % 1 if reloading data from Excel, etc 
%   mtoq_agg = 3;   % Temporal aggregation indicator of monthly to quarterly data
%   pcomp_data_calendar_m_and_q;  
%   Data Series Used
%   dp_agg = dp_agg_q;
%   dp_agg_xfe = dp_agg_xfe_q;
%   dp_agg_xe = dp_agg_xe_q;
%   dp_disagg = dp_disagg_q;
%   share_avg = share_avg_q;
%   calvec = calvec_q;
%   dnobs = dnobs_q;
%   calds = calds_q;
%   nper = 4;
%   label_suffix = '_Q3'; 
  
    % -- Read in Data --- 
  load_data = 1;  % 1 if reloading data from Excel, etc 
  mtoq_agg = 3;   % Temporal aggregation indicator of monthly to quarterly data
  pcomp_data_calendar_m_and_q;  
  % Data Series Used
  dp_agg = dp_agg_m;
  dp_agg_xfe = dp_agg_xfe_m;
  dp_agg_xe = dp_agg_xe_m;
  dp_disagg = dp_disagg_m;
  share_avg = share_avg_m;
  calvec = calvec_m;
  dnobs = dnobs_m;
  calds = calds_m;
  nper = 12;
  label_suffix = '_M'; 
  
  % Dates
  first_date = [1960 1];
  last_date = calds(end,:);
  ismpl = smpl(calvec,first_date,last_date,nper);
  calvec_ismpl = calvec(ismpl==1);
  calds_ismpl = calds(ismpl==1,:);
  dnobs_ismpl = size(calvec_ismpl,1);
  
  y = dp_agg_xfe(ismpl==1);
  ystr = 'dp_xfe';
  ulabel = [ystr label_suffix];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'tau_f_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'var_dtau_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'vartotal_eps_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'var_eps_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'scl_eps_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'g_eps_prior_post' ulabel]; load(str_tmp);
  str_tmp = [matdir 'g_dtau_prior_post' ulabel]; load(str_tmp);
  tau_fs = tau_mean_pct;
  tau_f_fs = tau_f_mean_pct;
  var_dtau_fs = var_dtau_mean_pct;
  var_eps_fs = var_eps_mean_pct;
  vartotal_eps_fs = vartotal_eps_mean_pct;
  scl_fs = scl_eps_pct;
  
  
  
  ulabel = [ystr '_poos' label_suffix];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'var_dtau_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'vartotal_eps_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'var_eps_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'g_eps_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'g_dtau_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'scl_eps_pct' ulabel]; load(str_tmp);
  tau_p = tau_mean_pct;
  var_dtau_p = var_dtau_mean_pct;
  var_eps_p = var_eps_mean_pct;
  vartotal_eps_p = vartotal_eps_mean_pct;
  g_eps_p = g_eps_mean_pct;
  g_dtau_p = g_dtau_mean_pct;
  scl_p = scl_eps_pct;
  
  
  fs = [tau_f_fs(:,4) sqrt([var_eps_fs(:,4) var_dtau_fs(:,4)]) scl_fs(:,4)];
  poos = [tau_p(:,4) sqrt([var_eps_p(:,4) var_dtau_p(:,4)]) scl_p(:,4) g_eps_p(:,4) g_dtau_p(:,4)];
  
  [calds_ismpl/1000 y fs poos]
  