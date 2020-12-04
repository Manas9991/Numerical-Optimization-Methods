clear 
clc
N = 5; %Number of ants %k
I = 7; %Number of nodes %j
iter = 2; %Number of iterations
phi = 5; %Scaling parameter
rho = 0.5; %Evaporation 
xmin = 0.3;
xmax = 0.6;
f = @(x)(2*(sqrt(x) - 3) + sqrt(x)/100);

for iteration = 1:iter
    if (iteration == 1)
        %Create uniformly distributed variables
        increment = (xmax-xmin)/(I-1);
        x0 = [];
        for i = 1:I
            x0 = [x0 xmin + increment*(i-1)];
        end
        f0 = arrayfun(f, x0);
        roulletf0 = [];
        roulletden = sum(f0);
        for i = 1:I
            roulletf0 = [roulletf0 f0(i)/roulletden];
        end
        randomforselection = min(roulletf0) + (max(roulletf0)-min(roulletf0)).*rand(1, I);
        %select nodes from tournament:
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
            selected = [selected x0(T)];
        end
        selected = sort(selected, 'descend');
        selected = selected(1:N);
        fselected = arrayfun(f, selected);
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
        %select nodes from tournament:
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
            selected = [selected x0(T)];
        end
        selected = sort(selected, 'descend');
        selected = selected(1:N);
        fselected = arrayfun(f, selected);
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
end

%Result%
for i = 1:N
    if (fselected(i) == fbest)
        fprintf('The minimum value is %f at x = %f', fbest, selected(i))
    end
end