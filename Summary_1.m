% Summary Calculations
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
  mtoq_agg = 0;   % Temporal aggregation indicator of monthly to quarterly data
  pcomp_data_calendar_m_and_q;  
  % Data Series Used
  dp_agg = dp_agg_q;
  dp_agg_xfe = dp_agg_xfe_q;
  dp_agg_xe = dp_agg_xe_q; 
  dp_agg_q0 = dp_agg;
  dp_agg_xfe_q0 = dp_agg_xfe;
  dp_agg_xe_q0 = dp_agg_xe;
  
  load_data = 1;  % 1 if reloading data from Excel, etc 
  mtoq_agg = 3;   % Temporal aggregation indicator of monthly to quarterly data
  pcomp_data_calendar_m_and_q;  
  % Data Series Used
  dp_agg = dp_agg_q;
  dp_agg_xfe = dp_agg_xfe_q;
  dp_agg_xe = dp_agg_xe_q; 
  dp_agg_q3 = dp_agg;
  dp_agg_xfe_q3 = dp_agg_xfe;
  dp_agg_xe_q3 = dp_agg_xe;
  
  
  % Dates
  ismpl_60_end = smpl(calvec_q,[1960 1],calds_q(end,:),4);
  cal_60_end_q = calvec_q(ismpl_60_end==1);
  ismpl_60_end = smpl(calvec_m,[1960 1],calds_m(end,:),12);
  cal_60_end_m = calvec_m(ismpl_60_end==1);
  

  % -- Figure 1
  % .. plot Q0 and Q3
  plot(calvec_q,dp_agg_q0,'- b','LineWidth',2);
  hold on;
  plot(calvec_q,dp_agg_q3,'-- k','LineWidth',2);
  hold off;
  legend('Q0','Q3');
  legend('Location','NorthEast');
   ax = gca;
  ax.FontSize = 35;
  ax.XLim = [1960 2020];
  
  % .. plot M and Q3
  plot(calvec_m,dp_agg_m,'- b','LineWidth',2);
  hold on;
  plot(calvec_q,dp_agg_q3,'-- k','LineWidth',2);
  hold off;
  legend('M','Q3');
  legend('Location','NorthEast');
   ax = gca;
  ax.FontSize = 35;
  ax.XLim = [1960 2020];
  
   % .. plot  Q3
  plot(calvec_q,dp_agg_q3,'- b','LineWidth',2);
  hold on;
  plot(calvec_q,dp_agg_xfe_q3,'- k','LineWidth',2);
  plot(calvec_q,dp_agg_xe_q3,'-- k','LineWidth',2);
  hold off;
  legend('Headline','XFE','XE');
  legend('Location','NorthEast');
   ax = gca;
  ax.FontSize = 35;
  ax.XLim = [1960 2020];
  
  % .. plot  M
  plot(calvec_m,dp_agg_m,'- b','LineWidth',2);
  hold on;
  plot(calvec_m,dp_agg_xfe_m,'- k','LineWidth',2);
  plot(calvec_m,dp_agg_xe_m,'-- k','LineWidth',2);
  hold off;
  legend('Headline','XFE','XE');
  legend('Location','NorthEast');
  ax = gca;
  ax.FontSize = 35;
  ax.XLim = [1960 2020];
  
  ulabel = ['dp_agg_q0'];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  tau_s_h_q0 = tau_mean_pct(:,1);
  ulabel = ['dp_agg_q3'];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  tau_s_h_q3 = tau_mean_pct(:,1);
  ulabel = ['dp_agg_m'];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  tau_s_h_m = tau_mean_pct(:,1);
  
  % .. 
  plot(cal_60_end_q,tau_s_h_q3,'- b','LineWidth',2);
  hold on;
  plot(cal_60_end_q,tau_s_h_q0,'-- k','LineWidth',2);
  plot(cal_60_end_m,tau_s_h_m,'- k','LineWidth',2);
  hold off;
  legend('Q3','Q0', 'M');
  legend('Location','NorthEast');
  ax = gca;
  ax.FontSize = 35;
  ax.XLim = [1960 2020];
  
  ulabel = ['dp_xfe_q0'];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  tau_s_xfe_q0 = tau_mean_pct(:,1);
  ulabel = ['dp_xfe_q3'];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  tau_s_xfe_q3 = tau_mean_pct(:,1);
  ulabel = ['dp_xfe_m'];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  tau_s_xfe_m = tau_mean_pct(:,1);
  
  % .. 
  plot(cal_60_end_q,tau_s_xfe_q3,'- b','LineWidth',2);
  hold on;
  plot(cal_60_end_q,tau_s_xfe_q0,'-- k','LineWidth',2);
  plot(cal_60_end_m,tau_s_xfe_m,'- k','LineWidth',2);
  hold off;
  legend('Q3','Q0', 'M');
  legend('Location','NorthEast');
  ax = gca;
  ax.FontSize = 35;
  ax.XLim = [1960 2020];
  
  ulabel = ['dp_xe_q0'];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  tau_s_xe_q0 = tau_mean_pct(:,1);
  ulabel = ['dp_xe_q3'];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  tau_s_xe_q3 = tau_mean_pct(:,1);
  ulabel = ['dp_xe_m'];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  tau_s_xe_m = tau_mean_pct(:,1);
  
  % .. 
  plot(cal_60_end_q,tau_s_xe_q3,'- b','LineWidth',2);
  hold on;
  plot(cal_60_end_q,tau_s_xe_q0,'-- k','LineWidth',2);
  plot(cal_60_end_m,tau_s_xe_m,'- k','LineWidth',2);
  hold off;
  legend('Q3','Q0', 'M');
  legend('Location','NorthEast');
  ax = gca;
  ax.FontSize = 35;
  ax.XLim = [1960 2020];
  
  % .. 3comp and 17comp
  % -- Some results for the 17-component model
  mlabel = ['_mucsv_tvp_17c_q3'];
  str_tmp = [matdir 'agg_tau_mean_pct' mlabel]; load(str_tmp);
  tau_s_17c_q3 = agg_tau_mean_pct(:,1);
  mlabel = ['_mucsv_tvp_3c_q3'];
  str_tmp = [matdir 'agg_tau_mean_pct' mlabel]; load(str_tmp);
  tau_s_3c_q3 = agg_tau_mean_pct(:,1);
  
  mlabel = ['_mucsv_tvp_17c_m'];
  str_tmp = [matdir 'agg_tau_mean_pct' mlabel]; load(str_tmp);
  tau_s_17c_m = agg_tau_mean_pct(:,1);
  mlabel = ['_mucsv_tvp_3c_m'];
  str_tmp = [matdir 'agg_tau_mean_pct' mlabel]; load(str_tmp);
  tau_s_3c_m = agg_tau_mean_pct(:,1);
  
  % .. 
  plot(cal_60_end_q,tau_s_h_q3,'- b','LineWidth',2);
  hold on;
  plot(cal_60_end_q,tau_s_xfe_q3,'-- b','LineWidth',2);
  plot(cal_60_end_q,tau_s_xe_q3,': b','LineWidth',3);
  plot(cal_60_end_q,tau_s_17c_q3,'- r','LineWidth',2);
  plot(cal_60_end_q,tau_s_3c_q3,'-- r','LineWidth',2);
  hold off;
  legend('U-agg','U-XFE', 'U-XE','17c','3c');
  legend('Location','NorthEast');
  ax = gca;
  ax.FontSize = 35;
  ax.XLim = [1960 2020];
  %error('tmp');
  
  % .. 
  plot(cal_60_end_m,tau_s_h_m,'- b','LineWidth',2);
  hold on;
  plot(cal_60_end_m,tau_s_xfe_m,'-- b','LineWidth',2);
  plot(cal_60_end_m,tau_s_xe_m,': b','LineWidth',3);
  plot(cal_60_end_m,tau_s_17c_m,'- r','LineWidth',2);
  plot(cal_60_end_m,tau_s_3c_m,'-- r','LineWidth',2);
  hold off;
  legend('U-agg','U-XFE', 'U-XE','17c','3c');
  legend('Location','NorthEast');
  ax = gca;
  ax.FontSize = 35;
  ax.XLim = [1960 2020];
  
  % -- Filtered and Smoothed estimates
  ulabel = ['dp_agg_q3'];
  str_tmp = [matdir 'tau_f_mean_pct' ulabel]; load(str_tmp);
  tau_f_h_q3 = tau_f_mean_pct(:,1);
  ulabel = ['dp_agg_poos_q3'];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  tau_p_h_q3 = tau_mean_pct(:,1);
  % .. 
  plot(cal_60_end_q,tau_s_h_q3,'- b','LineWidth',2);
  hold on;
  plot(cal_60_end_q,tau_f_h_q3,'-- b','LineWidth',2);
  plot(cal_60_end_q,tau_p_h_q3,': b','LineWidth',3);
  hold off;
  legend('Smoothed','Quasi-Filtered','Filtered');
  legend('Location','NorthEast');
  ax = gca;
  ax.FontSize = 35;
  ax.XLim = [1960 2020];
  
  % -- Filtered and Smoothed estimates
  ulabel = ['dp_xfe_q3'];
  str_tmp = [matdir 'tau_f_mean_pct' ulabel]; load(str_tmp);
  tau_f_xfe_q3 = tau_f_mean_pct(:,1);
  ulabel = ['dp_xfe_poos_q3'];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  tau_p_xfe_q3 = tau_mean_pct(:,1);
  % .. 
  plot(cal_60_end_q,tau_s_xfe_q3,'- b','LineWidth',2);
  hold on;
  plot(cal_60_end_q,tau_f_xfe_q3,'-- b','LineWidth',2);
  plot(cal_60_end_q,tau_p_xfe_q3,': b','LineWidth',3);
  hold off;
  legend('Smoothed','Quasi-Filtered','Filtered');
  legend('Location','NorthEast');
  ax = gca;
  ax.FontSize = 35;
  ax.XLim = [1960 2020];
  
  % -- Filtered and Smoothed estimates
  ulabel = ['dp_xe_q3'];
  str_tmp = [matdir 'tau_f_mean_pct' ulabel]; load(str_tmp);
  tau_f_xe_q3 = tau_f_mean_pct(:,1);
  ulabel = ['dp_xe_poos_q3'];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  tau_p_xe_q3 = tau_mean_pct(:,1);
  % .. 
  plot(cal_60_end_q,tau_s_xe_q3,'- b','LineWidth',2);
  hold on;
  plot(cal_60_end_q,tau_f_xe_q3,'-- b','LineWidth',2);
  plot(cal_60_end_q,tau_p_xe_q3,': b','LineWidth',3);
  hold off;
  legend('Smoothed','Quasi-Filtered','Filtered');
  legend('Location','NorthEast');
  ax = gca;
  ax.FontSize = 35;
  ax.XLim = [1960 2020];
 
  % -- Filtered and Smoothed estimates
  ulabel = ['dp_agg_m'];
  str_tmp = [matdir 'tau_f_mean_pct' ulabel]; load(str_tmp);
  tau_f_h_m = tau_f_mean_pct(:,1);
  ulabel = ['dp_agg_poos_m'];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  tau_p_h_m = tau_mean_pct(:,1);
  % .. 
  plot(cal_60_end_m,tau_s_h_m,'- b','LineWidth',2);
  hold on;
  plot(cal_60_end_m,tau_f_h_m,'-- b','LineWidth',2);
  plot(cal_60_end_m,tau_p_h_m,': b','LineWidth',3);
  hold off;
  legend('Smoothed','Quasi-Filtered','Filtered');
  legend('Location','NorthEast');
  ax = gca;
  ax.FontSize = 35;
  ax.XLim = [1960 2020];
  
  % -- Filtered and Smoothed estimates
  ulabel = ['dp_xfe_m'];
  str_tmp = [matdir 'tau_f_mean_pct' ulabel]; load(str_tmp);
  tau_f_xfe_m = tau_f_mean_pct(:,1);
  ulabel = ['dp_xfe_poos_m'];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  tau_p_xfe_m = tau_mean_pct(:,1);
  % .. 
  plot(cal_60_end_m,tau_s_xfe_m,'- b','LineWidth',2);
  hold on;
  plot(cal_60_end_m,tau_f_xfe_m,'-- b','LineWidth',2);
  plot(cal_60_end_m,tau_p_xfe_m,': b','LineWidth',3);
  hold off;
  legend('Smoothed','Quasi-Filtered','Filtered');
  legend('Location','NorthEast');
  ax = gca;
  ax.FontSize = 35;
  ax.XLim = [1960 2020];
  
  % -- Filtered and Smoothed estimates
  ulabel = ['dp_xe_m'];
  str_tmp = [matdir 'tau_f_mean_pct' ulabel]; load(str_tmp);
  tau_f_xe_m = tau_f_mean_pct(:,1);
  ulabel = ['dp_xe_poos_m'];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  tau_p_xe_m = tau_mean_pct(:,1);
  % .. 
  plot(cal_60_end_m,tau_s_xe_m,'- b','LineWidth',2);
  hold on;
  plot(cal_60_end_m,tau_f_xe_m,'-- b','LineWidth',2);
  plot(cal_60_end_m,tau_p_xe_m,': b','LineWidth',3);
  hold off;
  legend('Smoothed','Quasi-Filtered','Filtered');
  legend('Location','NorthEast');
  ax = gca;
  ax.FontSize = 35;
  ax.XLim = [1960 2020];

  