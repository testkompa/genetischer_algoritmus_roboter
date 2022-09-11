clear all
clear figures
clc

% Laden der zu visualisierenden Datei
load('robot_ga_daten_extern.mat');

% Auswahl der zu visualisierenden Generation
gen = 2;

% Visulaisieren einer Runde
visualisieren_robot(B_final(:,:,:,gen),x_final(:,gen),y_final(:,gen),do_final(:,gen),points_final(:,gen))
