function [parent_gene_1,parent_gene_2] = selection_robot(varargin)

narginchk(3,4)

population          = varargin{1};
fitness             = varargin{2};
type                = varargin{3};
tournament_rounds   = varargin{4};

% Population in form [243,[]]
[~,spalten] = size(population);

if isequal(type,'roulette')
    % create fake_fitness with only positive fitness
    fake_fitness = fitness + abs(min(fitness));

    % probability for every parent so get selected
    p_parent = fake_fitness / sum(fake_fitness);

    % pick 2 parents with probability distribution p_parent
    parent_idx = randsrc(1,2,[1:spalten;p_parent]);

    % parents cant be the same
    while parent_idx(1) == parent_idx(2)
        parent_idx = randsrc(1,2,[1:spalten;p_parent]);
    end

    % Eltern 1 und 2 erstellen
    parent_gene_1 = population(:,parent_idx(1)); % parent 1
    parent_gene_2 = population(:,parent_idx(2)); % parent 2


elseif isequal(type,'tournament')
    % noumber of rounds of tournament selection

    % random parent, will be challenged by canidate
    parent_idx = randi([1 spalten],1,2); 
    for jj = 1 : 2
        for ii = 1 : tournament_rounds
            canidate_idx = randi([1 spalten]);
            if fitness(parent_idx(jj)) < fitness(canidate_idx)
                parent_idx(jj) = canidate_idx;
            end
        end
    end
    parent_gene_1 = population(:,parent_idx(1)); % parent 1
    parent_gene_2 = population(:,parent_idx(2)); % parent 2
end




