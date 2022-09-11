% Genetischer Algorithmus für Stateless Roboter Problem
clear allvars
clc

%% USER INPUT

% Population size
population_size     = 200; % INT >1

% Number of generations
generations         = 1000; % INT >1

% Number of cleaning flieds to be tested for fitness 
fields              = 100; % INT >0

% Pick selection type
selection_type      = 'tournament'; % 'tournament' or 'roulette'
tournament_rounds   = 2; % INT >0

% Pick Crossover type
crossover_type      = 'uniform'; % 'uniform' or 'one_point' or 'two_point'

% Pick Mutation type
mutation_type       ='normal'; % 'normal'

% Probability of mutation of a chomosom 
p_mutation          = 0.005; %FLOAT between 0 and 1

% Dynamic mutation prbability
P_mut_dyn           = false; % BOOLEAN 

% Number of elites to survives trough generations
number_elites       = 2; % INT 0 2 4 6...


%% Preparing variables and figure etc.
fitness         = zeros(generations,population_size);
fit_final       = zeros(1,generations);
fit_median      = zeros(1,generations);
x_final         = zeros(201,generations);
y_final         = zeros(201,generations);
points_final    = zeros(200,generations);
do_final        = zeros(200,generations);
best_gene       = zeros(243,generations);

figure()
hold on

p_mut_message = [''];

if number_elites > 0
    elite = true;
else
    elite = false;
end

%% Starting the evolution
% create initial population
population                  = initial_population_robot(population_size);
elite_population            = [];

for gg = 1 : generations
   
    % Reshaping population for fitness_robot
    population_matrix       = reshape(population,3,3,3,3,3,[]);
        
    % Determine fitness of indiviuel genes in parallel
    parfor ff = 1 : population_size
        [fitness(gg,ff),x(:,ff),y(:,ff),points(:,ff),do(:,ff),B(:,:,:,ff)] = fitness_robot(population_matrix(:,:,:,:,:,ff),fields);
    end

    % Reshapefor selection crossover mutation...
    population              = reshape(population,243,[]);

    
    %% Variables mainly for documentation and visualisation
    % possibly for p_mutation variation and restart
    [fit_max,eintrag_max]   = max(fitness(gg,:));
    fit_final(:,gg)         = fitness(gg,eintrag_max);
    x_final(:,gg)           = x(:,eintrag_max);
    y_final(:,gg)           = y(:,eintrag_max);
    points_final(:,gg)      = points(:,eintrag_max);
    do_final(:,gg)          = do(:,eintrag_max);
    B_final(:,:,:,gg)       = B(:,:,:,eintrag_max);
    fit_median(gg)          = median(fitness(gg,:));
    best_gene(:,gg)         = population(:,eintrag_max);


    %% Dynamic mutation probability
    if P_mut_dyn
        % Adapt mutation if small diffrence of max fitness and median fitness
        p_mutation = 0.005 + 1/5 * 1/(fit_final(gg)- fit_median(gg));
        if p_mutation > 1
            p_mutation = 1;
        end
         p_mut_message = ['     p_mut',num2str(p_mutation)];
    end
    

    %% plot and disp results
    result_message = ['Generation ',num2str(gg),'     Max Fitness ',num2str(fit_max)];
    final_message = append(result_message,p_mut_message);
    disp(final_message)
    plot(gg,max(fitness(gg,:)),'r.')
    plot(gg,fit_median(gg),'b.')
    xlabel('Generation')
    ylabel('Fitness')
    ylim([-500 500])
    drawnow

    if elite
        [~,elite_idx] = maxk(fitness(gg,:),number_elites);
        elite_population = population(:,elite_idx);
    end

    %% Starting genetic process Selection+crossover+mutation
    for ii = 1: (population_size-number_elites)/2

        % Selection
        % Type choices 'roulette', 'tournament'
        [parent_gene_1,parent_gene_2]           = selection_robot(population,fitness(gg,:),selection_type,tournament_rounds);

        % Crossover
        % Type choices 'uniform','single' or 'double'
        child_gene                              = crossover_robot(parent_gene_1,parent_gene_2,crossover_type);

        % creating offspring-population with children
        offspring_population(:,[2*ii-1,2*ii])   = child_gene(:,[1,2]);
    end

    mutation_population = mutation_robot(offspring_population,p_mutation,mutation_type);

        

    population = horzcat(mutation_population,elite_population);
end