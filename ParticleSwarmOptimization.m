clear
clc
imax = 40; %number of iterations
w1 = 1; %inertia
phi1 = 1; %tuning factors
phi2 = 1;
n = 100; %population
xmin = -50; %lower bound
xmax = 50; %upper bound
fitness = @(x)(0.0833*x*x - 0.75*x + 0.6667); %fitness function


syms x;
for iter = 1:imax
    iteration = iter
    if (iter ==1)
        x0 = xmin + (xmax - xmin).*rand(1, n); %initial position
        v0 = zeros(1, n); %initial velocity
        p0 = arrayfun(fitness, x0); %inital fitness values
        pbest0 = p0; %initially the best fitness is inital fitness itself
        gbest0 = min(pbest0); %best fitness value globally
        px0 = []; %locations of particles at their best fitness
        %filter solutions from solve that are not in original population
        for i = 1:n
            points = double(solve(0.0833*x*x - 0.75*x + 0.6667 == pbest0(i)));
            for j = 1:2
                if (ismembertol(points(j), x0, 0.001))
                    point = points(j);
                end
            end
            px0 = [px0 point];
        end
        
        px0;
        
        for i = 1:n %finding the location of globally best value
            if (fitness(x0(i)) == gbest0)
                gx0 = x0(i);
            end
        end
    else
        x0 = x1;
        v0 = v1;
        p0 = p1;
        pbest0 = pbest1;
        gbest0 = gbest1;
        px0 = px1;
        gx0 = gx1;
    end
    
    v1 = w1*v0 + phi1*rand.*(px0 - x0) + phi2*rand.*(gx0 - x0); %update velocity
    x1 = x0 + v1; %update location
    p1 = arrayfun(fitness, x1); %calculate new fitness
    pbest1 = pbest0; 
    for i = 1:n %update best fitness for each particle
        if (p1(i) < pbest0(i))
            pbest1(i) = p1(i);
        end
    end
    pbest1;
    gbest1 = min(pbest1)
    px1 = []; %locations of particles at their best fitness
    %filter solutions from solve that are not in original population
    for i = 1:n
        points = double(solve(0.0833*x*x - 0.75*x + 0.6667 == pbest1(i)));
        for j = 1:2
            if (ismembertol(points(j), x1, 0.001))
                point = points(j);
            end
        end
        px1 = [px1 point];
    end
    px1;
    for i = 1:n %finding the location of globally best value
        if (fitness(x1(i)) - gbest1 < 0.001) %some tolerance is given to prevent all values from missing out
            gx1 = x1(i)
        end
    end
    
    if (iter == 1)
        subplot(2, 2, 1);
        scatter(x1, p1, 3, 'k', 'filled')
        title('Inital Positions')
        hold on;
    elseif (iter == 14)
        subplot(2, 2, 2);
        scatter(x1, p1, 3, 'k', 'filled')
        title('14 Iterations')
        hold on;
    elseif (iter == 27)
        subplot(2, 2, 3);
        scatter(x1, p1, 3, 'k', 'filled')
        title('27 Iterations')
        hold on;
    elseif (iter == 40)
        subplot(2, 2, 4);
        scatter(x1, p1, 3, 'k', 'filled')
        title('40 Iterations')
        hold on;
    end
end

fprintf('Minimum Value is %.3f on x = %.3f', gbest1, gx1)