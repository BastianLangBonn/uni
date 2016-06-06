function [alpha1,alpha2]=computeAlpha(v,w,sigma)

iN = length(v);
jN = length(w);

sigmaK = 1;
term1 = 0.0;
term2 = 0.0;
term3 = 0.0;
term4 = 0.0;
term5 = 0.0;

%compute terms for the alpha equations
for i=1:iN
    for j=1:jN
        term1 = term1 + sigma(sigmaK)*w(j);
        term2 = term2 + v(i)*w(j);
        term3 = term3 + w(j)*w(j);
        term4 = term4 + sigma(sigmaK)*v(i);
        term5 = term5 + v(i)*v(i);
    end
    sigmaK = sigmaK + 1;
end

alpha1 = (term1*term2 - term3*term4)/(term2*term2 - term3*term5);

alpha2 = (term4*term2 - term1*term5)/(term2*term2 - term3);

