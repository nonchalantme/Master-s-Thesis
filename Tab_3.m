% Summary Calculations 
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
  
%   %  % -- Read in Data --- 
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
%   mlabel = '_mucsv_tvp_17c_Q0';  
%   
%   % -- Read in Data --- 
  load_data = 1;  % 1 if reloading data from Excel, etc 
  mtoq_agg = 3;   % Temporal aggregation indicator of monthly to quarterly data
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
  label_suffix = '_Q3';
  mlabel_17 = '_mucsv_tvp_17c_Q3';  
  mlabel_3 = '_mucsv_tvp_3c_Q3';  
%   
%  % -- Read in Data --- 
%   load_data = 1;  % 1 if reloading data from Excel, etc 
%   mtoq_agg = 0;   % Temporal aggregation indicator of monthly to quarterly data
%   pcomp_data_calendar_m_and_q;  
%   % Data Series Used
%   dp_agg = dp_agg_m;
%   dp_agg_xfe = dp_agg_xfe_m;
%   dp_agg_xe = dp_agg_xe_m;
%   dp_disagg = dp_disagg_m;
%   share_avg = share_avg_m;
%   calvec = calvec_m;
%   dnobs = dnobs_m;
%   calds = calds_m;
%   nper = 12;
%   label_suffix = '_M'; 
%   mlabel_17 = '_mucsv_tvp_17c_M';  
%   mlabel_3 = '_mucsv_tvp_3c_M'; 
 
  % Dates
  first_date = [1960 1];
  last_date = calds(end,:);
  ismpl_60_end = smpl(calvec,first_date,last_date,nper);
  cal_60_end = calvec(ismpl_60_end==1);
  dnobs_60_end = size(cal_60_end,1);
  
  outfile_name = [outdir 'Table_3_q3_filt' label_suffix '.out'];
  fileID = fopen(outfile_name,'w');
  
  dp_agg_60_end = dp_agg(ismpl_60_end==1,:);
  dp_agg_xe_60_end = dp_agg_xe(ismpl_60_end==1,:);
  dp_agg_xfe_60_end = dp_agg_xfe(ismpl_60_end==1,:);
  dp_disagg_60_end = dp_disagg(ismpl_60_end==1,:);
  share_avg_60_end = share_avg(ismpl_60_end==1,:);
  
  dpa_agg = zeros(dnobs,1);
  dpa_agg_xe = zeros(dnobs,1);
  dpa_agg_xfe = zeros(dnobs,1);
  dpa_disagg =  zeros(dnobs,n_incl);
  for i = 1:nper;
    dpa_agg(nper:end) = dpa_agg(nper:end)+dp_agg(i:end-nper+i);
    dpa_agg_xe(nper:end) = dpa_agg_xe(nper:end)+dp_agg_xe(i:end-nper+i);
    dpa_agg_xfe(nper:end) = dpa_agg_xfe(nper:end)+dp_agg_xfe(i:end-nper+i);
    dpa_disagg(nper:end,:) = dpa_disagg(nper:end,:)+dp_disagg(i:end-nper+i,:);
  end;
  dpa_agg = dpa_agg/nper;
  dpa_agg_xe = dpa_agg_xe/nper;
  dpa_agg_xfe = dpa_agg_xfe/nper;
  dpa_disagg = dpa_disagg/nper;

  dpa_agg_60_end = dpa_agg(ismpl_60_end==1);
  dpa_agg_xe_60_end = dpa_agg_xe(ismpl_60_end==1);
  dpa_agg_xfe_60_end = dpa_agg_xfe(ismpl_60_end==1);
  dpa_disagg_60_end = dpa_disagg(ismpl_60_end==1,:);
  
  % -- Univariate Filtered and Smoothed Values
  ulabel = ['dp_agg_poos' label_suffix];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  tau_p_mean_pct_h = tau_mean_pct;
  
  ulabel = ['dp_xe_poos' label_suffix];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  tau_p_mean_pct_xe = tau_mean_pct;
  
  ulabel = ['dp_xfe_poos' label_suffix];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  tau_p_mean_pct_xfe = tau_mean_pct;
  
  % -- Some results for the 17-component model
  str_tmp = [matdir 'agg_tau_mean_pct_poos' mlabel_17]; load(str_tmp);
  tau_p_mean_pct_17c = agg_tau_mean_pct;
  
  % -- Some results for the 3-component model
  str_tmp = [matdir 'agg_tau_mean_pct_poos' mlabel_3]; load(str_tmp);
  tau_p_mean_pct_3c = agg_tau_mean_pct;
  
  tmp = [cal_60_end dp_agg_60_end tau_p_mean_pct_17c(:,3:5) tau_p_mean_pct_3c(:,3:5) tau_p_mean_pct_h(:,3:5) tau_p_mean_pct_xe(:,3:5) tau_p_mean_pct_xfe(:,3:5)];
  ismpl = smpl(cal_60_end,[2008 1],last_date,4);
  tmp = tmp(ismpl==1,:);
  prtmat_comma(tmp,fileID,'%6.2f','\n');
  
  
  

  