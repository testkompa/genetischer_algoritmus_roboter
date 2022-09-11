function [mutated_population] = mutation_robot(population,p_mutation,type)

[zeilen,spalten] = size(population);
mutated_population = population;

if isequal(type,'normal')
    for jj = 1: spalten
        for kk = 1: zeilen
            if rand <= p_mutation
                mutated_population(kk,jj) = randi([1 6]);
            end
        end
    end
end