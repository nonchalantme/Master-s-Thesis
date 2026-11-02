% Summary Calculations -- Table 4 check
% Compare Q3 and Montly Forecasts
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

  % Dates
  first_date = [1960 1];
  last_date = calds(end,:);
  ismpl_60_end = smpl(calvec,first_date,last_date,nper);
  cal_60_end = calvec(ismpl_60_end==1);
  dnobs_60_end = size(cal_60_end,1);
  
  outfile_name = [outdir 'Table_4_check_q' label_suffix '.out'];
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
  
  % -- Univariate Filtered and Smoothed Values
  ulabel = ['dp_agg' label_suffix];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'tau_f_mean_pct' ulabel]; load(str_tmp);
  tau_f_h = tau_f_mean_pct(:,1);
  tau_s_h = tau_mean_pct(:,1);
  tau_f_mean_pct_h = tau_f_mean_pct;
  tau_s_mean_pct_h = tau_mean_pct;
  
  ulabel = ['dp_xe' label_suffix];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'tau_f_mean_pct' ulabel]; load(str_tmp);
  tau_f_xe = tau_f_mean_pct(:,1);
  tau_s_xe = tau_mean_pct(:,1);
  tau_f_mean_pct_xe = tau_f_mean_pct;
  tau_s_mean_pct_xe = tau_mean_pct;
  
  ulabel = ['dp_xfe' label_suffix];
  str_tmp = [matdir 'tau_mean_pct' ulabel]; load(str_tmp);
  str_tmp = [matdir 'tau_f_mean_pct' ulabel]; load(str_tmp);
  tau_f_xfe = tau_f_mean_pct(:,1);
  tau_s_xfe = tau_mean_pct(:,1);tau_f_mean_pct_xfe = tau_f_mean_pct;
  tau_s_mean_pct_xfe = tau_mean_pct;
  tau_f_mean_pct_xfe = tau_f_mean_pct;
  tau_s_mean_pct_xfe = tau_mean_pct;
  
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
  
  
 % ------------- Compute Forecast Errors -----------
 % Compute Forecast Errors by Horizon
 hmax = 3*nper;  % Maximum Forecast Horizon;
 dp_act = dp_agg_60_end;   % Target Series to forecast  
 
 e_h = NaN*zeros(dnobs_60_end,hmax);
 e_xe = NaN*zeros(dnobs_60_end,hmax);
 e_xfe = NaN*zeros(dnobs_60_end,hmax);
 e_3c = NaN*zeros(dnobs_60_end,hmax);
 e_17c = NaN*zeros(dnobs_60_end,hmax);
 e_l_h = NaN*zeros(dnobs_60_end,hmax);
 e_l_xfe = NaN*zeros(dnobs_60_end,hmax);
 e_l_xe = NaN*zeros(dnobs_60_end,hmax);
 e_ao_h = NaN*zeros(dnobs_60_end,hmax);
 e_ao_xe = NaN*zeros(dnobs_60_end,hmax);
 e_ao_xfe = NaN*zeros(dnobs_60_end,hmax);
 
 % Construct Raw Forecast errors at different horizons
 for h = 1:hmax;
     % Inflation shifted forward h periods %
     dph_act = NaN*zeros(dnobs_60_end,1);
     dph_act(1:end-h) = dp_act(1+h:end);
     e_h(:,h) = dph_act - tau_f_h;
     e_xe(:,h) = dph_act - tau_f_xe;
     e_xfe(:,h) = dph_act - tau_f_xfe;
     e_3c(:,h) = dph_act - tau_f_3c;
     e_17c(:,h) = dph_act - tau_f_17c; 
     e_l_h(:,h) = dph_act - dp_agg_60_end;
     e_l_xfe(:,h) = dph_act - dp_agg_xfe_60_end;
     e_l_xe(:,h) = dph_act - dp_agg_xe_60_end;
     e_ao_h(:,h) = dph_act - dpa_agg_60_end;
     e_ao_xe(:,h) = dph_act - dpa_agg_xe_60_end;
     e_ao_xfe(:,h) = dph_act - dpa_agg_xfe_60_end;       
 end;
 % Construct Average Forecasts over different forecast horizons;
 hmat = (1:1:hmax);
 hmat = repmat(hmat,dnobs_60_end,1);
 a_h = cumsum(e_h,2)./hmat;
 a_xe = cumsum(e_xe,2)./hmat;
 a_xfe = cumsum(e_xfe,2)./hmat;
 a_17c = cumsum(e_17c,2)./hmat;
 a_3c = cumsum(e_3c,2)./hmat;
 a_l_h = cumsum(e_l_h,2)./hmat;
 a_l_xe = cumsum(e_l_xe,2)./hmat;
 a_l_xfe = cumsum(e_l_xfe,2)./hmat;
 a_ao_h = cumsum(e_ao_h,2)./hmat;
 a_ao_xe = cumsum(e_ao_xe,2)./hmat;
 a_ao_xfe = cumsum(e_ao_xfe,2)./hmat;

 
 % Set forecast errors in selected periods = 0 
 if nper == 4;
   ismpl = smpl(cal_60_end,[2008 4],[2008 4],4);
 elseif nper == 12;
   ismpl = smpl(cal_60_end,[2008 10],[2008 12],12);
 end;
 dp_act = dp_agg_60_end;      % Target Series to forecast  
 dp_act(ismpl==1) = 1.0e+32;  % Set this equal to very large number
 e_h = NaN*zeros(dnobs_60_end,hmax);
 e_xe = NaN*zeros(dnobs_60_end,hmax);
 e_xfe = NaN*zeros(dnobs_60_end,hmax);
 e_3c = NaN*zeros(dnobs_60_end,hmax);
 e_17c = NaN*zeros(dnobs_60_end,hmax);
 e_l_h = NaN*zeros(dnobs_60_end,hmax);
 e_l_xfe = NaN*zeros(dnobs_60_end,hmax);
 e_l_xe = NaN*zeros(dnobs_60_end,hmax);
 e_ao_h = NaN*zeros(dnobs_60_end,hmax);
 e_ao_xe = NaN*zeros(dnobs_60_end,hmax);
 e_ao_xfe = NaN*zeros(dnobs_60_end,hmax);
 
 % Construct Raw Forecast errors at different horizons
 for h = 1:hmax;
     % Inflation shifted forward h periods %
     dph_act = NaN*zeros(dnobs_60_end,1);
     dph_act(1:end-h) = dp_act(1+h:end);
     e_h(:,h) = dph_act - tau_f_h;
     e_xe(:,h) = dph_act - tau_f_xe;
     e_xfe(:,h) = dph_act - tau_f_xfe;
     e_3c(:,h) = dph_act - tau_f_3c;
     e_17c(:,h) = dph_act - tau_f_17c; 
     e_l_h(:,h) = dph_act - dp_agg_60_end;
     e_l_xfe(:,h) = dph_act - dp_agg_xfe_60_end;
     e_l_xe(:,h) = dph_act - dp_agg_xe_60_end;
     e_ao_h(:,h) = dph_act - dpa_agg_60_end;
     e_ao_xe(:,h) = dph_act - dpa_agg_xe_60_end;
     e_ao_xfe(:,h) = dph_act - dpa_agg_xfe_60_end;       
 end;
 % Replace very large numbers with zeros
 ii = e_h > 1.0e+25;
 e_h(ii==1) = 0;
 e_xe(ii==1) = 0;
 e_xfe(ii==1) = 0;
 e_17c(ii==1) = 0;
 e_3c(ii==1) = 0;
 e_l_h(ii==1) = 0;
 e_l_xe(ii==1) = 0;
 e_l_xfe(ii==1) = 0;
 e_ao_h(ii==1) = 0;
 e_ao_xe(ii==1) = 0;
 e_ao_xfe(ii==1) = 0;
 
 % Construct Average Forecasts over different forecast horizons;
 hmat = (1:1:hmax);
 hmat = repmat(hmat,dnobs_60_end,1);
 o_h = cumsum(e_h,2)./hmat;
 o_xe = cumsum(e_xe,2)./hmat;
 o_xfe = cumsum(e_xfe,2)./hmat;
 o_17c = cumsum(e_17c,2)./hmat;
 o_3c = cumsum(e_3c,2)./hmat;
 o_l_h = cumsum(e_l_h,2)./hmat;
 o_l_xe = cumsum(e_l_xe,2)./hmat;
 o_l_xfe = cumsum(e_l_xfe,2)./hmat;
 o_ao_h = cumsum(e_ao_h,2)./hmat;
 o_ao_xe = cumsum(e_ao_xe,2)./hmat;
 o_ao_xfe = cumsum(e_ao_xfe,2)./hmat;
 
% -- Table 4 Results
rslt_mat_1 = NaN*zeros(11,3);
rslt_mat_2 = NaN*zeros(11,3);
rslt_mat_3 = NaN*zeros(11,3);
rslt_mat_4 = NaN*zeros(11,3);
i_fcst = smpl(cal_60_end,[1990 1],calds(end,:),nper);

hvec_yr = [1 2 3]';
hvec = hvec_yr*nper;
for ih = 1:size(hvec,1);
    h = hvec(ih);
    e = [a_17c(:,h) a_3c(:,h) a_h(:,h) a_xe(:,h) a_xfe(:,h) a_l_h(:,h) a_l_xe(:,h) a_l_xfe(:,h) a_ao_h(:,h) a_ao_xe(:,h) a_ao_xfe(:,h)]; 
    e = e(i_fcst==1,:);
    e = packr(e);
    nma = h + 2;
    for i = 1:size(e,2);
     tmp1 = e(:,1).^2;
     tmp = e(:,i).^2;
     [b,vb] = hacm(tmp,nma,1);
     rslt_mat_1(i,ih) = b;
     rslt_mat_2(i,ih) = sqrt(vb);
     if i > 1;
        tmpdif = tmp-tmp1;
        [b,vb] = hacm(tmpdif,nma,1);
        rslt_mat_3(i,ih) = b;
        rslt_mat_4(i,ih) = sqrt(vb);
     end;
    end;
end;

for i = 1:size(e,2);
    fprintf(fileID,'%4.2f ',rslt_mat_1(i,1));
    fprintf(fileID,'(%4.2f),',rslt_mat_2(i,1));
    fprintf(fileID,'%4.2f ',rslt_mat_3(i,1));
    fprintf(fileID,'(%4.2f),',rslt_mat_4(i,1));
    fprintf(fileID,'%4.2f ',rslt_mat_1(i,2));
    fprintf(fileID,'(%4.2f),',rslt_mat_2(i,2));
    fprintf(fileID,'%4.2f ',rslt_mat_3(i,2));
    fprintf(fileID,'(%4.2f),',rslt_mat_4(i,2));
    fprintf(fileID,'%4.2f ',rslt_mat_1(i,3));
    fprintf(fileID,'(%4.2f),',rslt_mat_2(i,3));
    fprintf(fileID,'%4.2f ',rslt_mat_3(i,3));
    fprintf(fileID,'(%4.2f)\n',rslt_mat_4(i,3));
end;

hvec_yr = [1 2 3]';
hvec = hvec_yr*nper;
for ih = 1:size(hvec,1);
    h = hvec(ih);
    e = [o_17c(:,h) o_3c(:,h) o_h(:,h) o_xe(:,h) o_xfe(:,h) o_l_h(:,h) o_l_xe(:,h) o_l_xfe(:,h) o_ao_h(:,h) o_ao_xe(:,h) o_ao_xfe(:,h)]; 
    e = e(i_fcst==1,:);
    e = packr(e);
    nma = h + 2;
    for i = 1:size(e,2);
     tmp1 = e(:,1).^2;
     tmp = e(:,i).^2;
     [b,vb] = hacm(tmp,nma,1);
     rslt_mat_1(i,ih) = b;
     rslt_mat_2(i,ih) = sqrt(vb);
     if i > 1;
        tmpdif = tmp-tmp1;
        [b,vb] = hacm(tmpdif,nma,1);
        rslt_mat_3(i,ih) = b;
        rslt_mat_4(i,ih) = sqrt(vb);
     end;
    end;
end;

fprintf(fileID,'\n \n Without 2008Q4 \n');
for i = 1:size(e,2);
    fprintf(fileID,'%4.2f ',rslt_mat_1(i,1));
    fprintf(fileID,'(%4.2f),',rslt_mat_2(i,1));
    fprintf(fileID,'%4.2f ',rslt_mat_3(i,1));
    fprintf(fileID,'(%4.2f),',rslt_mat_4(i,1));
    fprintf(fileID,'%4.2f ',rslt_mat_1(i,2));
    fprintf(fileID,'(%4.2f),',rslt_mat_2(i,2));
    fprintf(fileID,'%4.2f ',rslt_mat_3(i,2));
    fprintf(fileID,'(%4.2f),',rslt_mat_4(i,2));
    fprintf(fileID,'%4.2f ',rslt_mat_1(i,3));
    fprintf(fileID,'(%4.2f),',rslt_mat_2(i,3));
    fprintf(fileID,'%4.2f ',rslt_mat_3(i,3));
    fprintf(fileID,'(%4.2f)\n',rslt_mat_4(i,3));
end;  