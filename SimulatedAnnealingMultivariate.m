% Setup %
clear
clc
eps = 0.02; %Epsilon parameter
xmin = [-10 -10]; %lower bound
xmax = [10, 10]; %upper bound
flag = 0; %for stopping iterations
iterations = 0; %to display iterations
imax = 500; %max permissible iterations
iter = []; %for plotting values later
stopping_criteria = 5; %this variable terminates the iterations if last [stopping crietria] values are same 
f = @fitness; %objective function
fval = []; %stores function evaluating for plotting

% Iterations %
while (flag == 0)
    iterations = iterations+1
    iter = [iter iterations];
    if (iterations == 1) %initialize
        x0 = xmin + (xmax-xmin).*rand;
        E0 = f(x0);
    else
        x0 = x1;
    end
    delx = x0.*eps*rand;
    x1 = x0 + delx;
    if ((x1 < xmin) | (x1>xmax))
        x1 = xmin + (xmax-xmin).*rand;
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
    
    if (length(fval) > stopping_criteria) %terminate from stopping criteria
        stop = flip(fval);
        stop = stop(1:stopping_criteria);
        if (length(unique(stop)) == 1)
            flag = 1; 
        end
    end
    if (iterations == imax) %terminate from max iterations criteria, whichever happens first
        flag = 1;
    end
end

% Results %
final = flip(fval);
final(length(final));
Minima = min(final);
x = 0;
for i = xmin(1):0.001:xmax(1)
    if (f([i i]) - Minima < 0.0001)
        x = i;
    end
end
fprintf('The minimum value is %f at x = %f', Minima, x)
plot(iter, final)