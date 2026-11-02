% Summary Calculations -- Figures 1, 2, 3, 4, and 10
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
%   label_suffix = '_Q3';  
  
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
  label_suffix = '_Q3';
  
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
  
  
  % Dates
  first_date = [1960 1];
  last_date = calds(end,:);
  ismpl_60_end = smpl(calvec,first_date,last_date,nper);
  cal_60_end = calvec(ismpl_60_end==1);
  dnobs_60_end = size(cal_60_end,1);
  
  dp_agg_60_end = dp_agg(ismpl_60_end==1,:);
  dp_agg_xe_60_end = dp_agg_xe(ismpl_60_end==1,:);
  dp_agg_xfe_60_end = dp_agg_xfe(ismpl_60_end==1,:);
  dp_disagg_60_end = dp_disagg(ismpl_60_end==1,:);
  share_avg_60_end = share_avg(ismpl_60_end==1,:);
  
  % -- Univariate Filtered and Smoothed Values
  ulabel = ['dp_agg' label_suffix];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'tau_f_mean_pct' ulabel]; load(str_tmp);
  tau_f_h = tau_f_mean_pct(:,1);
  tau_s_h = tau_mean_pct(:,1);
  tau_f_mean_pct_h = tau_f_mean_pct;
  tau_s_mean_pct_h = tau_mean_pct;
  str_tmp = [matdir 'var_dtau_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'vartotal_eps_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'var_eps_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'scl_eps_pct' ulabel]; load(str_tmp);
  var_eps_mean_pct_h=var_eps_mean_pct;
  vartotal_eps_mean_pct_h=vartotal_eps_mean_pct;
  var_dtau_mean_pct_h = var_dtau_mean_pct;
  scl_eps_pct_h = scl_eps_pct;
   
  ulabel = ['dp_xe' label_suffix];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'tau_f_mean_pct' ulabel]; load(str_tmp);
  tau_f_xe = tau_f_mean_pct(:,1);
  tau_s_xe = tau_mean_pct(:,1);
  tau_f_mean_pct_xe = tau_f_mean_pct;
  tau_s_mean_pct_xe = tau_mean_pct;
  str_tmp = [matdir 'var_dtau_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'vartotal_eps_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'var_eps_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'scl_eps_pct' ulabel]; load(str_tmp);
  var_eps_mean_pct_xe=var_eps_mean_pct;
  vartotal_eps_mean_pct_xe=vartotal_eps_mean_pct;
  var_dtau_mean_pct_xe = var_dtau_mean_pct;
  scl_eps_pct_xe = scl_eps_pct;
  
  ulabel = ['dp_xfe' label_suffix];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'tau_f_mean_pct' ulabel]; load(str_tmp);
  tau_f_xfe = tau_f_mean_pct(:,1);
  tau_s_xfe = tau_mean_pct(:,1);
  tau_f_mean_pct_xfe = tau_f_mean_pct;
  tau_s_mean_pct_xfe = tau_mean_pct;
  tau_f_mean_pct_xfe = tau_f_mean_pct;
  tau_s_mean_pct_xfe = tau_mean_pct;
  str_tmp = [matdir 'var_dtau_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'vartotal_eps_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'var_eps_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'scl_eps_pct' ulabel]; load(str_tmp);
  var_eps_mean_pct_xfe=var_eps_mean_pct;
  vartotal_eps_mean_pct_xfe=vartotal_eps_mean_pct;
  var_dtau_mean_pct_xfe = var_dtau_mean_pct;
  scl_eps_pct_xfe = scl_eps_pct;
  
  ulabel = ['dp_agg_s0' label_suffix];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'tau_f_mean_pct' ulabel]; load(str_tmp);
  tau_f_s0_h = tau_f_mean_pct(:,1);
  tau_s_s0_h = tau_mean_pct(:,1);
  tau_f_mean_pct_s0_h = tau_f_mean_pct;
  tau_s_mean_pct_s0_h = tau_mean_pct;
  str_tmp = [matdir 'var_dtau_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'vartotal_eps_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'var_eps_mean_pct' ulabel]; load(str_tmp);
  var_eps_mean_pct_s0_h=var_eps_mean_pct;
  vartotal_eps_mean_pct_s0_h=vartotal_eps_mean_pct;
  var_dtau_mean_pct_s0_h = var_dtau_mean_pct;
  
  % -- Some results for the 17-component model
  mlabel = ['_mucsv_tvp_17c' label_suffix];
  str_tmp = [matdir 'agg_f_tau_mean_pct' mlabel]; load(str_tmp);
  str_tmp = [matdir 'agg_tau_mean_pct' mlabel]; load(str_tmp);
  tau_f_17c = agg_f_tau_mean_pct(:,1);
  tau_s_17c = agg_tau_mean_pct(:,1);
  tau_f_mean_pct_17c = agg_f_tau_mean_pct;
  tau_s_mean_pct_17c = agg_tau_mean_pct;
  
  % -- Some results for the 3-component model
  mlabel = ['_mucsv_tvp_3c' label_suffix];
  str_tmp = [matdir 'agg_f_tau_mean_pct' mlabel]; load(str_tmp);
  str_tmp = [matdir 'agg_tau_mean_pct' mlabel]; load(str_tmp);
  tau_f_3c = agg_f_tau_mean_pct(:,1);
  tau_s_3c = agg_tau_mean_pct(:,1);
  tau_f_mean_pct_3c = agg_f_tau_mean_pct;
  tau_s_mean_pct_3c = agg_tau_mean_pct;
  
  % -- Figure 1: 4 Panel Graph
  figure;
  subplot(2,2,1);
  plot(cal_60_end,dp_agg_60_end,'- b','LineWidth',2);
  titstr = '(a) PCE-all Inflation';
  title(titstr,'FontSize',18);
  xlim([1955 2020]);
  ylim([-10 15]);
  ax = gca;
  ax.FontSize = 20;
  
  subplot(2,2,2);
  plot(cal_60_end,dp_agg_xe_60_end,'- b','LineWidth',2);
  titstr = '(b) PCExE Inflation ';
  title(titstr,'FontSize',18);
  xlim([1955 2020]);
  ylim([-10 15]);
  ax = gca;
  ax.FontSize = 20;
  
  subplot(2,2,3);
  plot(cal_60_end,dp_agg_xfe_60_end,'- b','LineWidth',2);
  titstr = '(c) PCExFE Inflation ';
  title(titstr,'FontSize',18);
  xlim([1955 2020]);
  ylim([-10 15]);
  ax = gca;
  ax.FontSize = 20;
  
  
  
  
 [cal_60_end/1000 tau_s_h tau_s_xe tau_s_xfe]
 tmp = abs(tau_s_h-tau_s_xfe);
 mean(tmp)
 [aa,ii]=max(tmp);
 cal_60_end(ii)
 aa
 tmp = abs(tau_s_xe-tau_s_xfe);
 mean(tmp)
 [aa,ii]=max(tmp);
 cal_60_end(ii)
 aa

  
 % -- Figure 2 -----
figure;

subplot(2,2,1); 
  plot(cal_60_end,tau_s_h,'- b','LineWidth',2);
  hold on;
   plot(cal_60_end,tau_s_xe,'-- k','LineWidth',3);
   plot(cal_60_end,tau_s_xfe,': r','LineWidth',3);
  hold off;
  titstr = '(a) \tau_{{\itt}} ';
  title(titstr,'FontSize',18);
  legend('PCE-all','PCExE','PCExFE');
  legend('Location','NorthEast');
  xlim([1955 2020]);
  ylim([0 12]);
  ax = gca;
  ax.FontSize = 20;
 
  subplot(2,2,2);
  plot(cal_60_end,sqrt(var_dtau_mean_pct_h(:,4)),'- b','LineWidth',3);
  hold on;
    plot(cal_60_end,sqrt(var_dtau_mean_pct_xe(:,4)),'-- k','LineWidth',3);
    plot(cal_60_end,sqrt(var_dtau_mean_pct_xfe(:,4)),': r','LineWidth',3);  
  hold off;
%   legend('PCE-all','PCExE','PCExFE');
%   legend('Location','NorthEast');
%   ylim([-10 15]);
  titstr = '(b) \sigma_{\Delta\tau,{\itt}}';
  title(titstr,'FontSize',18);
  xlim([1955 2020]);
 % xlabel('Date'); 
%   ylabel('Percent'); 
  set(gca,'fontsize',20)
%   ax = gca;
%   ax.FontSize = 20;
 
  
subplot(2,2,3);
  plot(cal_60_end,sqrt(var_eps_mean_pct_h(:,4)),'- b','LineWidth',3);
  hold on;
    plot(cal_60_end,sqrt(var_eps_mean_pct_xe(:,4)),'-- k','LineWidth',3);
    plot(cal_60_end,sqrt(var_eps_mean_pct_xfe(:,4)),': r','LineWidth',3);  
  hold off;
%   legend('PCE-all','PCExE','PCExFEE');
%   legend('Location','NorthWest')
%   ylim([-10 15]);
  titstr = '(c) \sigma_{\epsilon,{\itt}}';
  title(titstr,'FontSize',18);
  xlim([1955 2020]);
%  xlabel('Date'); 
%   ylabel('Percent');
  set(gca,'fontsize',20)
%   ax = gca;
%   ax.FontSize = 20;
  
 subplot(2,2,4);
%   plot(cal_60_end,sqrt(vartotal_eps_mean_pct_h(:,4)),'- b','LineWidth',3);
%   hold on;
%     plot(cal_60_end,sqrt(vartotal_eps_mean_pct_xe(:,4)),'-- k','LineWidth',3);
%     plot(cal_60_end,sqrt(vartotal_eps_mean_pct_xfe(:,4)),': r','LineWidth',3);  
%   hold off;
% %   legend('PCE-all','PCExE','PCExFEE');
  plot(cal_60_end,scl_eps_pct_h(:,4),'- b','LineWidth',3);
  hold on;
    plot(cal_60_end,scl_eps_pct_xe(:,4),'-- k','LineWidth',3);
    plot(cal_60_end,scl_eps_pct_xfe(:,4),': r','LineWidth',3);  
  hold off;
% %   legend('PCE-all','PCExE','PCExFEE');
%   legend('Location','NorthWest');
%   ylim([-10 15]);
%  titstr = '(c) \sigma_{\epsilon,{\itt}} \times {\its}_{{\itt}}';
  titstr = '(d) {\its}_{{\itt}}';
  title(titstr,'FontSize',18);
  xlim([1955 2020]);
  set(gca,'fontsize',20)
%  xlabel('Date'); 
%  ylabel('Percent'); 
%   ax = gca;
%   ax.FontSize = 20;
 
  
 

  