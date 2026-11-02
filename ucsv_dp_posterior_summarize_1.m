% ucsv_agg.m -- aggregate inflation
% 9/11/2015, MWW
%


clear all;
small = 1.0e-10;
big = 1.0e+6;                  
rng(663436);
 
  % -- File Directories  
  outdir = '/Users/mwatson/Dropbox/p_comp/revision/matlab/out/';
  figdir = '/Users/mwatson/Dropbox/p_comp/revision/matlab/fig/';
  matdir = '/Users/mwatson/Dropbox/p_comp/revision/matlab/mat/';

  
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
  
%   labvec = {'Headline Inflation';'Core XE';'Core XFE'};
%   namevec = {'dp_agg';'dp_xe';'dp_xfe'};
%   dp = [dp_agg dp_agg_xe dp_agg_xfe];
%   
%   for iseries = 1:size(dp,2);
%     tmp = char(namevec(iseries));
%     ulabel = [tmp '_' outlabel]; 
%     fprintf(['Carrying out Calculations for ' ulabel '\n']);
%     
%     % Read Posterior for g's
%     str_tmp = [matdir 'g_eps_prior_post' ulabel]; load(str_tmp);
%     str_tmp = [matdir 'g_dtau_prior_post' ulabel]; load(str_tmp);
%  
%     tmp = [g_eps_prior_post g_dtau_prior_post(:,end)];
%     fprintf('gam,prior,gam_eps,gam_dtau \n');
%     prtmat_comma_screen(tmp,'%5.2f','\n');
%      
%     
%     % Compute posterior for variances
%     pctvec = [0.05 1/6 0.50 5/6 0.95]';
%    
%     % Read Postetarior for ps's
%     str_tmp = [matdir 'ps_mean_pct' ulabel]; load(str_tmp);
%     pp = 1-ps_mean_pct;
%     fprintf('\n \n \n p \n');
%     prtmat_comma_screen(pp(2:end),'%5.2f','\n');
%     
%   end;
  
  % Read in two independent draws for posterior for tau and plot
  ulabel = 'dp_agg_q3';
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  tau1 = tau_mean_pct;
  ulabel = 'dp_agg_q3_run2';
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  tau2 = tau_mean_pct;
  [tau1(:,1) tau2(:,1)];
  dif = tau1(:,1)-tau2(:,1);
  mean(abs(dif))
  
  