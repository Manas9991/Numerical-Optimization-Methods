clear 
clc
N = 150; %Number of ants %k
I = 200; %Number of nodes %j
iter = 10; %Number of iterations
phi = 3; %Scaling parameter
rho = 0.1; %Evaporation 
xmin = [-10; -10]; %Lower bound
xmax = [10; 10]; %Upper bound
f = @fitness; %Objective function
anspoints = [];
ansvalues = [];

for iteration = 1:iter
    if (iteration == 1)
        %Creating equidistant variables in given range
        increment = (xmax-xmin)/(I-1);
        x0 = [];
        for i = 1:I
            x0 = [x0 xmin + increment*(i-1)];
        end
        f0 = [];
        for i = 1:I
            f0 = [f0 f(x0(1:2, i))];
        end
        roulletf0 = [];
        roulletden = sum(f0);
        for i = 1:I
            roulletf0 = [roulletf0 f0(i)/roulletden];
        end
        randomforselection = min(roulletf0) + (max(roulletf0)-min(roulletf0)).*rand(1, I);
        %select nodes from Roullete Wheel:
        selected = [];
        for i = 1:I
            dist = inf;
            T = 0;
            for j = 1:I
                if (abs(randomforselection(i) - roulletf0(j)) < dist)
                    T = j;
                    dist = abs(randomforselection(i) - roulletf0(j));
                end    
            end
            selected = [selected x0(1:2, T)];
        end
        selected = sort(selected, 'descend');
        selected = selected(1:2, 1:N);
        fselected = [];
        for k = 1:N
            fselected = [fselected f(selected(1:2, k))];
        end
        fbest = min(fselected);
        fworst = max(fselected);
        deltau = phi*fbest/fworst;
        tau = [];
        for i = 1:N
            tau = [tau (1-rho)*i + deltau];
        end
        sumtau = sum(tau);
        probab = [];
        for i = 1:N
            probab = [probab tau(i)/sumtau];
        end    
    
    else
        randomforselection = min(probab) + (max(probab)-min(probab)).*rand(1, N);
        selected = [];
        for i = 1:N
            dist = inf;
            T = 0;
            for j = 1:N
                if (abs(randomforselection(i) - probab(j)) < dist)
                    T = j;
                    dist = abs(randomforselection(i) - probab(j));
                end    
            end
            selected = [selected x0(1:2, T)];
        end
        selected = sort(selected, 'descend');
        selected = selected(1:2, 1:N);
        fselected = [];
        for k = 1:N
            fselected = [fselected f(selected(1:2, k))];
        end
        fbest = min(fselected);
        fworst = max(fselected);
        deltau = phi*fbest/fworst;
        tau = [];
        for i = 1:N
            tau = [tau (1-rho)*i + deltau];
        end
        sumtau = sum(tau);
        probab = [];
        for i = 1:N
            probab = [probab tau(i)/sumtau];
        end
    end
    
    flag = 0;
    for i = 1:N
        if ((fselected(i) == fbest) && (flag == 0)) 
            anspoints = [anspoints selected(1:2, i)];
            flag = 1;
        end
    end
    ansvalues = [ansvalues fbest];
    
end

%Result%
flag = 0;
for i = 1:N
    if ((fselected(i) == fbest) && (flag == 0))
        fprintf('The minimum value is %f at x = %f, %f', fbest, selected(1, i), selected(2, i))
        flag = 1;
    end
end

[X1, X2] = meshgrid(xmin:0.25:xmax);
Z = (X1-5).^2 + (X2-5).^2;
surf(X1, X2, Z)
hold on;
scatter3(anspoints(1, :), anspoints(2, :), ansvalues, 'w', 'filled')