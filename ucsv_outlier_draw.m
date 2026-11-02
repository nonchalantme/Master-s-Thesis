function [tau,tau_f,sigma_dtau,sigma_eps,g_eps,g_dtau,scale_eps,ps] = ucsv_outlier_draw(y,n_mcmc,sigma_eps,sigma_dtau,scale_eps,ps,g_eps_prior,g_dtau_prior,scl_eps_vec,ps_prior)
  
  % Mixture parameters for log chisquared (1) approximation 
  % r_p are probabilities
  % r_m are means
  % r_s are standard deviations
  
  %{
  % 2-component mixture used in Stock-Watson (2007)
  r_p = [0.086 (1-0.086)]';
  r_m = [-7.472 -0.698]';
  r_s = [1.411 1.411]';
  %}
  
  %{
  % 7-component mixture from Kim, Shephard, and Chib ReStud (1998);
  r_p = [0.00730 0.10556 0.00002 0.04395 0.34001 0.24566 0.25750]';
  r_m = [-10.12999 -3.97281 -8.56686 2.77786 0.61942 1.79518 -1.08819]';
  r_v = [5.79596 2.61369 5.17950 0.16735 0.64009 0.34023 1.26261]';
  r_m = r_m - 1.2704;
  r_s = sqrt(r_v);
  %}
  
  % 10-component mixture from Omori, Chib, Shephard, and Nakajima JOE (2007)
  r_p = [0.00609 0.04775 0.13057 0.20674 0.22715 0.18842 0.12047 0.05591 0.01575 0.00115]';
  r_m = [1.92677 1.34744 0.73504 0.02266 -0.85173 -1.97278 -3.46788 -5.55246 -8.68384 -14.65000]';
  r_v = [0.11265 0.17788 0.26768 0.40611 0.62699 0.98583 1.57469 2.54498 4.16591 7.33342]'; 
  r_s = sqrt(r_v);
  
  T = size(y,1);   % Sample size
  
  n_scl_eps = length(scl_eps_vec);
  ps2 = (1-ps)/(n_scl_eps-1);
  ps2 = ps2*ones(n_scl_eps-1,1);
  prob_scl_eps_vec = [ps ; ps2];
  
  for idraw=1:n_mcmc;
   
  	% Step 1(a): draw tau, tau_f, dtau, and eps; 
  	sigma_eps_scl = sigma_eps.*scale_eps;	  % SD of eps, which is stochastic volatility times scale in mixture distribution 
    [tau_a,tau_f] = draw_tau(y,sigma_dtau,sigma_eps_scl);
    dtau = tau_a(2:end)-tau_a(1:end-1);
    tau = tau_a(2:end);
    eps = y - tau;
    eps_scaled = eps./scale_eps;  % Scaled version of epsilon
  
    % Step 1(b): Draw mixture indicators for log chi-squared(1)
    ind_eps = draw_lcs_indicators(eps_scaled,sigma_eps,r_p,r_m,r_s); 
    ind_dtau = draw_lcs_indicators(dtau,sigma_dtau,r_p,r_m,r_s);
    
    % Step 2(a): Draw G
    g_eps = draw_g(eps_scaled,g_eps_prior,ind_eps,r_m,r_s,1);
    g_dtau = draw_g(dtau,g_dtau_prior,ind_dtau,r_m,r_s,1);
    
    % Step 2(b): Draw Volatilities
    sigma_eps = draw_sigma(eps_scaled,g_eps,ind_eps,r_m,r_s,1);	
    sigma_dtau = draw_sigma(dtau,g_dtau,ind_dtau,r_m,r_s,1);	
    
    % Step 3: Draw Scale of epsilon
    scale_eps = draw_scale_eps(eps,sigma_eps,ind_eps,r_m,r_s,scl_eps_vec,prob_scl_eps_vec);
    
    % Step 4; Draw probability of outlier;
    prob_scl_eps_vec = draw_ps(scale_eps,ps_prior,n_scl_eps);
    ps = prob_scl_eps_vec(1);
    
    % Eliminate any numerical errors resulting in complex values
    tau = real(tau);
    tau_f = real(tau_f);
    sigma_dtau = abs(sigma_dtau);
    sigma_eps = abs(sigma_eps);
    g_eps = abs(g_eps);
    g_dtau = abs(g_dtau);
    scale_eps = abs(scale_eps);
    
  end;
  
end


