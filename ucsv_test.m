% ucsv_ep_poos.m 
% 9/28/2015, MWW
% poos analysis
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
   
  labvec = {'Headline Inflation';'Core XFE';'Core XE'};
  namevec = {'dp_agg';'dp_xfe';'dp_xe'};
  dp = [dp_agg dp_agg_xfe dp_agg_xe];

  % Dates
  first_date = [1960 1];
  last_date = calds(end,:);
  ismpl = smpl(calvec,first_date,last_date,nper);
  calvec_ismpl = calvec(ismpl==1);
  calds_ismpl = calds(ismpl==1,:);
  dnobs_ismpl = size(calvec_ismpl,1);
  str_tmp = [matdir 'calvec_ismpl_ucsv_poos']; save(str_tmp,'calvec_ismpl');
  
  % First POOS Date
  first_date_poos = [1990 1];
  first_date_poos = [2014 1];
  tmp = calds_ismpl == repmat(first_date_poos,dnobs_ismpl,1);
  [a,i_first_poos] = max(sum(tmp,2));  % Index in calvec_ismpl of first poos period
  
  % Parameters for UCSV Draws
  % Draws for pre-poos period
  n_burnin = 10000;      % Discarded Draws
  n_draws_save = 5000;   % Number of Draws after burnin
  n_mcmc_first = 5;      % Number of draws between mcmc draws to save for t = first;
  % Number of MCMC draws for each date and each "t-1" draw of posterior parameters
  n_poos_1 = 10;         % First time through;
  n_poos_2 = 5;          % other times through;
  
  % Parameters for scale mixture of epsilon component
  scl_eps_vec = [1; linspace(2.0,10.0,9)'];
  n_scl_eps = length(scl_eps_vec);
  ps_mean = 1 - 1/(5*nper);              % Outlier every 5 years
  ps_prior_obs = nper*10;                % Sample size of 10 years for prior
  ps_prior_a = ps_mean*ps_prior_obs;     % "alpha" in beta prior
  ps_prior_b = (1-ps_mean)*ps_prior_obs; % "beta" in beta prior
  ps_prior = [ps_prior_a ps_prior_b];
  
  % -- Parameters for RW Innovation Variance -- 
  g_values = linspace(0.001,0.5,11)';
  p_g_values = ones(size(g_values,1),1)/size(g_values,1);
  g_eps_prior = [g_values p_g_values];
  g_dtau_prior = [g_values p_g_values];
   
  for iseries = 1:1; %size(dp,2);
    tmp = char(namevec(iseries));
    ulabel = [tmp '_poos_' outlabel]; 
    fprintf(['Carrying out Calculations for ' ulabel '\n']);
    datetime('now');
    y = dp(ismpl==1,iseries);
    % Scale y:  This scale matters because of the off-set parameters "c" in 
    % draw_lcs_indicators and draw_sigma;
    dy = y(2:end)-y(1:end-1);
    inan = isnan(dy);
    std_dy = std(dy(inan==0));
    scale_y = std_dy/5;
    yn = y/scale_y;
    
    % Matrices for saving results
    tau_draws = NaN*zeros(dnobs_ismpl,n_draws_save);
    sigma_dtau_draws = NaN*zeros(dnobs_ismpl,n_draws_save);
    sigma_eps_draws = NaN*zeros(dnobs_ismpl,n_draws_save);
    g_eps_draws = NaN*zeros(dnobs_ismpl,n_draws_save);
    g_dtau_draws = NaN*zeros(dnobs_ismpl,n_draws_save);
    scale_eps_draws = NaN*zeros(dnobs_ismpl,n_draws_save);
    sigmatotal_eps_draws = NaN*zeros(dnobs_ismpl,n_draws_save);
    ps_draws = NaN*zeros(dnobs_ismpl,n_draws_save);
    
    
    n_burnin = 10000;
    n_draws_save = 5000;
    k_draws = 10;
    n_draws = k_draws*n_draws_save;
%     % Method 1
%     tic
%     [tau_draws,tau_f_draws,sigma_dtau_draws,sigma_eps_draws,g_eps_draws,g_dtau_draws,scl_eps_draws,sigmatotal_eps_draws,ps_draws] = ucsv_outlier(y,n_burnin,n_draws,k_draws,g_eps_prior,g_dtau_prior,scl_eps_vec,ps_prior);
%     fprintf('Method 1 '); 
%     toc
%     % Print last draw of tau and sigma_eps;
%     tau_draws(end,end)
%     sigma_eps_draws(end,end)
    
    
    % Method 2
    % Matrices for saving results
    tau_draws = NaN*zeros(dnobs_ismpl,n_draws_save);
    sigma_dtau_draws = NaN*zeros(dnobs_ismpl,n_draws_save);
    sigma_eps_draws = NaN*zeros(dnobs_ismpl,n_draws_save);
    g_eps_draws = NaN*zeros(dnobs_ismpl,n_draws_save);
    g_dtau_draws = NaN*zeros(dnobs_ismpl,n_draws_save);
    scale_eps_draws = NaN*zeros(dnobs_ismpl,n_draws_save);
    sigmatotal_eps_draws = NaN*zeros(dnobs_ismpl,n_draws_save);
    ps_draws = NaN*zeros(dnobs_ismpl,n_draws_save);
     
    % Initial priors;
     sigma_eps = ones(dnobs_ismpl,1);
     sigma_dtau = ones(dnobs_ismpl,1);
     scale_eps = ones(dnobs_ismpl,1);
     ps = ps_prior(1)/(ps_prior(1)+ps_prior(2));
     % Burnin Draws;
     tic;
     [tau,tau_f,sigma_dtau,sigma_eps,g_eps,g_dtau,scale_eps,ps] = ucsv_outlier_draw(yn,n_burnin,sigma_eps,sigma_dtau,scale_eps,ps,g_eps_prior,g_dtau_prior,scl_eps_vec,ps_prior);
     fprintf('  Burnin Finished ');
     % MCMC Draws to save at date t
     t = dnobs_ismpl;
     for i = 1:n_draws_save;
       [tau,tau_f,sigma_dtau,sigma_eps,g_eps,g_dtau,scale_eps,ps] = ucsv_outlier_draw(yn,k_draws,sigma_eps,sigma_dtau,scale_eps,ps,g_eps_prior,g_dtau_prior,scl_eps_vec,ps_prior);
       tau_draws(t,i) = tau(end);
       sigma_dtau_draws(t,i) = sigma_dtau(end);
       sigma_eps_draws(t,i) = sigma_eps(end);
       g_eps_draws(t,i) = g_eps;
       g_dtau_draws(t,i) = g_dtau;
       scl_eps_draws(t,i) = scale_eps(end);
       sigmatotal_eps_draws(t,i) = sigma_eps(end)*scale_eps(end); 
       ps_draws(t,i) = ps;
     end;
    fprintf('Method 2 '); 
    toc
    % Print last draw of tau and sigma_eps;
    tau_draws(end,end)*scale_y;
    sigma_eps_draws(end,end)*scale_y;
    error('tmp');
    
    
   
     
  end;