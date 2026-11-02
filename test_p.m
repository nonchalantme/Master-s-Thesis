% test.m -- 
% 9/11/2015, MWW
%


clear all;

tic;
for i = 1:1000;
    x = randn(10000,100);
    xx = x'*x;
    xxi = inv(xx);
end;
toc;
  
  
  

  