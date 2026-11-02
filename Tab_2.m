% Summary Calculations 
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
  
%   %  % -- Read in Data --- 
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
%   label_suffix = '_Q0';  
%   mlabel = '_mucsv_tvp_17c_Q0';  
  
%   % -- Read in Data --- 
%   load_data = 1;  % 1 if reloading data from Excel, etc 
%   mtoq_agg = 3;   % Temporal aggregation indicator of monthly to quarterly data
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
%   mlabel = '_mucsv_tvp_17c_Q3';  
%   
 % -- Read in Data --- 
  load_data = 1;  % 1 if reloading data from Excel, etc 
  mtoq_agg = 0;   % Temporal aggregation indicator of monthly to quarterly data
  pcomp_data_calendar_m_and_q;  
  % Data Series Used
  dp_agg = dp_agg_m;
  dp_agg_xfe = dp_agg_xfe_m;
  dp_agg_xe = dp_agg_xe_m;
  dp_disagg = dp_disagg_m;
  share_avg = share_avg_m;
  calvec = calvec_m;
  dnobs = dnobs_m;
  calds = calds_m;
  nper = 12;
  label_suffix = '_M';
  mlabel = '_mucsv_tvp_17c_M';  
  
 % Dates
  first_date = [1960 1];
  last_date = calds(end,:);
  ismpl_60_end = smpl(calvec,first_date,last_date,nper);
  cal_60_end = calvec(ismpl_60_end==1);
  dnobs_60_end = size(cal_60_end,1);
  
  
  outfile_name = [outdir 'Table_2' label_suffix '.out'];
  fileID = fopen(outfile_name,'w');
  
  dp_agg_60_end = dp_agg(ismpl_60_end==1,:);
  dp_agg_xe_60_end = dp_agg_xe(ismpl_60_end==1,:);
  dp_agg_xfe_60_end = dp_agg_xfe(ismpl_60_end==1,:);
  dp_disagg_60_end = dp_disagg(ismpl_60_end==1,:);
  share_avg_60_end = share_avg(ismpl_60_end==1,:);
  
  dpa_agg = zeros(dnobs,1);
  dpa_agg_xe = zeros(dnobs,1);
  dpa_agg_xfe = zeros(dnobs,1);
  dpa_disagg =  zeros(dnobs,n_incl);
  for i = 1:nper;
    dpa_agg(nper:end) = dpa_agg(nper:end)+dp_agg(i:end-nper+i);
    dpa_agg_xe(nper:end) = dpa_agg_xe(nper:end)+dp_agg_xe(i:end-nper+i);
    dpa_agg_xfe(nper:end) = dpa_agg_xfe(nper:end)+dp_agg_xfe(i:end-nper+i);
    dpa_disagg(nper:end,:) = dpa_disagg(nper:end,:)+dp_disagg(i:end-nper+i,:);
  end;
  dpa_agg = dpa_agg/nper;
  dpa_agg_xe = dpa_agg_xe/nper;
  dpa_agg_xfe = dpa_agg_xfe/nper;
  dpa_disagg = dpa_disagg/nper;

  dpa_agg_60_end = dpa_agg(ismpl_60_end==1);
  dpa_agg_xe_60_end = dpa_agg_xe(ismpl_60_end==1);
  dpa_agg_xfe_60_end = dpa_agg_xfe(ismpl_60_end==1);
  dpa_disagg_60_end = dpa_disagg(ismpl_60_end==1,:);
  
  % -- Some results for the 17-component model
  str_tmp = [matdir 'calvec_ismpl' mlabel]; load(str_tmp);
  % check dates
  tmp = calvec_ismpl-cal_60_end;
  if sum(tmp) ~= 0;
    error('Dates not synchronized');
  end;  
  % Components from 17
  s = share_avg(ismpl_60_end==1,:);
  ifood = 5;
  ienergy = [7 10];
  icore = [1:4 6 8:9 11:17];
  s_energy = s(:,ienergy);
  s_energy = s_energy./repmat(sum(s_energy,2),1,2);
  s_core = s(:,icore);
  s_core = s_core./repmat(sum(s_core,2),1,14);
  % -- Mean Values of Parameters
  str_tmp = [matdir 'alpha_eps_mean' mlabel]; load(str_tmp);
  str_tmp = [matdir 'alpha_tau_mean' mlabel]; load(str_tmp);
  str_tmp = [matdir 'var_eps_common_mean' mlabel]; load(str_tmp);
  str_tmp = [matdir 'var_eps_common_total_mean' mlabel]; load(str_tmp);
  str_tmp = [matdir 'var_eps_unique_mean' mlabel]; load(str_tmp);
  str_tmp = [matdir 'var_eps_unique_total_mean' mlabel]; load(str_tmp); 
  str_tmp = [matdir 'var_dtau_common_mean' mlabel]; load(str_tmp); 
  str_tmp = [matdir 'var_dtau_unique_mean' mlabel]; load(str_tmp);

  alpha_eps_17c = alpha_eps_mean;
  alpha_tau_17c = alpha_tau_mean;
  
  var_eps_common_17c = var_eps_common_mean;
  var_eps_common_total_17c = var_eps_common_total_mean;
  var_eps_unique_17c = var_eps_unique_mean;
  var_eps_unique_total_17c = var_eps_unique_total_mean;
  var_dtau_common_17c = var_dtau_common_mean;
  var_dtau_unique_17c = var_dtau_unique_mean;
 
  
% -- Carry out filtering and so forth to determine mean and SD from various
% tau(t/t) estimators

% Exercise 1: Use system parameters from 17-component model
alpha_eps = alpha_eps_17c;
alpha_tau = alpha_tau_17c;

sigma_eps_common = sqrt(var_eps_common_total_17c);
sigma_dtau_common = sqrt(var_dtau_common_17c);
sigma_eps_unique = sqrt(var_eps_unique_total_17c);
sigma_dtau_unique = sqrt(var_dtau_unique_17c);

n_y = 17;
share_h = share_avg_60_end;
share_xe = share_h;
share_xe(:,[ienergy]) = 0;
share_xfe = share_h;
share_xfe(:,[ifood ienergy]) = 0;
share_xe = share_xe./repmat(sum(share_xe,2),1,n_y);
share_xfe = share_xfe./repmat(sum(share_xfe,2),1,n_y);


% Set up State Vector
  % --- State Vector
  %     (1) eps(t)
  %     (2) tau(t)
  %     (3) tau_u(t)
  %     (4) eps_u(t)
  ns = 2+2*n_y;      % size of state
  Q = zeros(ns,ns);
  F = zeros(ns,ns);
  F(2,2) = 1;
  F(3:2+n_y,3:2+n_y) = eye(n_y);
  H = zeros(ns,n_y);
  H(3:2+n_y,1:n_y) = eye(n_y);
  H(2+n_y+1:2+2*n_y,1:n_y) = eye(n_y);
  
  % Set up KF to run
  % Initial conditions
  X1_init = zeros(ns,1);
  P1_init = zeros(ns,ns);
  var_dtau_unique = big*ones(n_y,1);
  P1_init(3:2+n_y,3:2+n_y) = diag(var_dtau_unique);
  
  tau_17c_mean = zeros(dnobs_60_end,3);
  tau_17c_var = zeros(dnobs_60_end,3);
  X1 = X1_init;
  P1 = P1_init;
  for t = 1:dnobs_60_end;
    H_t = H;
    H_t(1,:) = alpha_eps(t,:);
    H_t(2,:) = alpha_tau(t,:);
    Q_t = diag([(sigma_eps_common(t,1).^2) (sigma_dtau_common(t,1).^2) (sigma_dtau_unique(t,:).^2) (sigma_eps_unique(t,:).^2)]');
    S_Y_DP = eye(n_y);
    yt = S_Y_DP*dp_disagg_60_end(t,:)';
    Rt = zeros(size(yt,1),size(yt,1));
    Ht = H_t*S_Y_DP';
    yt = dp_disagg_60_end(t,:)';
    Rt = zeros(size(yt,1),size(yt,1));
    Ht = H_t;
    [X1,P1,X2,P2,e,ht,llf] = kfilt_llf(yt,X1,P1,Ht,F,Rt,Q_t);
    % Parameters mapping state into tau-headline 
    S = zeros(ns,1);
    S(2) = share_h(t,:)*alpha_tau(t,:)';
    S(3:2+n_y) = share_h(t,:)';
    tauh = S'*X1;
    varh = S'*P1*S;
    
    S = zeros(ns,1);
    S(2) = share_xe(t,:)*alpha_tau(t,:)';
    S(3:2+n_y) = share_xe(t,:)';
    tauxe = S'*X1;
    varxe = S'*P1*S;
    
    S = zeros(ns,1);
    S(2) = share_xfe(t,:)*alpha_tau(t,:)';
    S(3:2+n_y) = share_xfe(t,:)';
    tauxfe = S'*X1;
    varxfe = S'*P1*S;
    
    tau_17c_mean(t,:) = [tauh tauxe tauxfe];
    tau_17c_var(t,:) = [varh varxe varxfe];
  
  end;
  
  tau_3c_mean = zeros(dnobs_60_end,3);
  tau_3c_var = zeros(dnobs_60_end,3);
  X1 = X1_init;
  P1 = P1_init;
  for t = 1:dnobs_60_end;
    H_t = H;
    H_t(1,:) = alpha_eps(t,:);
    H_t(2,:) = alpha_tau(t,:);
    Q_t = diag([(sigma_eps_common(t,1).^2) (sigma_dtau_common(t,1).^2) (sigma_dtau_unique(t,:).^2) (sigma_eps_unique(t,:).^2)]');
    % Mapping from dp_disagg to observable
    S_Y_DP = zeros(3,n_y);
    S_Y_DP(1,icore) = share_h(t,icore);
    S_Y_DP(2,ifood) = share_h(t,ifood);
    S_Y_DP(3,ienergy) = share_h(t,ienergy);
    yt = S_Y_DP*dp_disagg_60_end(t,:)';
    Rt = zeros(size(yt,1),size(yt,1));
    Ht = H_t*S_Y_DP';
    [X1,P1,X2,P2,e,ht,llf] = kfilt_llf(yt,X1,P1,Ht,F,Rt,Q_t);
    % Parameters mapping state into tau-headline 
    S = zeros(ns,1);
    S(2) = share_h(t,:)*alpha_tau(t,:)';
    S(3:2+n_y) = share_h(t,:)';
    tauh = S'*X1;
    varh = S'*P1*S;
    
    S = zeros(ns,1);
    S(2) = share_xe(t,:)*alpha_tau(t,:)';
    S(3:2+n_y) = share_xe(t,:)';
    tauxe = S'*X1;
    varxe = S'*P1*S;
    
    S = zeros(ns,1);
    S(2) = share_xfe(t,:)*alpha_tau(t,:)';
    S(3:2+n_y) = share_xfe(t,:)';
    tauxfe = S'*X1;
    varxfe = S'*P1*S;
    
    tau_3c_mean(t,:) = [tauh tauxe tauxfe];
    tau_3c_var(t,:) = [varh varxe varxfe];
  
  end;
  
  tau_h_mean = zeros(dnobs_60_end,3);
  tau_h_var = zeros(dnobs_60_end,3);
  X1 = X1_init;
  P1 = P1_init;
  for t = 1:dnobs_60_end;
    H_t = H;
    H_t(1,:) = alpha_eps(t,:);
    H_t(2,:) = alpha_tau(t,:);
    Q_t = diag([(sigma_eps_common(t,1).^2) (sigma_dtau_common(t,1).^2) (sigma_dtau_unique(t,:).^2) (sigma_eps_unique(t,:).^2)]');
    % Mapping from dp_disagg to observable
    S_Y_DP = zeros(1,n_y);
    S_Y_DP(1,:) = share_h(t,:);
    yt = S_Y_DP*dp_disagg_60_end(t,:)';
    Rt = zeros(size(yt,1),size(yt,1));
    Ht = H_t*S_Y_DP';
    [X1,P1,X2,P2,e,ht,llf] = kfilt_llf(yt,X1,P1,Ht,F,Rt,Q_t);
    % Parameters mapping state into tau-headline 
    S = zeros(ns,1);
    S(2) = share_h(t,:)*alpha_tau(t,:)';
    S(3:2+n_y) = share_h(t,:)';
    tauh = S'*X1;
    varh = S'*P1*S;
    
    S = zeros(ns,1);
    S(2) = share_xe(t,:)*alpha_tau(t,:)';
    S(3:2+n_y) = share_xe(t,:)';
    tauxe = S'*X1;
    varxe = S'*P1*S;
    
    S = zeros(ns,1);
    S(2) = share_xfe(t,:)*alpha_tau(t,:)';
    S(3:2+n_y) = share_xfe(t,:)';
    tauxfe = S'*X1;
    varxfe = S'*P1*S;
    
    tau_h_mean(t,:) = [tauh NaN NaN];
    tau_h_var(t,:) = [varh NaN NaN];
  
  end;
  
  tau_xe_mean = zeros(dnobs_60_end,3);
  tau_xe_var = zeros(dnobs_60_end,3);
  X1 = X1_init;
  P1 = P1_init;
  for t = 1:dnobs_60_end;
    H_t = H;
    H_t(1,:) = alpha_eps(t,:);
    H_t(2,:) = alpha_tau(t,:);
    Q_t = diag([(sigma_eps_common(t,1).^2) (sigma_dtau_common(t,1).^2) (sigma_dtau_unique(t,:).^2) (sigma_eps_unique(t,:).^2)]');
    % Mapping from dp_disagg to observable
    S_Y_DP = zeros(1,n_y);
    S_Y_DP(1,:) = share_xe(t,:);
    yt = S_Y_DP*dp_disagg_60_end(t,:)';
    Rt = zeros(size(yt,1),size(yt,1));
    Ht = H_t*S_Y_DP';
    [X1,P1,X2,P2,e,ht,llf] = kfilt_llf(yt,X1,P1,Ht,F,Rt,Q_t);
    % Parameters mapping state into tau-headline 
    S = zeros(ns,1);
    S(2) = share_h(t,:)*alpha_tau(t,:)';
    S(3:2+n_y) = share_h(t,:)';
    tauh = S'*X1;
    varh = S'*P1*S;
    
    S = zeros(ns,1);
    S(2) = share_xe(t,:)*alpha_tau(t,:)';
    S(3:2+n_y) = share_xe(t,:)';
    tauxe = S'*X1;
    varxe = S'*P1*S;
    
    S = zeros(ns,1);
    S(2) = share_xfe(t,:)*alpha_tau(t,:)';
    S(3:2+n_y) = share_xfe(t,:)';
    tauxfe = S'*X1;
    varxfe = S'*P1*S;
    
    tau_xe_mean(t,:) = [NaN tauxe NaN];
    tau_xe_var(t,:) = [NaN varxe NaN];
  
  end;
  
  tau_xfe_mean = zeros(dnobs_60_end,3);
  tau_xfe_var = zeros(dnobs_60_end,3);
  X1 = X1_init;
  P1 = P1_init;
  for t = 1:dnobs_60_end;
    H_t = H;
    H_t(1,:) = alpha_eps(t,:);
    H_t(2,:) = alpha_tau(t,:);
    Q_t = diag([(sigma_eps_common(t,1).^2) (sigma_dtau_common(t,1).^2) (sigma_dtau_unique(t,:).^2) (sigma_eps_unique(t,:).^2)]');
    % Mapping from dp_disagg to observable
    S_Y_DP = zeros(1,n_y);
    S_Y_DP(1,:) = share_xfe(t,:);
    yt = S_Y_DP*dp_disagg_60_end(t,:)';
    Rt = zeros(size(yt,1),size(yt,1));
    Ht = H_t*S_Y_DP';
    [X1,P1,X2,P2,e,ht,llf] = kfilt_llf(yt,X1,P1,Ht,F,Rt,Q_t);
    % Parameters mapping state into tau-headline 
    S = zeros(ns,1);
    S(2) = share_h(t,:)*alpha_tau(t,:)';
    S(3:2+n_y) = share_h(t,:)';
    tauh = S'*X1;
    varh = S'*P1*S;
    
    S = zeros(ns,1);
    S(2) = share_xe(t,:)*alpha_tau(t,:)';
    S(3:2+n_y) = share_xe(t,:)';
    tauxe = S'*X1;
    varxe = S'*P1*S;
    
    S = zeros(ns,1);
    S(2) = share_xfe(t,:)*alpha_tau(t,:)';
    S(3:2+n_y) = share_xfe(t,:)';
    tauxfe = S'*X1;
    varxfe = S'*P1*S;
    
    tau_xfe_mean(t,:) = [NaN NaN tauxfe];
    tau_xfe_var(t,:) = [NaN NaN varxfe];
  
  end;
  
  h_mean = NaN*zeros(dnobs_60_end,3);
  h_var = NaN*zeros(dnobs_60_end,3);
  xe_mean = NaN*zeros(dnobs_60_end,3);
  xe_var = NaN*zeros(dnobs_60_end,3);
  xfe_mean = NaN*zeros(dnobs_60_end,3);
  xfe_var = NaN*zeros(dnobs_60_end,3);
  for t = 1:dnobs_60_end;
    S_Y_DP = zeros(1,n_y);
    S_Y_DP = share_h(t,:);
    h_mean(t,1) = S_Y_DP*dp_disagg_60_end(t,:)';
    tmp1 = ((S_Y_DP*alpha_eps(t,:)')*sigma_eps_common(t,1))^2;
    tmp2 = sum((S_Y_DP.*sigma_eps_unique(t,:)).^2,2);
    h_var(t,1) = tmp1 + tmp2;
    
    S_Y_DP = zeros(1,n_y);
    S_Y_DP = share_xe(t,:);
    xe_mean(t,2) = S_Y_DP*dp_disagg_60_end(t,:)';
    tmp1 = ((S_Y_DP*alpha_eps(t,:)')*sigma_eps_common(t,1))^2;
    tmp2 = sum((S_Y_DP.*sigma_eps_unique(t,:)).^2,2);
    xe_var(t,2) = tmp1 + tmp2;
    
    S_Y_DP = zeros(1,n_y);
    S_Y_DP = share_xfe(t,:);
    xfe_mean(t,3) = S_Y_DP*dp_disagg_60_end(t,:)';
    tmp1 = ((S_Y_DP*alpha_eps(t,:)')*sigma_eps_common(t,1))^2;
    tmp2 = sum((S_Y_DP.*sigma_eps_unique(t,:)).^2,2);
    xfe_var(t,3) = tmp1 + tmp2;
    
  end;
  
  
  ao_h_mean = NaN*zeros(dnobs_60_end,3);
  ao_h_var = NaN*zeros(dnobs_60_end,3);
  ao_xe_mean = NaN*zeros(dnobs_60_end,3);
  ao_xe_var = NaN*zeros(dnobs_60_end,3);
  ao_xfe_mean = NaN*zeros(dnobs_60_end,3);
  ao_xfe_var = NaN*zeros(dnobs_60_end,3);
  tmp = (1:1:nper-1)';
  rw_var_fac = sum(tmp.^2)/(nper^2);
  for t = 1:dnobs_60_end;
    % Use approximation, locally constant parameter values 
    S_Y_DP = zeros(1,n_y);
    S_Y_DP = share_h(t,:);
    ao_h_mean(t,1) = S_Y_DP*dpa_disagg_60_end(t,:)';
    tmp1 = ((S_Y_DP*alpha_eps(t,:)')*sigma_eps_common(t,1))^2;
    tmp2 = sum((S_Y_DP.*sigma_eps_unique(t,:)).^2,2);
    var_eps_comp = (tmp1 + tmp2)/nper;
    tmp1 = ((S_Y_DP*alpha_tau(t,:)')*sigma_dtau_common(t,1))^2;
    tmp2 = sum((S_Y_DP.*sigma_dtau_unique(t,:)).^2,2);
    var_tau_comp = (tmp1+tmp2)*rw_var_fac;
    ao_h_var(t,1) = var_eps_comp+var_tau_comp; 
    
    S_Y_DP = zeros(1,n_y);
    S_Y_DP = share_xe(t,:);
    ao_xe_mean(t,2) = S_Y_DP*dpa_disagg_60_end(t,:)';
    tmp1 = ((S_Y_DP*alpha_eps(t,:)')*sigma_eps_common(t,1))^2;
    tmp2 = sum((S_Y_DP.*sigma_eps_unique(t,:)).^2,2);
    var_eps_comp = (tmp1 + tmp2)/nper;
    tmp1 = ((S_Y_DP*alpha_tau(t,:)')*sigma_dtau_common(t,1))^2;
    tmp2 = sum((S_Y_DP.*sigma_dtau_unique(t,:)).^2,2);
    var_tau_comp = (tmp1+tmp2)*rw_var_fac;
    ao_xe_var(t,2) = var_eps_comp+var_tau_comp; 
    
    S_Y_DP = zeros(1,n_y);
    S_Y_DP = share_xfe(t,:);
    ao_xfe_mean(t,3) = S_Y_DP*dpa_disagg_60_end(t,:)';
    tmp1 = ((S_Y_DP*alpha_eps(t,:)')*sigma_eps_common(t,1))^2;
    tmp2 = sum((S_Y_DP.*sigma_eps_unique(t,:)).^2,2);
    var_eps_comp = (tmp1 + tmp2)/nper;
    tmp1 = ((S_Y_DP*alpha_tau(t,:)')*sigma_dtau_common(t,1))^2;
    tmp2 = sum((S_Y_DP.*sigma_dtau_unique(t,:)).^2,2);
    var_tau_comp = (tmp1+tmp2)*rw_var_fac;
    ao_xfe_var(t,3) = var_eps_comp+var_tau_comp; 
    
  end;
  
  
  i_fcst = smpl(cal_60_end,[1965 1],[2015 1],4);
  tmp = cal_60_end(i_fcst==1);
  fprintf(fileID,'Results for Sample Period: %6.2f - %6.2f \n',[tmp(1) tmp(end)]);
  fprintf(fileID,'MUCSV_17c,');
  tmp = sqrt(mean(tau_17c_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'MUCSV_3c,');
  tmp = sqrt(mean(tau_3c_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'UCSV_All,');
  tmp = sqrt(mean(tau_h_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'UCSV_xE,');
  tmp = sqrt(mean(tau_xe_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'UCSV_xFE,');
  tmp = sqrt(mean(tau_xfe_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'PCE_All,');
  tmp = sqrt(mean(h_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'PCE_xE,');
  tmp = sqrt(mean(xe_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'PCE_xFE,');
  tmp = sqrt(mean(xfe_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'4QMA_PCE_All,');
  tmp = sqrt(mean(ao_h_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'4QMA_PCE_xE,');
  tmp = sqrt(mean(ao_xe_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'4QMA_PCE_xFE,');
  tmp = sqrt(mean(ao_xfe_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');  
  
 
  i_fcst = smpl(cal_60_end,[1965 1],[1989 4 1],4);
  tmp = cal_60_end(i_fcst==1);
  fprintf(fileID,'\n \n Results for Sample Period: %6.2f - %6.2f \n',[tmp(1) tmp(end)]);
  fprintf(fileID,'MUCSV_17c,');
  tmp = sqrt(mean(tau_17c_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'MUCSV_3c,');
  tmp = sqrt(mean(tau_3c_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'UCSV_All,');
  tmp = sqrt(mean(tau_h_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'UCSV_xE,');
  tmp = sqrt(mean(tau_xe_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'UCSV_xFE,');
  tmp = sqrt(mean(tau_xfe_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'PCE_All,');
  tmp = sqrt(mean(h_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'PCE_xE,');
  tmp = sqrt(mean(xe_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'PCE_xFE,');
  tmp = sqrt(mean(xfe_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'4QMA_PCE_All,');
  tmp = sqrt(mean(ao_h_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'4QMA_PCE_xE,');
  tmp = sqrt(mean(ao_xe_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'4QMA_PCE_xFE,');
  tmp = sqrt(mean(ao_xfe_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');  
  
  
  i_fcst = smpl(cal_60_end,[1990 1],[2015 1 1],4);
  tmp = cal_60_end(i_fcst==1);
  fprintf(fileID,'\n \n Results for Sample Period: %6.2f - %6.2f \n',[tmp(1) tmp(end)]);
  fprintf(fileID,'MUCSV_17c,');
  tmp = sqrt(mean(tau_17c_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'MUCSV_3c,');
  tmp = sqrt(mean(tau_3c_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'UCSV_All,');
  tmp = sqrt(mean(tau_h_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'UCSV_xE,');
  tmp = sqrt(mean(tau_xe_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'UCSV_xFE,');
  tmp = sqrt(mean(tau_xfe_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'PCE_All,');
  tmp = sqrt(mean(h_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'PCE_xE,');
  tmp = sqrt(mean(xe_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'PCE_xFE,');
  tmp = sqrt(mean(xfe_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'4QMA_PCE_All,');
  tmp = sqrt(mean(ao_h_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'4QMA_PCE_xE,');
  tmp = sqrt(mean(ao_xe_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');
  fprintf(fileID,'4QMA_PCE_xFE,');
  tmp = sqrt(mean(ao_xfe_var(i_fcst==1,:),1));
  prtmat_comma(tmp,fileID,'%5.2f ','\n');  
  