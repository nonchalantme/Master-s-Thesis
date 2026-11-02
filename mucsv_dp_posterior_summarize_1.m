% mucsv_agg.m -- aggregate inflation
% 11/2/2015, MWW
%


clear all;
small = 1.0e-10;
big = 1.0e+6;                  
rng(663436);
 
  % -- File Directories  
  outdir = '/Users/HP/OneDrive/Master Thesis/Watson, core iflation/matlabfiles/matlab/out/';
  figdir = '/Users/HP/OneDrive/Master Thesis/Watson, core iflation/matlabfiles/matlab/fig/';
  matdir = '/Users/HP/OneDrive/Master Thesis/Watson, core iflation/matlabfiles/matlab/mat/';   

%   % -- Read in Data --- 
%   load_data = 1;  % 1 if reloading data from Excel, etc 
%   mtoq_agg = 3;   % Temporal aggregation indicator of monthly to quarterly data
%   pcomp_data_calendar_m_and_q;
%   % Data Series Used
%   dp_agg = dp_agg_q;
%   dp_agg_xfe = dp_agg_xfe_q;
%   dp_agg_xe = dp_agg_xe_q;
%   dp_disagg = dp_disagg_q;
%   share_avg = share_avg_q;
%   share_avg_xfe = share_avg_xfe_q;
%   share_avg_xe = share_avg_xe_q;
%   calvec = calvec_q;
%   dnobs = dnobs_q;
%   calds = calds_q;
%   nper = 4;
%   mlabel = '_mucsv_tvp_17c_Q3';
  
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
  share_avg_xfe = share_avg_3comp_xfe_q;
  share_avg_xe = share_avg_3comp_xe_q;
  calvec = calvec_q;
  dnobs = dnobs_q;
  calds = calds_q;
  nper = 4;
  mlabel = '_mucsv_tvp_3c_Q3';
  labelvec_disagg = labelvec_disagg_3comp;
  labelvec_short_disagg = labelvec_disagg_3comp;
  namevec_disagg = namevec_disagg_3comp;
  n_incl = n_incl_3comp;

  str_tmp = [matdir 'g_eps_common_prior_post' mlabel]; load(str_tmp);
  str_tmp = [matdir 'g_dtau_common_prior_post' mlabel]; load(str_tmp);
  str_tmp = [matdir 'ps_common_mean_pct' mlabel]; load(str_tmp);
  
  % Read in Sector-Specific posteriors
  str_tmp = [matdir 'g_eps_unique_prior_post' mlabel]; load(str_tmp);
  str_tmp = [matdir 'g_dtau_unique_prior_post' mlabel]; load(str_tmp);
  str_tmp = [matdir 'ps_unique_mean_pct' mlabel]; load(str_tmp);
  
  fprintf('ps_common \n');
  tmp = 1-ps_common_mean_pct;
  tmp
  
  fprintf('g_dtau_common \n');
  g_dtau_common_prior_post
  
  fprintf('g_eps_common \n');
  g_eps_common_prior_post
  
  fprintf('Outlier Probability \n');
  p = 1-ps_unique_mean_pct;
  for i = 1:n_incl;
    str = char(labelvec_short_disagg(i));
    fprintf(['%2i, ' str ','],i);
    tmp = p(i,[5 4 3]);
    prtmat_comma_screen(tmp,'%4.2f','\n');
  end;

  fprintf('\n\n\n');
  fprintf('Gamma delta-tau \n');
  tmp = g_dtau_unique_prior_post(:,1)';
  fprintf('Value ,');
  prtmat_comma_screen(tmp,'%4.2f','\n');
  tmp = g_dtau_unique_prior_post(:,2)';
  fprintf('Prior ,');
  prtmat_comma_screen(tmp,'%4.2f','\n');
  for i = 1:n_incl;
    str = char(labelvec_short_disagg(i));
    fprintf([str ',']);
    tmp = g_dtau_unique_prior_post(:,i+2)';
    prtmat_comma_screen(tmp,'%4.2f','\n');
  end;
  
  fprintf('\n\n\n');
  fprintf('Gamma epsilon \n');
  tmp = g_eps_unique_prior_post(:,1)';
  fprintf('Value ,');
  prtmat_comma_screen(tmp,'%4.2f','\n');
  tmp = g_eps_unique_prior_post(:,2)';
  fprintf('Prior ,');
  prtmat_comma_screen(tmp,'%4.2f','\n');
  for i = 1:n_incl;
    str = char(labelvec_short_disagg(i));
    fprintf([str ',']);
    tmp = g_eps_unique_prior_post(:,i+2)';
    prtmat_comma_screen(tmp,'%4.2f','\n');
  end;