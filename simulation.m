clc;
close all;
clear variables;
%% Init
sim_file_name = 'mppt';
open_system(sim_file_name);

%% Parameters 
% umesto ovoga mozda proslediti function handle
parameters.mppt_method = 0; % 1 za IC , 0 za Q, ne da string da prosledim
parameters.sim_duration = 0.2;
parameters.transport_delay = 0;

parameters.duty_min=0.28; % za oko 0.27 duty je Vin vece od Voc za 6V Vout, jer Vout = D*Vin;
parameters.duty_max=1.0;
parameters.duty_init=0.5;

parameters.Voc = 21.9;
parameters.Isc = 1.84;

parameters.N = 20;     % number of points for discretization of I and V

parameters.min_step = 0.0025;    % dsp limit
parameters.big_step = 3*parameters.min_step;

parameters.wp = 1;    % positive reward coef
parameters.wn = 4;    % negative reward coef

parameters.alpha = 0.5;    % learning rate
parameters.gamma = 0.9;    % discount facor

parameters.actions = [ -parameters.min_step, 0, parameters.min_step];    % actions

%% Simulation
simout = sim(sim_file_name);

%% Create folder
initial_path = "data/";
folder_name = "sim at ";
folder_path = create_folder_at_time(initial_path, folder_name);

%% Save figures
time_series = simout.simout;

fig = figure();
plot(time_series)

figure_name = "my_figure";
figure_extension = ".jpg";
saveas(fig,folder_path + figure_name + figure_extension);

%% Excel

excel_file_name = "parameters table";
excel_extension = ".xlsx";
writetable(struct2table(parameters), folder_path + excel_file_name + excel_extension);

complete_path = "C:\Users\HP\Desktop\Faks\Matlab\Energetika\MPPT_avgust2020\";
modify_excel_columns(complete_path + folder_path + excel_file_name + excel_extension);

%% Save signals
time_series_name = "output";
time_series_extension = ".mat";
save(folder_path + time_series_name + time_series_extension,'time_series')


