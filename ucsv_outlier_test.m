function [tau_draws,tau_f_draws,sigma_dtau_draws,sigma_eps_draws,g_eps_draws,g_dtau_draws,scale_eps_draws,sigmatotal_eps_draws,ps_draws] = ucsv_outlier_test(y,n_burnin,n_draws_save,k_draws,g_eps_prior,g_dtau_prior,scl_eps_vec,ps_prior)
   
  T = size(y,1);   % Sample size
  
  % Scale y:  This scale matters because of the off-set parameters "c" in 
  % draw_lcs_indicators and draw_sigma;
  dy = y(2:end)-y(1:end-1);
  inan = isnan(dy);
  std_dy = std(dy(inan==0));
  scale_y = std_dy/5;
  yn = y/scale_y;
  
  % Matrices for saving results
  tau_draws = NaN*zeros(T,n_draws_save);
  tau_f_draws = NaN*zeros(T,n_draws_save);
  sigma_dtau_draws = NaN*zeros(T,n_draws_save);
  sigma_eps_draws = NaN*zeros(T,n_draws_save);
  g_eps_draws = NaN*zeros(n_draws_save,1);
  g_dtau_draws = NaN*zeros(n_draws_save,1);
  scale_eps_draws = NaN*zeros(T,n_draws_save);
  sigmatotal_eps_draws = NaN*zeros(T,n_draws_save);
  ps_draws = NaN*zeros(n_draws_save,1);
  
  % -- Begin Calculations: sigma = 1 and scale_eps is unity;
  sigma_eps = ones(T,1);
  sigma_dtau = ones(T,1);
  scale_eps = ones(T,1);
  
  % Initial value of ps is the mean;
  n_scl_eps = length(scl_eps_vec);
  ps = ps_prior(1)/(ps_prior(1)+ps_prior(2));
  
  [tau,tau_f,sigma_dtau,sigma_eps,g_eps,g_dtau,scale_eps,ps] = ucsv_outlier_draw(yn,n_burnin,sigma_eps,sigma_dtau,scale_eps,ps,g_eps_prior,g_dtau_prior,scl_eps_vec,ps_prior);
  for i = 1:n_draws_save;
   [tau,tau_f,sigma_dtau,sigma_eps,g_eps,g_dtau,scale_eps,ps] = ucsv_outlier_draw(yn,k_draws,sigma_eps,sigma_dtau,scale_eps,ps,g_eps_prior,g_dtau_prior,scl_eps_vec,ps_prior);  
   tau_draws(:,i) = tau;
   tau_f_draws(:,i) = tau_f;
   sigma_dtau_draws(:,i) = sigma_dtau;
   sigma_eps_draws(:,i) = sigma_eps;
   g_eps_draws(i) = g_eps;
   g_dtau_draws(i) = g_dtau;
   scale_eps_draws(:,i) = scale_eps;
   sigmatotal_eps_draws(:,i) = sigma_eps.*scale_eps;
   ps_draws(i) = ps;
  end;
  
  % Rescale so that things are in units of y
  tau_draws = tau_draws*scale_y;
  tau_f_draws = tau_f_draws*scale_y;
  sigma_dtau_draws = sigma_dtau_draws*scale_y;
  sigma_eps_draws = sigma_eps_draws*scale_y;
  sigmatotal_eps_draws = sigmatotal_eps_draws*scale_y;
 
end
