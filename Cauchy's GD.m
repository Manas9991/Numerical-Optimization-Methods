res = 0.0001; %resolution of solution (allowable error)
x0 = [0.1; 0.1]; %starting point
X0 = x0; %for looping
X1 = x0+res; %for looping
xx = [x0(1)]; %for plotting convergence
yy = [x0(2)];
syms x y a; %Introduce symbols
f = (x.^2 + y - 11).^2 + (x + y.^2 - 7).^2; %Define function (Himmelblau Fx is used here)
grad = gradient(f, [x, y])
iterations = 0;

while (abs(X1-X0) >= res)

    X0 = x0;
    s0 = subs(grad, {x, y}, {x0(1), x0(2)}); %Gradient at initial point
    x1 = x0 - s0*a;
    fa = subs(f, {x, y}, {x1(1), x1(2)});
    opta = vpasolve(diff(fa, a)==0, a, [0.01, 1]); %Enter range of alpha estimated, or use solve command.
    x1 = x0 - s0*opta; %value of starting point for next iteration
    X1 = x1;
    x0 = x1; %for next iteration
    xx = [xx x0(1)];
    yy = [yy x0(2)];
    s1 = subs(grad, {x, y}, {x1(1), x1(2)}); %Gradient at next iteration's initial point
    s0 = s1; %for next iteration
    iterations = iterations + 1;
end

Iterations = iterations
Minima = x1
MinVal = subs(f, {x, y}, {x1(1), x1(2)})

[X,Y] = meshgrid(0:0.1:3.25);                                
Z = (X.^2 + Y - 11).^2 + (X + Y.^2 - 7).^2;
surf(X,Y,Z)
%xx = meshgrid(xx);
%yy = meshgrid(yy);
zz = (xx.^2 + yy - 11).^2 + (xx + yy.^2 - 7).^2;
hold on
plot3(xx, yy, zz, 'w', 'LineWidth', 3)
