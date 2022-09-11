function [initial_population] = initial_population_robot(population_size)
% Genernerieung der population
% Matrix der Größe 243 * population_size
% Eine Spalte entspricht einem Genom 
% Einträge sind random Integers von 1 bis 7, da 7 Handlungsmöglichkeiten zu
% verfügung stehen
% 1 Dose aufheben
% 2 Zufällig bewegen
% 3 Rechts gehen
% 4 Links Gehen
% 5 Oben gehen
% 6 Unten gehen
% 7 Stehen bleiben
initial_population = randi([1 6],243,population_size);
end