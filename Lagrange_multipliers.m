% Problem statement: Find the minimum cost (minimize metal, hence minimize surface area) for a
% cylindrical can to hold 10cu drink by volume.

syms r h l; %Introduce symbols
f = (2*3.141*r*r)+(2*3.141*r*h)+l*(3.141*r*r*h -10); %Define function and use lambda for constraint
P = diff(f, r) %Find partial derivatives
Q = diff(f, h)
R = diff(f, l)
assume(r>0); %Apply bounds
assume(h>0);
assume(r<=3);
assume(h<=3);
sol = solve([P, Q, R], [r, h, l]); %Solve partial derivatives to satisfy staionary conditions
radius = double(sol.r)
height = double(sol.h)
lagrange_multiplier = double(sol.l)
MinValSA = double(subs(f, {r, h, l}, {radius, height, lagrange_multiplier}))