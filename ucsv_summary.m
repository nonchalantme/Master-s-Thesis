% ucsv_summary.m -- aggregate inflation
% 9/16/2015, MWW
%


clear all;
small = 1.0e-10;
big = 1.0e+6;                  
 
  % -- File Directories  
  outdir = '/Users/mwatson/Dropbox/p_comp/revision/matlab/out/';
  figdir = '/Users/mwatson/Dropbox/p_comp/revision/matlab/fig/';
  matdir = '/Users/mwatson/Dropbox/p_comp/revision/matlab/mat/';
    
  % -- Read in Data --- 
  load_data = 1;  % 1 if reloading data from Excel, etc 
  mtoq_agg = 0;   % Temporal aggregation indicator of monthly to quarterly data
  pcomp_data_calendar_m_and_q;
  
 % Quarterly data -- zero 
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
  
  dp_q0 = dp;
  calvec_q = calvec_ismpl;
  ismpl_q = ismpl;
  outlabel_q0 = outlabel;
  
  % Quarterly data -- zero 
  load_data = 1;  % 1 if reloading data from Excel, etc 
  mtoq_agg = 3;   % Temporal aggregation indicator of monthly to quarterly data
  pcomp_data_calendar_m_and_q;
  dp_agg = dp_agg_q;
  dp_agg_xfe = dp_agg_xfe_q;
  dp_agg_xe = dp_agg_xe_q;
  dp_disagg = dp_disagg_q;
  calvec = calvec_q;
  dnobs = dnobs_q;
  calds = calds_q;
  nper = 4;
  outlabel = 'Q3';
   
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
  
  dp_q3 = dp;
  calvec_q = calvec_ismpl;
  ismpl_q = ismpl;
  outlabel_q3 = outlabel;
  
  % Monthly Data
  dp_agg = dp_agg_m;
  dp_agg_xfe = dp_agg_xfe_m;
  dp_agg_xe = dp_agg_xe_m;
  dp_disagg = dp_disagg_m;
  calvec = calvec_m;
  dnobs = dnobs_m;
  calds = calds_m;
  nper = 12;
  outlabel = 'M';
   
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
  
  dp_m = dp;
  calvec_m = calvec_ismpl;
  ismpl_m = ismpl;
  outlabel_m = outlabel;
  
    
  for iseries = 1:size(dp,2);
   outlabel = outlabel_m;
    dp = dp_m;
    ismpl = ismpl_m;
    tmp = char(namevec(iseries));
    sname = char(labvec(iseries));
    ulabel = [tmp '_' outlabel]; 
    y = dp(ismpl==1,iseries);
    str_tmp = [matdir 'g_eps_prior_post' ulabel]; load(str_tmp);
    str_tmp = [matdir 'g_dtau_prior_post' ulabel]; load(str_tmp);
    str_tmp = [matdir 'var_eps_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'var_dtau_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'vartotal_eps_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'tau_f_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'tau_f_mean_sd' ulabel]; load(str_tmp);
    str_tmp = [matdir 'tau_mean_sd' ulabel]; load(str_tmp);
    str_tmp = [matdir 'theta_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'sigma_a_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'scl_eps_pct' ulabel]; load(str_tmp); 
    % Medians:
    sd_dtau_median = sqrt(var_dtau_mean_pct(:,4));
    sd_eps_median = sqrt(var_eps_mean_pct(:,4));
    tau_median = tau_mean_pct(:,4);
    tau_f_median = tau_f_mean_pct(:,4);
    scl_eps_median = scl_eps_pct(:,4);
    scl_eps_mean = scl_eps_pct(:,1);

    y_m = y;
    sd_dtau_median_m = sd_dtau_median;
    sd_eps_median_m = sd_eps_median;
    tau_median_m = tau_median;
    tau_f_median_m = tau_f_median;
    scl_eps_median_m = scl_eps_median;
    scl_eps_mean_m = scl_eps_mean;
    
   outlabel = outlabel_q0;
    dp = dp_q0;
    ismpl = ismpl_q;
    tmp = char(namevec(iseries));
    ulabel = [tmp '_' outlabel]; 
    y = dp(ismpl==1,iseries);
    str_tmp = [matdir 'g_eps_prior_post' ulabel]; load(str_tmp);
    str_tmp = [matdir 'g_dtau_prior_post' ulabel]; load(str_tmp);
    str_tmp = [matdir 'var_eps_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'var_dtau_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'vartotal_eps_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'tau_f_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'tau_f_mean_sd' ulabel]; load(str_tmp);
    str_tmp = [matdir 'tau_mean_sd' ulabel]; load(str_tmp);
    str_tmp = [matdir 'theta_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'sigma_a_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'scl_eps_pct' ulabel]; load(str_tmp); 
    % Medians:
    sd_dtau_median = sqrt(var_dtau_mean_pct(:,4));
    sd_eps_median = sqrt(var_eps_mean_pct(:,4));
    tau_median = tau_mean_pct(:,4);
    tau_f_median = tau_f_mean_pct(:,4);
    scl_eps_median = scl_eps_pct(:,4);
    scl_eps_mean = scl_eps_pct(:,1);

    y_q0 = y;
    sd_dtau_median_q0 = sd_dtau_median;
    sd_eps_median_q0 = sd_eps_median;
    tau_median_q0 = tau_median;
    tau_f_median_q0 = tau_f_median;
    scl_eps_median_q0 = scl_eps_median;
    scl_eps_mean_q0 = scl_eps_mean;
    
   outlabel = outlabel_q3;
    dp = dp_q3;
    ismpl = ismpl_q;
    tmp = char(namevec(iseries));
    ulabel = [tmp '_' outlabel]; 
    y = dp(ismpl==1,iseries);
    str_tmp = [matdir 'g_eps_prior_post' ulabel]; load(str_tmp);
    str_tmp = [matdir 'g_dtau_prior_post' ulabel]; load(str_tmp);
    str_tmp = [matdir 'var_eps_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'var_dtau_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'vartotal_eps_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'tau_f_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'tau_f_mean_sd' ulabel]; load(str_tmp);
    str_tmp = [matdir 'tau_mean_sd' ulabel]; load(str_tmp);
    str_tmp = [matdir 'theta_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'sigma_a_mean_pct' ulabel]; load(str_tmp);
    str_tmp = [matdir 'scl_eps_pct' ulabel]; load(str_tmp); 
    % Medians:
    sd_dtau_median = sqrt(var_dtau_mean_pct(:,4));
    sd_eps_median = sqrt(var_eps_mean_pct(:,4));
    tau_median = tau_mean_pct(:,4);
    tau_f_median = tau_f_mean_pct(:,4);
    scl_eps_median = scl_eps_pct(:,4);
    scl_eps_mean = scl_eps_pct(:,1);

    y_q3 = y;
    sd_dtau_median_q3 = sd_dtau_median;
    sd_eps_median_q3 = sd_eps_median;
    tau_median_q3 = tau_median;
    tau_f_median_q3 = tau_f_median;
    scl_eps_median_q3 = scl_eps_median;
    scl_eps_mean_q3 = scl_eps_median;
    
    
    % Plot Series
    
    figure;
    subplot(3,2,1);
    plot(calvec_q,y_q0,'- b','LineWidth',3);
    hold on;
     plot(calvec_q,y_q3,'- g','LineWidth',3);
     plot(calvec_m,y_m,'- k','LineWidth',1);
    hold off;
    title(sname);
    
    subplot(3,2,2);
    plot(calvec_q,sd_dtau_median_q0,'- b','LineWidth',3);
    hold on;
     plot(calvec_q,sd_dtau_median_q3,'- g','LineWidth',3);
     plot(calvec_m,sd_dtau_median_m,'- k','LineWidth',1);
    hold off;
    
    subplot(3,2,3);
    plot(calvec_q,scl_eps_mean_q0,'- b','LineWidth',3);
    hold on;
     plot(calvec_q,scl_eps_mean_q3,'- g','LineWidth',3);
     plot(calvec_m,scl_eps_mean_m,'- k','LineWidth',1);
    hold off;
    
    subplot(3,2,4);
    plot(calvec_q,sd_eps_median_q0,'- b','LineWidth',3);
    hold on;
     plot(calvec_q,sd_eps_median_q3,'- g','LineWidth',3);
     plot(calvec_m,sd_eps_median_m,'- k','LineWidth',1);
    hold off;
        
    subplot(3,2,5);
    plot(calvec_q,tau_median_q0,'- b','LineWidth',3);
    hold on;
     plot(calvec_q,tau_median_q3,'- g','LineWidth',3);
     plot(calvec_m,tau_median_m,'- k','LineWidth',1);
    hold off;
    
    subplot(3,2,6);
    plot(calvec_q,tau_f_median_q0,'- b','LineWidth',3);
    hold on;
     plot(calvec_q,tau_f_median_q3,'- g','LineWidth',3);
     plot(calvec_m,tau_f_median_m,'- k','LineWidth',1);
    hold off;
    
    waitforbuttonpress;
    
  end;