clc;
close all;
clear variables;
%%
sim_file_name = 'mppt';
open_system(sim_file_name);

%%
sim(sim_file_name)
