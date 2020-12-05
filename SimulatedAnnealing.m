% Setup %
clear
clc
eps = 0.02;
xmin = -2.5;
xmax = 3.5;
flag = 0;
iterations = 0;
imax = 500;
iter = [];
stopping_criteria = 5;
f = @(x)(x.^5 + 5*x.^3 - 20*x -4);
fval = [];

% Iterations %
while (flag == 0)
    iterations = iterations+1
    iter = [iter iterations];
    if (iterations == 1)
        x0 = xmin + (xmax-xmin)*rand;
        E0 = f(x0);
    else
        x0 = x1;
    end
    delx = x0*eps*rand;
    x1 = x0 + delx;
    if ((x1 < xmin) || (x1>xmax))
        x1 = xmin + (xmax-xmin)*rand;
    end
    E1 = f(x1);
    if (E1 < E0)
        E0 = E1;
    else
        if (exp(-(E1 - E0)/E0) > rand)
            E0 = E1;
        else
            x1 = x0 - delx;
        end
    end
    fval = [fval f(x1)];
    
    if (length(fval) > stopping_criteria)
        stop = flip(fval);
        stop = stop(1:stopping_criteria);
        if (length(unique(stop)) == 1)
            flag = 1;
        end
    end
    if (iterations == imax)
        flag = 1;
    end
end

% Results %
final = flip(fval);
final(length(final));
Minima = min(final);
x = 0;
for i = xmin:0.001:xmax
    if (f(i) - Minima < 0.0001)
        x = i;
    end
end
fprintf('The minimum value is %f at x = %f', Minima, x)
plot(iter, final)