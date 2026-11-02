% Outlier PDF for pcomp
nper = 12;
scl_eps_vec = [1; linspace(2.0,10.0,9)'];
ps1 = 1 - 1/(2*nper);
pso = (1-ps1)/9;
ps = [ps1;pso*ones(9,1)];
xgrid = [2 3 5 8 10]';
pv = NaN*zeros(5,10);
for i = 1:5;
    for j = 1:10;
        p = 1-normcdf(xgrid(i),0,scl_eps_vec(j));
        pv(i,j) = p;
    end;
end;
[xgrid pv*ps]

