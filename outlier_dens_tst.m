ns = 10;
sig_values=linspace(2,10.0,ns)';
nd = 100;
denvalues = linspace(-15,15,nd)';
f = zeros(nd,1);
for i = 1:ns;
    f = f+normpdf(denvalues,0,sig_values(i));
end;
f = f/ns;
f1 = normpdf(denvalues,0,1);
f2 = 0.97*f1 + 0.03*f;
plot(denvalues,[f f1 f2]);

% Posterior probabilities
p2 = (.03*f)./f2;
plot(denvalues,p2);

