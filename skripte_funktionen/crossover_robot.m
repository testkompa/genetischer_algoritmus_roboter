function [child_gene] = crossover_robot(parent_gene_1,parent_gene_2,type)

%zeilen = length(parent_gene_1)
[zeilen,spalten] = size(parent_gene_1);

if isequal(type,'uniform')
    % Kinder gleich eltern setzen und um im nächsten schritt crossover zu
    % machen
    child_gene(1:243,1) = parent_gene_1;
    child_gene(1:243,2) = parent_gene_2;

    % Uniform Crossover
    for gg = 1: zeilen
        if rand >= 0.5
            child_gene(gg,[1,2]) = child_gene(gg,[2,1]);
        end
    end
elseif isequal(type,'one_point')
    % random cutting point
    cutting_idx = 1 + randi([1 zeilen-1],2); 

    % creating child gene with one cutting point
    child_gene(1:zeilen,1) = vertcat(parent_gene_1(1:cutting_idx),parent_gene_2(cutting_idx+1:zeilen));
    child_gene(1:zeilen,2) = vertcat(parent_gene_2(1:cutting_idx),parent_gene_1(cutting_idx+1:zeilen));

elseif isequal(type,'two_point')
    % random cutting point
    cutting_idx = 1 + randi([1 zeilen-1],1,2);

    cutting_idx = sort(cutting_idx);

    % creating child gene 
    child_gene(1:zeilen,1) = parent_gene_1;
    child_gene(1:zeilen,2) = parent_gene_2;

    child_gene([cutting_idx(1) cutting_idx(2)],1) = parent_gene_2([cutting_idx(1) cutting_idx(2)]);
    child_gene([cutting_idx(1) cutting_idx(2)],2) = parent_gene_1([cutting_idx(1) cutting_idx(2)]);
end


