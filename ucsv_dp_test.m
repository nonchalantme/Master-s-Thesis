% ucsv_agg.m -- aggregate inflation
% 9/11/2015, MWW
%


clear all;
small = 1.0e-10;
big = 1.0e+6;                  
rng(663436);
 
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
  calvec = calvec_q;
  dnobs = dnobs_q;
  calds = calds_q;
  nper = 4;
  outlabel = 'Q0';  
  
%   % -- Read in Data --- 
%   load_data = 1;  % 1 if reloading data from Excel, etc 
%   mtoq_agg = 3;   % Temporal aggregation indicator of monthly to quarterly data
%   pcomp_data_calendar_m_and_q;
%   % Data Series Used
%   dp_agg = dp_agg_q;
%   dp_agg_xfe = dp_agg_xfe_q;
%   dp_agg_xe = dp_agg_xe_q;
%   dp_disagg = dp_disagg_q;
%   calvec = calvec_q;
%   dnobs = dnobs_q;
%   calds = calds_q;
%   nper = 4;
%   outlabel = 'Q3';
  
%  % -- Read in Data --- 
%   load_data = 1;  % 1 if reloading data from Excel, etc 
%   mtoq_agg = 0;   % Temporal aggregation indicator of monthly to quarterly data
%   pcomp_data_calendar_m_and_q;  
%   % Data Series Used
%   dp_agg = dp_agg_m;
%   dp_agg_xfe = dp_agg_xfe_m;
%   dp_agg_xe = dp_agg_xe_m;
%   dp_disagg = dp_disagg_m;
%   calvec = calvec_m;
%   dnobs = dnobs_m;
%   calds = calds_m;
%   nper = 12;
%   outlabel = 'M';
   
  labvec = {'Headline Inflation';'Core XFE';'Core XE'};
  labvec = [labvec;labelvec_short_disagg];
  namevec = {'dp_agg';'dp_xfe';'dp_xe'};
  namevec = [namevec;namevec_disagg];
  dp = [dp_agg dp_agg_xfe dp_agg_xe dp_disagg];

  % Dates
  first_date = [1960 1];
  last_date = calds(end,:);
  ismpl = smpl(calvec,first_date,last_date,nper);
  calvec_ismpl = calvec(ismpl==1);
  dnobs_ismpl = size(calvec_ismpl,1);
  str_tmp = [matdir 'calvec_ismpl_ucsv']; save(str_tmp,'calvec_ismpl');
  
  % Parameters for UCSV Draws
  n_burnin = 500;   % Discarded Draws
  n_draws =  5;   % Number of Draws after burnin
  k_draws = 100; % Save results every k_draws
  
  % Parameters for scale mixture of epsilon component
  scl_eps_vec = [1; linspace(2.0,10.0,9)'];
  ps_mean = 1 - 1/(5*nper);              % Outlier every 5 years
  ps_prior_obs = nper*10;                % Sample size of 10 years for prior
  ps_prior_a = ps_mean*ps_prior_obs;     % "alpha" in beta prior
  ps_prior_b = (1-ps_mean)*ps_prior_obs; % "beta" in beta prior
  ps_prior = [ps_prior_a ps_prior_b];
  
  % -- Parameters for RW Innovation Variance -- 
  g_values = linspace(0,0.5,11)';
  p_g_values = ones(size(g_values,1),1)/size(g_values,1);
  g_eps_prior = [g_values p_g_values];
  g_dtau_prior = [g_values p_g_values];
   
  for iseries = 1:size(dp,2);
    tmp = char(namevec(iseries));
    ulabel = [tmp '_' outlabel]; 
    fprintf(['Carrying out Calculations for ' ulabel '\n']);
    
    y = dp(ismpl==1,iseries);
    tic
    [tau_draws,tau_f_draws,sigma_dtau_draws,sigma_eps_draws,g_eps_draws,g_dtau_draws,scl_eps_draws,sigmatotal_eps_draws,ps_draws] = ucsv_outlier_test(y,n_burnin,n_draws,k_draws,g_eps_prior,g_dtau_prior,scl_eps_vec,ps_prior);
    toc
    error('tmp');
    
    
    % IMA(1,1) Parameters
    lam0=(sigma_dtau_draws.^2)+2*(sigma_eps_draws.^2);
    rho1=-(sigma_eps_draws.^2)./lam0;
    theta_draws=-(ones(size(rho1))-sqrt(ones(size(rho1))-4*rho1.^2))./(2*rho1);
    var_a=lam0./(ones(size(rho1))+theta_draws.^2);
    sigma_a_draws=sqrt(var_a);
 
    % Compute Posterior for g's
    g_eps_prior_post = g_summary(g_eps_prior,g_eps_draws);
    g_dtau_prior_post = g_summary(g_dtau_prior,g_dtau_draws);
    str_tmp = [matdir 'g_eps_prior_post' ulabel]; save(str_tmp,'g_eps_prior_post');
    str_tmp = [matdir 'g_dtau_prior_post' ulabel]; save(str_tmp,'g_dtau_prior_post');
 
    % Compute posterior for variances
    pctvec = [0.05 1/6 0.50 5/6 0.95]';
    tmp = sigma_dtau_draws.^2;
    var_dtau_mean_pct = post_mean_pct(tmp',pctvec);
    tmp = sigma_eps_draws.^2;
    var_eps_mean_pct = post_mean_pct(tmp',pctvec);
    tmp = sigmatotal_eps_draws.^2;
    vartotal_eps_mean_pct = post_mean_pct(tmp',pctvec);
    str_tmp = [matdir 'var_eps_mean_pct' ulabel]; save(str_tmp,'var_eps_mean_pct');
    str_tmp = [matdir 'var_dtau_mean_pct' ulabel]; save(str_tmp,'var_dtau_mean_pct');
    str_tmp = [matdir 'vartotal_eps_mean_pct' ulabel]; save(str_tmp,'vartotal_eps_mean_pct');
 
    % Compute posteriors for trend values
    tau_mean_pct = post_mean_pct(tau_draws',pctvec);
    tau_f_mean_pct = post_mean_pct(tau_f_draws',pctvec);
    str_tmp = [matdir 'tau_mean_pct' ulabel]; save(str_tmp,'tau_mean_pct');
    str_tmp = [matdir 'tau_f_mean_pct' ulabel]; save(str_tmp,'tau_f_mean_pct');
    tau_f_mean = mean(tau_f_draws,2);
    tmp = mean(tau_f_draws.^2,2);
    tau_f_var = tmp-tau_f_mean.^2;
    tau_f_sd = sqrt(tau_f_var);
    tau_f_mean_sd = [tau_f_mean tau_f_sd];
    str_tmp = [matdir 'tau_f_mean_sd' ulabel]; save(str_tmp,'tau_f_mean_sd');
  
    tau_mean = mean(tau_draws,2);
    tmp = mean(tau_draws.^2,2);
    tau_var = tmp-tau_mean.^2;
    tau_sd = sqrt(tau_var);
    tau_mean_sd = [tau_mean tau_sd];
    str_tmp = [matdir 'tau_mean_sd' ulabel]; save(str_tmp,'tau_mean_sd');
 
    % Compute posteriors for MA parameter
    theta_mean_pct = post_mean_pct(theta_draws',pctvec);
    sigma_a_mean_pct = post_mean_pct(sigma_a_draws',pctvec);
    str_tmp = [matdir 'theta_mean_pct' ulabel]; save(str_tmp,'theta_mean_pct');
    str_tmp = [matdir 'sigma_a_mean_pct' ulabel]; save(str_tmp,'sigma_a_mean_pct');
 
    % Compute posteriors for scale_eps_values
    pctvec = [1/6 0.50 5/6]';
    scl_eps_pct = post_mean_pct(scl_eps_draws',pctvec);
    str_tmp = [matdir 'scl_eps_pct' ulabel]; save(str_tmp,'scl_eps_pct');
    
    % Compute Posterior for ps's
    ps_mean_pct = post_mean_pct(ps_draws,pctvec);
    str_tmp = [matdir 'ps_mean_pct' ulabel]; save(str_tmp,'ps_mean_pct');
    
  end;