x = linspace(-1, -0.5, 7048); % the x vector will be used to sample the 
y = zeros(size(x)); 
F = pdeInterpolant(p, t, u); 
c = evaluate(F, x, y);
c_av = 2*trapz(x, c.'.*x);
