% Set up data and calendars for monthly data in pcomp ..
% Construct Monthly and Quarterly Values of Inflation
%
% GERMAN VERSION: HICP Germany (Eurostat, COICOP 2018), 18 components.
% Adapted from the US version by mww (9/9/2015), which used BEA PCE price
% indexes and nominal PCE. The US original is pcomp_data_calendar_m_and_q_us.m.
%
% Methodology is unchanged unless the data require it. Every change is marked
%   %% CHANGE (DE-n): ...
% and listed in the block below.
%
%  DE-1  Data source and reader. BEA price/nominal files read with readxls
%        -> Eurostat HICP indexes (monthly, 2020=100) and HICP item weights
%        (annual, per mille), read with read_transposed_xlsx.
%  DE-2  Calendar. 1959m1-2015m6 -> 1996m1-2026m9 (HICP start; last month
%        with all components). Quarterly 1996Q1-2026Q3.
%  DE-3  Expenditure shares. US: nominal PCE by component (monthly). DE: no
%        monthly expenditure exists, so "nominal" series are the HICP's own
%        implied expenditures w(i,y)*p(t,i)/p(Dec y-1,i) (hicp_expend). Their
%        shares are the exact effective weights of the official HICP. The
%        Tornqvist-type share averages (t and t-1) are computed as before.
%  DE-4  Components. US: 17 sectors, with "housing excl. gas & electric
%        utilities" backed out of housing & utilities. DE: 18 sectors. Energy
%        is published directly (CP045, CP0722), so nothing needs backing out
%        for energy; instead two residual sectors are backed out exactly
%        (hicp_residual): other housing = CP04-CP041-CP045 and other
%        transport = CP07-CP0711-CP0722-CP073. CP0731 (rail) is not used
%        because it is inside CP073.
%  DE-5  Core definitions. XFE excludes food (CP01), alcohol & tobacco
%        (CP02) and energy (CP045, CP0722): the official HICP "excl. energy,
%        food, alcohol & tobacco" used by the ECB. US XFE excluded food and
%        energy only; PCE has no separate alcohol & tobacco sector.
%        XE excludes energy (CP045, CP0722).
%  DE-6  Aggregate indexes. US: total and XFE read from BEA (seasonally
%        adjusted from SA components); XE derived from total and energy goods
%        & services. DE: total, XFE, XE, energy and food indexes are built
%        from the seasonally adjusted components with the HICP formula
%        (hicp_chain). This is "indirect" seasonal adjustment, as in BEA's
%        PCE, so aggregate inflation and the share-weighted component
%        inflation stay consistent. Unadjusted, these aggregates reproduce the
%        published TOTAL / TOT_X_NRG_FOOD / TOT_X_NRG (see DE-8). The US-style
%        derived XE is kept as a check.
%  DE-7  3-component model. "Food" = food + alcohol & tobacco (CP01+CP02),
%        so that CoreXFE + Food + Energy still adds up to the total.
%        Food and energy indexes are aggregated with hicp_chain.
%  DE-8  Data check. US: nominal components must add up to nominal PCE.
%        DE: (a) component weights must add up to 1000 every year, and
%        (b) the 18 components, chain-linked with the HICP formula, must
%        reproduce the published total within 0.1%. Core is checked too
%        (warning only: Eurostat flags the special aggregates as "definition
%        differs" for 1996-2016).
%  DE-9  Seasonal adjustment. BEA data are seasonally adjusted; the HICP is
%        not. The 18 component indexes are adjusted before inflation rates
%        are computed (sa_method below); aggregates follow from them (DE-6).
%        Weights/expenditure shares use unadjusted prices, as in the
%        official HICP.
%  DE-10 Output list. Same variables as before, plus code_disagg,
%        i_xfe_disagg, i_xe_disagg, i_core_disagg (positions after ordering,
%        to replace hard-coded US indices such as icore = [1:4 6 8:9 11:17]
%        in Figure_5_6.m) and sa_isseas.
%  DE-11 Average weights (weight_avg_*) use nanmean_ instead of mean, since
%        HICP shares are missing in 1996 (no December 1995 link). US shares
%        had no missing values.
%
% Release timing: like the US version, this script builds final (latest
% vintage) data on a fixed calendar; it does not model real-time release
% lags. For the HICP: the flash total for month t is out at the end of t,
% components about mid t+1, and year-y weights are known in January of y
% (they use year y-1 expenditure). The calendar therefore ends at the last
% month with all components (2026m9, not the Oct 2026 flash total).
%
% Settings the calling program must define (unchanged): load_data, matdir,
% mtoq_agg. Optional: datadir, sa_method.

if load_data == 1;

% ----------- Features of Data Set ---------
%% CHANGE (DE-1): HICP workbooks instead of BEA files. Missing values are ':'
%  in the files and become NaN in read_transposed_xlsx, so miss_code and ns
%  are no longer needed.
if ~exist('datadir','var');
    datadir = fullfile(pwd,'data');
end;
xls_index   = fullfile(datadir,'HICP_2020100.xlsx');
sheet_index = 'HICP Transposed';
xls_weights   = fullfile(datadir,'HICP_Weights.xlsx');
sheet_weights = 'HICP Weights Transposed';

%% CHANGE (DE-9): seasonal adjustment method
%   0 = none (NOT recommended; HICP is not seasonally adjusted)
%   1 = built-in robust ratio-to-moving-average method (seas_adj_ma)
%   2 = read series adjusted externally (e.g. X-13 in JDemetra+) from
%       xls_sa / sheet_sa, same transposed layout, codes as in sa_codes below
if ~exist('sa_method','var');
    sa_method = 1;
end;
sa_nyr_win = 3;     % seas_adj_ma: 7-year moving median for seasonal factors
sa_fcrit   = 2.3;   % seas_adj_ma: F critical value for stable seasonality
if ~exist('sa_export','var'); sa_export = 0; end;    % 1 = write unadjusted series to CSV for external SA
xls_sa   = fullfile(datadir,'HICP_SA.xlsx');
sheet_sa = 'HICP SA';

% ----------- Sample Period, Calendars and so forth
%% CHANGE (DE-2): HICP sample
[dnobs_m,calvec_m,calds_m] = calendar_make([1996 1],[2026 9],12);
[dnobs_q,calvec_q,calds_q] = calendar_make([1996 1],[2026 3],4);

% ----------- Component definitions
%% CHANGE (DE-4): 18 HICP components (US: order codes came from the Excel file)
%  columns: code | label | short label | order
comp_def = { ...
 'CP01'  , 'Food and non-alcoholic beverages'                          , 'Food & non-alc. bev.'         , 1 ; ...
 'CP02'  , 'Alcoholic beverages, tobacco and narcotics'                , 'Alcohol & tobacco'            , 2 ; ...
 'CP03'  , 'Clothing and footwear'                                     , 'Clothing & footwear'          , 3 ; ...
 'CP041' , 'Actual rental payments for housing'                        , 'Actual rents'                 , 4 ; ...
 'CP045' , 'Electricity, gas and other fuels'                          , 'Electricity, gas & fuels'     , 5 ; ...
 'CP04X' , 'Housing excl. rents and household energy'                  , 'Other housing'                , 6 ; ...
 'CP05'  , 'Furnishings, household equipment and maintenance'          , 'Furnishings & hh equip.'      , 7 ; ...
 'CP06'  , 'Health'                                                    , 'Health'                       , 8 ; ...
 'CP0711', 'Motor cars'                                                , 'Motor cars'                   , 9 ; ...
 'CP0722', 'Fuels and lubricants for personal transport equipment'     , 'Fuels for transport'          ,10 ; ...
 'CP073' , 'Passenger transport services'                              , 'Passenger transport serv.'    ,11 ; ...
 'CP07X' , 'Transport excl. cars, fuels and passenger transport serv.' , 'Other transport'              ,12 ; ...
 'CP08'  , 'Information and communication'                             , 'Information & comm.'          ,13 ; ...
 'CP09'  , 'Recreation, sport and culture'                             , 'Recreation & culture'         ,14 ; ...
 'CP10'  , 'Education services'                                        , 'Education'                    ,15 ; ...
 'CP11'  , 'Restaurants and accommodation services'                    , 'Restaurants & accomm.'        ,16 ; ...
 'CP12'  , 'Insurance and financial services'                          , 'Insurance & financial'        ,17 ; ...
 'CP13'  , 'Personal care, social protection and misc. goods and serv.', 'Personal care & misc.'        ,18 ; ...
 };
code_food   = {'CP01';'CP02'};           % excluded from XFE  (DE-5)
code_energy = {'CP045';'CP0722'};        % excluded from XFE and XE

% --------------- Read In Monthly HICP Price Indexes (2020=100) ----------------
%% CHANGE (DE-1)
[namevec_p,labelvec_p,datemat_p,datamat_p] = read_transposed_xlsx(xls_index,sheet_index,12);
% Align with the monthly calendar (error if any calendar month is missing)
pce_p_raw = NaN(dnobs_m,size(datamat_p,2));
for i = 1:dnobs_m;
    j = find(datemat_p(:,1)==calds_m(i,1) & datemat_p(:,2)==calds_m(i,2));
    if isempty(j);
        error('Month %d-%02d missing in %s',calds_m(i,1),calds_m(i,2),xls_index);
    end;
    pce_p_raw(i,:) = datamat_p(j(1),:);
end;

% --------------- Read In Annual HICP Item Weights (per mille) ----------------
[namevec_w,labelvec_w,datemat_w,datamat_w] = read_transposed_xlsx(xls_weights,sheet_weights,1);
wyears = datemat_w(:,1);
for y = calds_m(1,1):calds_m(end,1);
    if ~any(wyears==y);
        error('Weights for year %d missing in %s',y,xls_weights);
    end;
end;

% Helper to pull a published series by code
getp = @(c) pce_p_raw(:,colnumber(c,namevec_p));
getw = @(c) datamat_w(:,colnumber(c,namevec_w));
need = {'TOTAL','TOT_X_NRG','TOT_X_NRG_FOOD','CP04','CP07'};
for i = 1:numel(need);
    if colnumber(need{i},namevec_p)==0 || colnumber(need{i},namevec_w)==0;
        error('Series %s not found in the HICP files',need{i});
    end;
end;

% Published aggregates (unadjusted) -- used for the data check (DE-8)
%% CHANGE (DE-6): the aggregates used for inflation are built from the
%  seasonally adjusted components below (US: read from file by tcode)
p_agg_nsa     = getp('TOTAL');            % HICP overall index
p_agg_xfe_nsa = getp('TOT_X_NRG_FOOD');   % excl. energy, food, alcohol & tobacco
p_agg_xe_nsa  = getp('TOT_X_NRG');        % excl. energy

% Compute residual components (analogue of the US housing/energy split)
%% CHANGE (DE-4): other housing and other transport backed out exactly
[p_04x,w_04x] = hicp_residual(getp('CP04'),getw('CP04'), ...
                              [getp('CP041') getp('CP045')],[getw('CP041') getw('CP045')], ...
                              wyears,calds_m);
[p_07x,w_07x] = hicp_residual(getp('CP07'),getw('CP07'), ...
                              [getp('CP0711') getp('CP0722') getp('CP073')], ...
                              [getw('CP0711') getw('CP0722') getw('CP073')], ...
                              wyears,calds_m);

% Assemble the disaggregated price indexes and annual weights
n_incl = size(comp_def,1);
p_disagg_nsa = NaN(dnobs_m,n_incl);
w_disagg_ann = NaN(numel(wyears),n_incl);
for i = 1:n_incl;
    c = comp_def{i,1};
    if strcmp(c,'CP04X');
        p_disagg_nsa(:,i) = p_04x;  w_disagg_ann(:,i) = w_04x;
    elseif strcmp(c,'CP07X');
        p_disagg_nsa(:,i) = p_07x;  w_disagg_ann(:,i) = w_07x;
    else
        if colnumber(c,namevec_p)==0 || colnumber(c,namevec_w)==0;
            error('Component %s not found in the HICP files',c);
        end;
        p_disagg_nsa(:,i) = getp(c);  w_disagg_ann(:,i) = getw(c);
    end;
end;
namevec_disagg        = comp_def(:,1);
labelvec_disagg       = comp_def(:,2);
labelvec_short_disagg = comp_def(:,3);
ordervec              = cell2mat(comp_def(:,4));
i_food   = find(ismember(namevec_disagg,code_food));
i_energy = find(ismember(namevec_disagg,code_energy));
i_xfe    = [i_food; i_energy]';       % excluded from XFE (US: i_xfe = [5 7 16])
i_xe     = i_energy';                 % excluded from XE  (US: i_xe = [7 16])
i_core   = setdiff(1:n_incl,i_xfe);
i_nonenergy = setdiff(1:n_incl,i_energy);

% Check: every component has data at the end of the calendar
if any(isnan(p_disagg_nsa(end,:)));
    error('Some components have no data in the last calendar month: shorten the calendar');
end;

%% CHANGE (DE-3): implied expenditures replace nominal PCE
nom_disagg = hicp_expend(p_disagg_nsa,w_disagg_ann,wyears,calds_m);
nom_agg    = sum(nom_disagg,2);
nom_egs    = sum(nom_disagg(:,i_energy),2);      % Energy goods and services
nom_agg_xfe = sum(nom_disagg(:,i_core),2);       % Core (XFE)
pce_nom    = nom_disagg;

% ... Data Check ...
%% CHANGE (DE-8)
% (a) weights of the components add to the total (1000) in every year
tmp = sum(w_disagg_ann,2) - getw('TOTAL');
if max(abs(tmp)) > 0.5;
    error('component weights do not add to 1000 (max gap %6.3f)',max(abs(tmp)));
end;
% (b) components reproduce the published total; (c) core and XE likewise
p_chk     = hicp_chain(p_disagg_nsa,w_disagg_ann,wyears,calds_m);
p_chk_xfe = hicp_chain(p_disagg_nsa(:,i_core),w_disagg_ann(:,i_core),wyears,calds_m);
p_chk_xe  = hicp_chain(p_disagg_nsa(:,i_nonenergy),w_disagg_ann(:,i_nonenergy),wyears,calds_m);
gap = NaN(dnobs_m,3);
for t = 1:dnobs_m;
    idec = find(calds_m(:,1)==calds_m(t,1)-1 & calds_m(:,2)==12,1);
    if isempty(idec) || isnan(p_chk(t)); continue; end;
    gap(t,1) = log(p_chk(t)/p_chk(idec))         - log(p_agg_nsa(t)/p_agg_nsa(idec));
    gap(t,2) = log(p_chk_xfe(t)/p_chk_xfe(idec)) - log(p_agg_xfe_nsa(t)/p_agg_xfe_nsa(idec));
    gap(t,3) = log(p_chk_xe(t)/p_chk_xe(idec))   - log(p_agg_xe_nsa(t)/p_agg_xe_nsa(idec));
end;
if max(abs(gap(:,1))) > 0.001;
    error('components do not reproduce the published HICP total (max gap %6.4f%%)',100*max(abs(gap(:,1))));
end;
i17 = calds_m(:,1) >= 2017;
fprintf('HICP data check (max within-year gap vs published): total %6.4f%%; XFE %6.4f%% from 2017, %6.4f%% before; XE %6.4f%% from 2017, %6.4f%% before\n', ...
        100*max(abs(gap(:,1))),100*max(abs(gap(i17,2))),100*max(abs(gap(~i17,2))), ...
        100*max(abs(gap(i17,3))),100*max(abs(gap(~i17,3))));
if max(max(abs(gap(i17,2:3)))) > 0.001;
    warning('components do not reproduce TOT_X_NRG_FOOD / TOT_X_NRG after 2017');
end;
nom_food = sum(nom_disagg(:,i_food),2);

% ---------------- Seasonal adjustment of the component indexes --------------
%% CHANGE (DE-9)
sa_codes = namevec_disagg;
if sa_export == 1;
    fid = fopen(fullfile(datadir,'HICP_NSA_for_SA.csv'),'w');
    fprintf(fid,'Year,Month,Period'); fprintf(fid,',%s',sa_codes{:}); fprintf(fid,'\n');
    mstr = {'JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'};
    for t = 1:dnobs_m;
        fprintf(fid,'%d,%s,%d-%02d',calds_m(t,1),mstr{calds_m(t,2)},calds_m(t,1),calds_m(t,2));
        fprintf(fid,',%.6f',p_disagg_nsa(t,:)); fprintf(fid,'\n');
    end;
    fclose(fid);
end;
if sa_method == 0;
    p_disagg = p_disagg_nsa;  sa_isseas = zeros(1,n_incl);
elseif sa_method == 1;
    [p_disagg,sa_sf,sa_isseas,sa_fstat] = seas_adj_ma(p_disagg_nsa,calds_m,sa_nyr_win,sa_fcrit);
elseif sa_method == 2;
    [c_sa,~,d_sa,x_sa] = read_transposed_xlsx(xls_sa,sheet_sa,12);
    p_disagg = NaN(size(p_disagg_nsa));
    for j = 1:n_incl;
        k = colnumber(sa_codes{j},c_sa);
        if k==0; error('Series %s missing in %s',sa_codes{j},xls_sa); end;
        for t = 1:dnobs_m;
            r = find(d_sa(:,1)==calds_m(t,1) & d_sa(:,2)==calds_m(t,2),1);
            if ~isempty(r); p_disagg(t,j) = x_sa(r,k); end;
        end;
    end;
    sa_isseas = ones(1,n_incl);
else
    error('sa_method must be 0, 1 or 2');
end;

% Aggregate price indexes from the (adjusted) components, 2020 = 100
%% CHANGE (DE-6, DE-7): HICP formula on SA components ("indirect" SA)
agg_sets = {1:n_incl, i_core, i_nonenergy, i_energy', i_food'};
p_aggs = NaN(dnobs_m,numel(agg_sets));
i2020 = calds_m(:,1) == 2020;
for j = 1:numel(agg_sets);
    tmp = hicp_chain(p_disagg(:,agg_sets{j}),w_disagg_ann(:,agg_sets{j}),wyears,calds_m);
    p_aggs(:,j) = 100*tmp/mean(tmp(i2020));
end;
p_agg     = p_aggs(:,1);     % HICP total
p_agg_xfe = p_aggs(:,2);     % excl. energy, food, alcohol & tobacco
p_agg_xe  = p_aggs(:,3);     % excl. energy
p_egs     = p_aggs(:,4);     % energy (CP045 + CP0722)
p_food    = p_aggs(:,5);     % food incl. alcohol & tobacco (CP01 + CP02)

 % Compute Various Inflation Measures for Aggregate and Dissaggregate HICP
 % -- Monthly data
 p_agg_m = p_agg;
 p_agg_xfe_m = p_agg_xfe;
 p_disagg_m = p_disagg;
 nom_disagg_m = nom_disagg;
 nom_agg_m = nom_agg;
 nom_agg_xfe_m = nom_agg_xfe;
 pce_nom_m = pce_nom;
 nom_egs_m = nom_egs;
 p_egs_m = p_egs;

 % -- Quarterly data   (unchanged: mtoq_agg set by the calling program)
 p_agg_q = mtoq(p_agg,calds_m,calds_q,mtoq_agg);
 p_agg_xfe_q = mtoq(p_agg_xfe,calds_m,calds_q,mtoq_agg);
 p_disagg_q = mtoq(p_disagg,calds_m,calds_q,mtoq_agg);
 nom_disagg_q = mtoq(nom_disagg,calds_m,calds_q,mtoq_agg);
 nom_agg_q = mtoq(nom_agg,calds_m,calds_q,mtoq_agg);
 nom_agg_xfe_q = mtoq(nom_agg_xfe,calds_m,calds_q,mtoq_agg);
 pce_nom_q = mtoq(pce_nom,calds_m,calds_q,mtoq_agg);
 nom_egs_q = mtoq(nom_egs,calds_m,calds_q,mtoq_agg);
 p_egs_q = mtoq(p_egs,calds_m,calds_q,mtoq_agg);

 % --- Monthly Inflation ----
 paar = 1200;
 dp_agg_m = paar*dif(log(p_agg_m),1);
 dp_agg_xfe_m = paar*dif(log(p_agg_xfe_m),1);
 dp_disagg_m = paar*dif(log(p_disagg_m),1);

 % --- Quarterly Inflation ----
 paar = 400;
 dp_agg_q = paar*dif(log(p_agg_q),1);
 dp_agg_xfe_q = paar*dif(log(p_agg_xfe_q),1);
 dp_disagg_q = paar*dif(log(p_disagg_q),1);

 % Compute dp_agg_xe:  aggregate inflation excluding energy
 %% CHANGE (DE-6): XE index built from non-energy components (US: derived
 %  from total and energy with the formula below, kept here as a check).
 % -- Monthly
 s_egs_agg_m = nom_egs_m./nom_agg_m;            % Share of energy goods and services in total
 dp_egs_m = 1200*dif(log(p_egs_m),1);           % Energy goods and services Inflation
 dp_agg_xe_derived_m = (dp_agg_m - s_egs_agg_m.*dp_egs_m)./(1-s_egs_agg_m);
 p_agg_xe_m = p_agg_xe;
 dp_agg_xe_m = 1200*dif(log(p_agg_xe_m),1);

 % -- Quarterly
 p_agg_xe_q = mtoq(p_agg_xe_m,calds_m,calds_q,mtoq_agg);
 dp_agg_xe_q = 400*dif(log(p_agg_xe_q),1);
 s_egs_agg_q = nom_egs_q./nom_agg_q;            % Share of energy goods and services in total
 dp_egs_q = 400*dif(log(p_egs_q),1);            % Energy goods and services Inflation

 %  Compute Shares of nominal expenditure   (unchanged formulas, DE-3 inputs)
 %  --- Monthly
 tmp = sum(nom_disagg_m,2);
 share_disagg_m = nom_disagg_m./repmat(tmp,1,n_incl);
 share_avg_m = NaN*zeros(dnobs_m,n_incl);
 share_avg_m(2:end,:) = (nom_disagg_m(2:end,:)+nom_disagg_m(1:end-1,:))./(repmat(tmp(2:end),1,n_incl)+repmat(tmp(1:end-1),1,n_incl));

 %  --- Quarterly
 tmp = sum(nom_disagg_q,2);
 share_disagg_q = nom_disagg_q./repmat(tmp,1,n_incl);
 share_avg_q = NaN*zeros(dnobs_q,n_incl);
 share_avg_q(2:end,:) = (nom_disagg_q(2:end,:)+nom_disagg_q(1:end-1,:))./(repmat(tmp(2:end),1,n_incl)+repmat(tmp(1:end-1),1,n_incl));

 % -- Compute Shares for XFE Components
 %% CHANGE (DE-5): i_xfe / i_xe found by code, not hard-coded positions
 share_avg_xfe_m = share_avg_m;
 share_avg_xfe_m(:,i_xfe) = 0;
 share_avg_xfe_m = share_avg_xfe_m./repmat(sum(share_avg_xfe_m,2),1,size(share_avg_m,2));
 share_avg_xe_m = share_avg_m;
 share_avg_xe_m(:,i_xe) = 0;
 share_avg_xe_m = share_avg_xe_m./repmat(sum(share_avg_xe_m,2),1,size(share_avg_m,2));
 share_avg_xfe_q = share_avg_q;
 share_avg_xfe_q(:,i_xfe) = 0;
 share_avg_xfe_q = share_avg_xfe_q./repmat(sum(share_avg_xfe_q,2),1,size(share_avg_q,2));
 share_avg_xe_q = share_avg_q;
 share_avg_xe_q(:,i_xe) = 0;
 share_avg_xe_q = share_avg_xe_q./repmat(sum(share_avg_xe_q,2),1,size(share_avg_q,2));

% Compute Approximations to Aggregate inflation   (unchanged)
 % -- Monthly --
 tmp = dp_disagg_m.*share_avg_m;
 dp_agg_approx1_m = sum(tmp,2);
 %% CHANGE (DE-11)
 weight_avg_m = nanmean_(share_disagg_m)';
 dp_agg_approx2_m = dp_disagg_m*weight_avg_m;
 dif1_m = dp_agg_m - dp_agg_approx1_m;
 dif2_m = dp_agg_m - dp_agg_approx2_m;

 % -- Quarterly --
 tmp = dp_disagg_q.*share_avg_q;
 dp_agg_approx1_q = sum(tmp,2);
 weight_avg_q = nanmean_(share_disagg_q)';
 dp_agg_approx2_q = dp_disagg_q*weight_avg_q;
 dif1_q = dp_agg_q - dp_agg_approx1_q;
 dif2_q = dp_agg_q - dp_agg_approx2_q;

% Reorder components by ordervec;   (unchanged)
[tmp,i_order] = sort(ordervec,'ascend');
nom_disagg_m = nom_disagg_m(:,i_order);
dp_disagg_m = dp_disagg_m(:,i_order);
share_avg_m = share_avg_m(:,i_order);
share_avg_xe_m = share_avg_xe_m(:,i_order);
share_avg_xfe_m = share_avg_xfe_m(:,i_order);
weight_avg_m = weight_avg_m(i_order);
nom_disagg_q = nom_disagg_q(:,i_order);
dp_disagg_q = dp_disagg_q(:,i_order);
share_avg_q = share_avg_q(:,i_order);
share_avg_xe_q = share_avg_xe_q(:,i_order);
share_avg_xfe_q = share_avg_xfe_q(:,i_order);
weight_avg_q = weight_avg_q(i_order);
labelvec_disagg = labelvec_disagg(i_order);
labelvec_short_disagg = labelvec_short_disagg(i_order);
namevec_disagg = namevec_disagg(i_order);
%% CHANGE (DE-10): positions after ordering, for downstream programs
code_disagg  = namevec_disagg;
i_xfe_disagg = find(ismember(namevec_disagg,[code_food; code_energy]))';
i_xe_disagg  = find(ismember(namevec_disagg,code_energy))';
i_core_disagg = setdiff(1:n_incl,i_xfe_disagg);

% Compute a new dissagregated version of inflation using core_xfe, food, and
% energy
%% CHANGE (DE-7): food = food + alcohol & tobacco (CP01+CP02), so the three
%  components add to the total; US used the single food sector 'DFXARG'.
dp_food_m = 1200*dif(log(p_food),1);
nom_food_m = nom_food;
% -- Monthly --
nom_disagg_3comp_m = [nom_agg_xfe_m nom_food_m nom_egs_m];
tmp = sum(nom_disagg_3comp_m,2);
share_disagg_3comp_m = nom_disagg_3comp_m./repmat(tmp,1,3);
share_avg_3comp_m = NaN*zeros(dnobs_m,3);
share_avg_3comp_m(2:end,:) = (nom_disagg_3comp_m(2:end,:)+nom_disagg_3comp_m(1:end-1,:))./(repmat(tmp(2:end),1,3)+repmat(tmp(1:end-1),1,3));
weight_avg_3comp_m = nanmean_(share_disagg_3comp_m)';
dp_disagg_3comp_m = [dp_agg_xfe_m dp_food_m dp_egs_m];
% -- Quarterly --
p_food_q = mtoq(p_food,calds_m,calds_q,mtoq_agg);
dp_food_q = 400*dif(log(p_food_q),1);
nom_food_q = mtoq(nom_food,calds_m,calds_q,mtoq_agg);
nom_disagg_3comp_q = [nom_agg_xfe_q nom_food_q nom_egs_q];
tmp = sum(nom_disagg_3comp_q,2);
share_disagg_3comp_q = nom_disagg_3comp_q./repmat(tmp,1,3);
share_avg_3comp_q = NaN*zeros(dnobs_q,3);
share_avg_3comp_q(2:end,:) = (nom_disagg_3comp_q(2:end,:)+nom_disagg_3comp_q(1:end-1,:))./(repmat(tmp(2:end),1,3)+repmat(tmp(1:end-1),1,3));
weight_avg_3comp_q = nanmean_(share_disagg_3comp_q)';
dp_disagg_3comp_q = [dp_agg_xfe_q dp_food_q dp_egs_q];

share_avg_3comp_xfe_m = share_avg_3comp_m;
share_avg_3comp_xfe_m(:,[2 3]) = 0;
share_avg_3comp_xfe_m(:,1) = 1;
share_avg_3comp_xfe_q = share_avg_3comp_q;
share_avg_3comp_xfe_q(:,[2 3]) = 0;
share_avg_3comp_xfe_q(:,1) = 1;
share_avg_3comp_xe_m = share_avg_3comp_m;
share_avg_3comp_xe_m(:,3) = 0;
share_avg_3comp_xe_m = share_avg_3comp_xe_m./repmat(sum(share_avg_3comp_xe_m,2),1,size(share_avg_3comp_m,2));
share_avg_3comp_xe_q = share_avg_3comp_q;
share_avg_3comp_xe_q(:,3) = 0;
share_avg_3comp_xe_q = share_avg_3comp_xe_q./repmat(sum(share_avg_3comp_xe_q,2),1,size(share_avg_3comp_q,2));

labelvec_disagg_3comp = ['CoreXFE';'Food   ';'Energy '];   % Food = food + alcohol & tobacco
namevec_disagg_3comp = ['CoreXFE';'Food   ';'Energy '];
n_incl_3comp = 3;

 % Save Variable Series   (unchanged list + DE-10 additions at the end)
  slist = {...
           'nom_agg_m' ...
           'nom_disagg_m' ...
           'dp_agg_m' ...
           'dp_agg_xfe_m' ...
           'dp_agg_xe_m' ...
           'dp_disagg_m' ...
           'dp_agg_approx1_m' ...
           'dp_agg_approx2_m' ...
           'share_avg_m' ...
           'weight_avg_m' ...
           'dp_disagg_3comp_m' ...
           'share_avg_3comp_m' ...
           'weight_avg_3comp_m' ...
           'calvec_m' ...
           'calds_m' ...
           'dnobs_m' ...
           'nom_agg_q' ...
           'nom_disagg_q' ...
           'dp_agg_q' ...
           'dp_agg_xfe_q' ...
           'dp_agg_xe_q' ...
           'dp_disagg_q' ...
           'dp_agg_approx1_q' ...
           'dp_agg_approx2_q' ...
           'share_avg_q' ...
           'weight_avg_q' ...
           'dp_disagg_3comp_q' ...
           'share_avg_3comp_q' ...
           'weight_avg_3comp_q' ...
           'calvec_q' ...
           'calds_q' ...
           'dnobs_q' ...
           'n_incl' ...
           'labelvec_disagg' ...
           'labelvec_short_disagg' ...
           'namevec_disagg' ...
           'labelvec_disagg_3comp' ...
           'namevec_disagg_3comp' ...
           'n_incl_3comp' ...
           'share_avg_xfe_m' ...
           'share_avg_xe_m' ...
           'share_avg_xfe_q' ...
           'share_avg_xe_q' ...
           'share_avg_3comp_xfe_m' ...
           'share_avg_3comp_xe_m' ...
           'share_avg_3comp_xfe_q' ...
           'share_avg_3comp_xe_q' ...
           'code_disagg' ...
           'i_xfe_disagg' ...
           'i_xe_disagg' ...
           'i_core_disagg' ...
           'sa_isseas' ...
          }';
  str_tmp = [matdir 'slist'];
  save(str_tmp,'slist');
  for iseries = 1:size(slist,1);
     ustr = char(slist(iseries));
     str_tmp = [matdir ustr];
     str_tmp1 = 'save(str_tmp,''';
     str_tmp2 = ''');';
     eval([str_tmp1 ustr str_tmp2]);
  end;


end;  %Load Data end;


% Load Variables and Give Standard Names
str_tmp = [matdir 'slist'];
load(str_tmp);
for iseries = 1:size(slist,1);
     ustr = char(slist(iseries));
     str_tmp = [matdir ustr];
     load(str_tmp);
end;
