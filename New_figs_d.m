% Summary Calculations 
% June 5, 2015
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
  mlabel = '_mucsv_tvp_17c_Q3';
  
  % Dates
  first_date = [1960 1];
  last_date = calds(end,:);
  ismpl_60_end = smpl(calvec,first_date,last_date,4);
  cal_60_end = calvec(ismpl_60_end==1);
  dnobs_60_end = size(cal_60_end,1);
  
  dp_agg_60_end = dp_agg(ismpl_60_end==1,:);
  dp_agg_xe_60_end = dp_agg_xe(ismpl_60_end==1,:);
  dp_agg_xfe_60_end = dp_agg_xfe(ismpl_60_end==1,:);
  dp_disagg_60_end = dp_disagg(ismpl_60_end==1,:);
  share_avg_60_end = share_avg(ismpl_60_end==1,:);
  
 
  str_tmp = [matdir 'agg_tau_mean_sd' mlabel]; load(str_tmp);
  tau_s_17c = agg_tau_mean_sd(:,1);
  str_tmp = [matdir 'agg_tau_mean_pct' mlabel]; load(str_tmp);
  tau_s_mean_pct_17c = agg_tau_mean_pct;
  str_tmp = [matdir 'disagg_tau_mean' mlabel]; load(str_tmp);
  dis_tau_s_17c = disagg_tau_mean;
%   % Compute 3-Components from 17
%   s = share_avg(ismpl_60_end==1,:);
%   ifood = 5;
%   ienergy = [7 10];
%   icore = [1:4 6 8:9 11:17];
%   s_energy = s(:,ienergy);
%   s_energy = s_energy./repmat(sum(s_energy,2),1,2);
%   s_core = s(:,icore);
%   s_core = s_core./repmat(sum(s_core,2),1,14);
%   tau_f_17c_food = dis_tau_f_17c(:,ifood);
%   tau_f_17c_energy = sum(dis_tau_f_17c(:,ienergy).*s_energy,2);
%   tau_f_17c_core = sum(dis_tau_f_17c(:,icore).*s_core,2);
%   tau_s_17c_food = dis_tau_s_17c(:,ifood);
%   tau_s_17c_energy = sum(dis_tau_s_17c(:,ienergy).*s_energy,2);
%   tau_s_17c_core = sum(dis_tau_s_17c(:,icore).*s_core,2); 

  % -- Mean Values of Parameters
  str_tmp = [matdir 'alpha_eps_mean' mlabel]; load(str_tmp);
  str_tmp = [matdir 'alpha_tau_mean' mlabel]; load(str_tmp);
  str_tmp = [matdir 'alpha_eps_mean_pct' mlabel]; load(str_tmp);
  str_tmp = [matdir 'alpha_tau_mean_pct' mlabel]; load(str_tmp);
  str_tmp = [matdir 'sigma_eps_common_mean' mlabel]; load(str_tmp);
  str_tmp = [matdir 'sigma_eps_common_total_mean' mlabel]; load(str_tmp);
  str_tmp = [matdir 'sigma_eps_unique_mean' mlabel]; load(str_tmp);
  str_tmp = [matdir 'sigma_eps_unique_total_mean' mlabel]; load(str_tmp); 
  str_tmp = [matdir 'sigma_dtau_common_mean' mlabel]; load(str_tmp); 
  str_tmp = [matdir 'sigma_dtau_unique_mean' mlabel]; load(str_tmp);
  str_tmp = [matdir 'var_eps_common_mean' mlabel]; load(str_tmp);
  str_tmp = [matdir 'var_eps_common_total_mean' mlabel]; load(str_tmp);
  str_tmp = [matdir 'var_eps_unique_mean' mlabel]; load(str_tmp);
  str_tmp = [matdir 'var_eps_unique_total_mean' mlabel]; load(str_tmp); 
  str_tmp = [matdir 'var_y_eps_unique_mean_pct' mlabel]; load(str_tmp); 
  str_tmp = [matdir 'var_dtau_common_mean' mlabel]; load(str_tmp); 
  str_tmp = [matdir 'var_dtau_unique_mean' mlabel]; load(str_tmp);
  alpha_eps_17c = alpha_eps_mean;
  alpha_tau_17c = alpha_tau_mean;
  alpha_eps_pct_17c = alpha_eps_mean_pct;
  alpha_tau_pct_17c = alpha_tau_mean_pct;
  sigma_eps_common_17c = sigma_eps_common_mean;
  sigma_eps_common_total_17c = sigma_eps_common_total_mean;
  sigma_eps_unique_17c = sigma_eps_unique_mean;
  sigma_eps_unique_total_17c = sigma_eps_unique_mean;
  sigma_dtau_common_17c = sigma_dtau_common_mean;
  sigma_dtau_unique_17c = sigma_dtau_unique_mean;
  
  var_eps_common_17c = var_eps_common_mean;
  var_eps_common_total_17c = var_eps_common_total_mean;
  var_eps_unique_17c = var_eps_unique_mean;
  var_eps_unique_total_17c = var_eps_unique_total_mean;
  var_eps_unique_pct_17c = var_y_eps_unique_mean_pct;
  var_dtau_common_17c = var_dtau_common_mean;
  var_dtau_unique_17c = var_dtau_unique_mean;
  
% % -- Figures 7-9
% % --- Figure 7
% j = 14;
% %j = 5;
% %j = 2;
% alpha_eps_j = reshape(alpha_eps_pct_17c(:,:,j),dnobs_60_end,6);
% alpha_tau_j = reshape(alpha_tau_pct_17c(:,:,j),dnobs_60_end,6);
% sigma_eps_j = sqrt(reshape(var_eps_unique_pct_17c(:,:,j),dnobs_60_end,6));
% figure;
% subplot(2,2,1);
%    plot(cal_60_end,dp_agg_60_end,': b','LineWidth',2);
%    hold on;
%      plot(cal_60_end,dp_disagg_60_end(:,j),'- k','LineWidth',1);
%      plot(cal_60_end,dis_tau_s_17c(:,j),'-- r','LineWidth',3);
%    hold off;
%  
%   tmp = char(labelvec_short_disagg(j));
%   titstr =['(a) ' tmp ': Inflation rates and trend']; 
%   title(titstr);
%   ax = gca;
%   ax.FontSize = 20;
%   ax.XLim = [1960 2015];
% subplot(2,2,2);
%   plot(cal_60_end,alpha_tau_j(:,1),'- k','LineWidth',3);
%    hold on;
%      plot(cal_60_end,alpha_tau_j(:,3),'-- k','LineWidth',3);
%      plot(cal_60_end,alpha_tau_j(:,5),'-- k','LineWidth',3);
%    hold off;
%   title('(b) \alpha_{\tau}');
%   ax = gca;
%   ax.FontSize = 20;
%   ax.XLim = [1960 2015];
% subplot(2,2,3);
%   plot(cal_60_end,alpha_eps_j(:,1),'- k','LineWidth',3);
%    hold on;
%      plot(cal_60_end,alpha_eps_j(:,3),'-- k','LineWidth',3);
%      plot(cal_60_end,alpha_eps_j(:,5),'-- k','LineWidth',3);
%    hold off;
%   title('(c) \alpha_{\epsilon}');
%   ax = gca;
%   ax.FontSize = 20;
%   ax.XLim = [1960 2015];
% subplot(2,2,4);
%   plot(cal_60_end,sigma_eps_j(:,1),'- k','LineWidth',3);
%    hold on;
%      plot(cal_60_end,sigma_eps_j(:,3),'-- k','LineWidth',3);
%      plot(cal_60_end,sigma_eps_j(:,5),'-- k','LineWidth',3);
%    hold off;
%   title('(d) \sigma_{\epsilon,{\iti}}');
%   ax = gca;
%   ax.FontSize = 20;
%   ax.XLim = [1960 2015];
  
 
% % -- Figure 8 ---------
% j = 5;
% alpha_eps_j = reshape(alpha_eps_pct_17c(:,:,j),dnobs_60_end,6);
% alpha_tau_j = reshape(alpha_tau_pct_17c(:,:,j),dnobs_60_end,6);
% sigma_eps_j = sqrt(reshape(var_eps_unique_pct_17c(:,:,j),dnobs_60_end,6));
% figure;
% subplot(2,2,1);
%    plot(cal_60_end,dp_agg_60_end,': b','LineWidth',2);
%    hold on;
%      plot(cal_60_end,dp_disagg_60_end(:,j),'- k','LineWidth',1);
%      plot(cal_60_end,dis_tau_s_17c(:,j),'-- r','LineWidth',3);
%    hold off;
%  
%   tmp = char(labelvec_short_disagg(j));
%   titstr =['(a) ' tmp ': Inflation rates and trend']; 
%   title(titstr);
%   ax = gca;
%   ax.FontSize = 20;
%   ax.XLim = [1960 2015];
% subplot(2,2,2);
%   plot(cal_60_end,alpha_tau_j(:,1),'- k','LineWidth',3);
%    hold on;
%      plot(cal_60_end,alpha_tau_j(:,3),'-- k','LineWidth',3);
%      plot(cal_60_end,alpha_tau_j(:,5),'-- k','LineWidth',3);
%    hold off;
%   title('(b) \alpha_{\tau}');
%   ax = gca;
%   ax.FontSize = 20;
%   ax.XLim = [1960 2015];
% subplot(2,2,3);
%   plot(cal_60_end,alpha_eps_j(:,1),'- k','LineWidth',3);
%    hold on;
%      plot(cal_60_end,alpha_eps_j(:,3),'-- k','LineWidth',3);
%      plot(cal_60_end,alpha_eps_j(:,5),'-- k','LineWidth',3);
%    hold off;
%   title('(c) \alpha_{\epsilon}');
%   ax = gca;
%   ax.FontSize = 20;
%   ax.XLim = [1960 2015];
% subplot(2,2,4);
%   plot(cal_60_end,sigma_eps_j(:,1),'- k','LineWidth',3);
%    hold on;
%      plot(cal_60_end,sigma_eps_j(:,3),'-- k','LineWidth',3);
%      plot(cal_60_end,sigma_eps_j(:,5),'-- k','LineWidth',3);
%    hold off;
%   title('(d) \sigma_{\epsilon,{\iti}}');
%   ax = gca;
%   ax.FontSize = 20;
%   ax.XLim = [1960 2015];
  
  
% --- Figure 9 ----  


figure;
j = 14;
sigma_eps_j = sqrt(reshape(var_eps_unique_pct_17c(:,:,j),dnobs_60_end,6));

subplot(4,2,1);
   plot(cal_60_end,dp_disagg_60_end(:,j),'- k','LineWidth',1);
   tmp = char(labelvec_short_disagg(j));
  titstr =['(1) ' tmp]; 
  title(titstr);
  ax = gca;
  ax.FontSize = 20;
  ax.XLim = [1955 2020];
subplot(4,2,2);
  plot(cal_60_end,sigma_eps_j(:,1),'- k','LineWidth',3);
   hold on;
     plot(cal_60_end,sigma_eps_j(:,3),'-- k','LineWidth',3);
     plot(cal_60_end,sigma_eps_j(:,5),'-- k','LineWidth',3);
   hold off;
  title('\sigma_{\epsilon,{\iti}}');
  ax = gca;
  ax.FontSize = 20;
  ax.XLim = [1955 2020];
  
j = 5;
sigma_eps_j = sqrt(reshape(var_eps_unique_pct_17c(:,:,j),dnobs_60_end,6));

subplot(4,2,3);
   plot(cal_60_end,dp_disagg_60_end(:,j),'- k','LineWidth',1);
   tmp = char(labelvec_short_disagg(j));
  titstr =['(2) ' tmp]; 
  title(titstr);
  ax = gca;
  ax.FontSize = 20;
  ax.XLim = [1955 2020];
subplot(4,2,4);
  plot(cal_60_end,sigma_eps_j(:,1),'- k','LineWidth',3);
   hold on;
     plot(cal_60_end,sigma_eps_j(:,3),'-- k','LineWidth',3);
     plot(cal_60_end,sigma_eps_j(:,5),'-- k','LineWidth',3);
   hold off;
  title('\sigma_{\epsilon,{\iti}}');
  ax = gca;
  ax.FontSize = 20;
  ax.XLim = [1955 2020];


j = 2;
sigma_eps_j = sqrt(reshape(var_eps_unique_pct_17c(:,:,j),dnobs_60_end,6));

subplot(4,2,5);
   plot(cal_60_end,dp_disagg_60_end(:,j),'- k','LineWidth',1);
   tmp = char(labelvec_short_disagg(j));
  titstr =['(3) ' tmp]; 
  title(titstr);
  ax = gca;
  ax.FontSize = 20;
  ax.XLim = [1955 2020];
subplot(4,2,6);
  plot(cal_60_end,sigma_eps_j(:,1),'- k','LineWidth',3);
   hold on;
     plot(cal_60_end,sigma_eps_j(:,3),'-- k','LineWidth',3);
     plot(cal_60_end,sigma_eps_j(:,5),'-- k','LineWidth',3);
   hold off;
  title('\sigma_{\epsilon,{\iti}}');
  ax = gca;
  ax.FontSize = 20;
  ax.XLim = [1955 2020];
  
j = 7;
sigma_eps_j = sqrt(reshape(var_eps_unique_pct_17c(:,:,j),dnobs_60_end,6));

subplot(4,2,7);
   plot(cal_60_end,dp_disagg_60_end(:,j),'- k','LineWidth',1);
   tmp = char(labelvec_short_disagg(j));
  titstr =['(4) ' tmp]; 
  title(titstr);
  ax = gca;
  ax.FontSize = 20;
  ax.XLim = [1955 2020];
subplot(4,2,8);
  plot(cal_60_end,sigma_eps_j(:,1),'- k','LineWidth',3);
   hold on;
     plot(cal_60_end,sigma_eps_j(:,3),'-- k','LineWidth',3);
     plot(cal_60_end,sigma_eps_j(:,5),'-- k','LineWidth',3);
   hold off;
  title('\sigma_{\epsilon,{\iti}}');
  ax = gca;
  ax.FontSize = 20;
  ax.XLim = [1955 2020];

  