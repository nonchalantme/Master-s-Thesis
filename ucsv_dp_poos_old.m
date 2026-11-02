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
%     
%   % -- Read in Data --- 
%   load_data = 1;  % 1 if reloading data from Excel, etc 
%   mtoq_agg = 0;   % Temporal aggregation indicator of monthly to quarterly data
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
%   outlabel = 'Q0';   
  
  % -- Read in Data --- 
  load_data = 1;  % 1 if reloading data from Excel, etc 
  mtoq_agg = 3;   % Temporal aggregation indicator of monthly to quarterly data
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
  outlabel = 'Q3';
  
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
  tmp = calds_ismpl == repmat(first_date_poos,dnobs_ismpl,1);
  [a,i_first_poos] = max(sum(tmp,2));  % Index in calvec_ismpl of first poos period
  
  % Parameters for UCSV Draws
  % Draws for pre-poos period
  n_burnin = 10000;      % Discarded Draws
  n_draws_save = 5000;   % Number of Draws after burnin
  % Number of MCMC draws for each date and each "t-1" draw of posterior parameters
  n_poos_1 = 100;         % First time through-burnin from t-1 to t;
  n_poos_2 = 5;           % other times through;
  
  % Parameters for scale mixture of epsilon component
  scl_eps_vec = [1; linspace(2.0,10.0,9)'];
  n_scl_eps = length(scl_eps_vec);
  ps_mean = 1 - 1/(4*nper);              % Outlier every 4 years
  ps_prior_obs = nper*10;                % Sample size of 10 years for prior
  ps_prior_a = ps_mean*ps_prior_obs;     % "alpha" in beta prior
  ps_prior_b = (1-ps_mean)*ps_prior_obs; % "beta" in beta prior
  ps_prior = [ps_prior_a ps_prior_b];
  
  % -- Parameters for RW Innovation Variance -- 
  % Gvalues .. for evolution of standard deviations over a year (nper periods)
  ng = 5;      % Number of grid points for approximate uniform prior
  g_dtau_min = 0.001;
  g_dtau_max = 0.20;
  g_dtau_values = linspace(g_dtau_min,g_dtau_max,ng)';
  p_g_dtau_values = ones(ng,1)/ng;
  g_eps_min = 0.001;
  g_eps_max = 0.20;
  g_eps_values = linspace(g_eps_min,g_eps_max,ng)';
  p_g_eps_values = ones(ng,1)/ng;
  % Convert to standard deviation per period
  g_dtau_values = g_dtau_values/sqrt(nper);
  g_eps_values = g_eps_values/sqrt(nper);
  % Convert to g-values for variances instead of standard deviations (ln(s^2) = 2*ln(s))
  g_dtau_values=2*g_dtau_values;
  g_eps_values=2*g_eps_values;
  % Save priors
  g_eps_prior = [g_eps_values p_g_eps_values];
  g_dtau_prior = [g_dtau_values p_g_dtau_values];
   
  for iseries = 3:3;  %1:size(dp,2);
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
    
    % Initial set of draws 
    % Draw for t = i_first_poos;
     t = i_first_poos;
     % Initial priors;
     sigma_eps = ones(t,1);
     sigma_dtau = ones(t,1);
     scale_eps = ones(t,1);
     ps = ps_prior(1)/(ps_prior(1)+ps_prior(2));
     % Burnin Draws;
     tic;
     [tau,tau_f,sigma_dtau,sigma_eps,g_eps,g_dtau,scale_eps,ps] = ucsv_outlier_draw(yn(1:t),n_burnin,sigma_eps,sigma_dtau,scale_eps,ps,g_eps_prior,g_dtau_prior,scl_eps_vec,ps_prior);
     fprintf('  Burnin Finished ');
     toc;
     % MCMC Draws to save at date t
     tic;
     for i = 1:n_draws_save;
       [tau,tau_f,sigma_dtau,sigma_eps,g_eps,g_dtau,scale_eps,ps] = ucsv_outlier_draw(yn(1:t),n_poos_2,sigma_eps,sigma_dtau,scale_eps,ps,g_eps_prior,g_dtau_prior,scl_eps_vec,ps_prior);
       tau_draws(t,i) = tau(end);
       sigma_dtau_draws(t,i) = sigma_dtau(end);
       sigma_eps_draws(t,i) = sigma_eps(end);
       g_eps_draws(t,i) = g_eps;
       g_dtau_draws(t,i) = g_dtau;
       scl_eps_draws(t,i) = scale_eps(end);
       sigmatotal_eps_draws(t,i) = sigma_eps(end)*scale_eps(end); 
       ps_draws(t,i) = ps;
     end;
     fprintf('  Date: %4i %2i  ',calds_ismpl(t,:));
     toc;
     for t = i_first_poos+1:dnobs_ismpl;
       tic;
       tmp = log(sigma_dtau(end)^2 + g_dtau*randn(1,1));
       s_dtau = exp(tmp/2); 
       sigma_dtau = [sigma_dtau; s_dtau];
       tmp = log(sigma_eps(end)^2 + g_eps*randn(1,1));
       s_eps = exp(tmp/2); 
       sigma_eps = [sigma_eps; s_eps];
       ps2 = (1-ps)/(n_scl_eps-1);
       ps2 = ps2*ones(n_scl_eps-1,1);
       prob_scl_eps_vec = [ps ; ps2];
       tmp = mnrnd(1,prob_scl_eps_vec')';
       sc_eps = scl_eps_vec(tmp==1);
       scale_eps = [scale_eps;sc_eps];
       [tau,tau_f,sigma_dtau,sigma_eps,g_eps,g_dtau,scale_eps,ps] = ucsv_outlier_draw(yn(1:t),n_poos_1,sigma_eps,sigma_dtau,scale_eps,ps,g_eps_prior,g_dtau_prior,scl_eps_vec,ps_prior);
       for i = 1:n_draws_save;
         [tau,tau_f,sigma_dtau,sigma_eps,g_eps,g_dtau,scale_eps,ps] = ucsv_outlier_draw(yn(1:t),n_poos_2,sigma_eps,sigma_dtau,scale_eps,ps,g_eps_prior,g_dtau_prior,scl_eps_vec,ps_prior);
         tau_draws(t,i) = tau(end);
         sigma_dtau_draws(t,i) = sigma_dtau(end);
         sigma_eps_draws(t,i) = sigma_eps(end);
         g_eps_draws(t,i) = g_eps;
         g_dtau_draws(t,i) = g_dtau;
         scl_eps_draws(t,i) = scale_eps(end);
         sigmatotal_eps_draws(t,i) = sigma_eps(end)*scale_eps(end); 
         ps_draws(t,i) = ps;
       end;
       fprintf('  Date: %4i %2i  ',calds_ismpl(t,:));
       toc;
     end;
     
     % Rescale so that things are in units of y
     tau_draws = tau_draws*scale_y;
     sigma_dtau_draws = sigma_dtau_draws*scale_y;
     sigma_eps_draws = sigma_eps_draws*scale_y;
     sigmatotal_eps_draws = sigmatotal_eps_draws*scale_y;
     
     
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
      str_tmp = [matdir 'tau_mean_pct' ulabel]; save(str_tmp,'tau_mean_pct');
      tau_mean = mean(tau_draws,2);
      tmp = mean(tau_draws.^2,2);
      tau_var = tmp-tau_mean.^2;
      tau_sd = sqrt(tau_var);
      tau_mean_sd = [tau_mean tau_sd];
      str_tmp = [matdir 'tau_mean_sd' ulabel]; save(str_tmp,'tau_mean_sd');
 
      % Compute posteriors for scale_eps_values
      scl_eps_pct = post_mean_pct(scl_eps_draws',pctvec);
      str_tmp = [matdir 'scl_eps_pct' ulabel]; save(str_tmp,'scl_eps_pct');
    
      % Compute Posterior for g's
      g_eps_mean_pct = post_mean_pct(g_eps_draws',pctvec);
      str_tmp = [matdir 'g_eps_mean_pct' ulabel]; save(str_tmp,'g_eps_mean_pct');
      
       % Compute Posterior for g's
      g_dtau_mean_pct = post_mean_pct(g_dtau_draws',pctvec);
      str_tmp = [matdir 'g_dtau_mean_pct' ulabel]; save(str_tmp,'g_dtau_mean_pct');
      
      % Compute Posterior for ps's
      ps_mean_pct = post_mean_pct(ps_draws',pctvec);
      str_tmp = [matdir 'ps_mean_pct' ulabel]; save(str_tmp,'ps_mean_pct');
     
  end;