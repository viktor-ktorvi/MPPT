clc;
close all;
clear variables;
%% Init
sim_file_name = 'mppt';
open_system(sim_file_name);

%% Parameters 
    parameters.duty_min=0.28; % za oko 0.27 duty je Vin vece od Voc za 6V Vout, jer Vout = D*Vin;
    parameters.duty_max=1.0;
    parameters.duty_init=0.5;
    
    parameters.Voc = 21.9;
    parameters.Isc = 1.84;
    
    parameters.N = 10;     % broj tacaka za diskretizsaciju stanja

    parameters.min_step = 0.0025;    % dsp limit
    parameters.big_step = 3*parameters.min_step;

    parameters.wp = 1;    % positive reward coef
    parameters.wn = 4;    % negative reward coef
    
    parameters.alpha = 0.5;    % learning rate
    parameters.gamma = 0.9;    % discount facor

    parameters.actions = [ -parameters.big_step, 0, parameters.big_step];    % actions

%% Simulation
sim(sim_file_name)
