clc;
close all;
clear variables;
%% Init
sim_file_name = 'mppt';
open_system(sim_file_name);

%% Parameters
parameters.mppt_method = 0; % 1 za IC , 0 za Q, ne da string da prosledim

parameters.sim_duration = 0.5; % sec

parameters.transport_delay = 50e-6;
parameters.regulation_freq = 1e4;
parameters.sampling_time = 1 / parameters.regulation_freq;

parameters.duty_min= 0.31; % za oko 0.27 duty je Vin vece od Voc za 6V Vout, jer Vout = D*Vin; Na <0.3 je negativna snaga
parameters.duty_max= 1.0;
parameters.duty_init= 0.35; % can be random

parameters.Voc = 21.9; % V
parameters.Isc = 1.84; % A

parameters.N = 100;     % number of points for discretization of I and V
 
parameters.min_step = 0.0025;    % dsp limit
parameters.big_step = 3*parameters.min_step;

parameters.wp = 1;    % positive reward coef
parameters.wn = 4;    % negative reward coef

parameters.alpha = 0.05;    % learning rate
parameters.gamma = 0.9;    % discount facor
parameters.explore_number = 25;
parameters.epsilon = 0.0;

parameters.actions = [ -parameters.min_step, 0, parameters.min_step];    % actions

time_vals = [0.0 0.5 0.5 1.0 1.0 1.5 1.5 2.0 2.0 2.5 2.5 3.0]/4; % sec
ir_vals   = [500 500 1e3 1e3 300 300 400 400 1e3 1e3 500 500]; % W/m^2
power = [15.19 15.19 29.92 29.92 9.07 9.07 12.14 12.14 29.92 29.92 15.19 15.19]; % W

%% Simulation
out = sim(sim_file_name);

%% Create folder

% this if statement has not been tested, i literaly wrote it up 
% in notepad because i was lazy, if it doesnt work comment it out % but make sure you have a folder named data
if ~exist('data', 'dir')
       mkdir('data')
    end
initial_path = "data/";

if parameters.mppt_method == 0
    method = "Q learning";
elseif parameters.mppt_method == 1
    method = "IC";
else
    method = "no method";
end
folder_name = method + " " + parameters.transport_delay + " sec kasnjenja";

if folder_name == ""
    folder_name = "sim at ";
    folder_path = create_folder_at_time(initial_path, folder_name);
else
    folder_path = initial_path + folder_name;
    mkdir(folder_path);
    folder_path = folder_path + "/";
end

%% Ploting 
img_extension = ".jpg";

var_names = out.who;
for i = 1:length(var_names)
    var_name = var_names{i};
    fig = figure();
    plot(out.get(var_name));
    title(var_name)
    saveas(fig, folder_path + var_name + img_extension);
end

fig = figure();
plot(out.panel_theoretical_power1);
hold on;
plot(out.panel_power1);
title("Power comparison")
saveas(fig, folder_path + "Power comparison" + img_extension);
close all;

%% Excel

excel_file_name = "parameters table";
excel_extension = ".xlsx";
writetable(struct2table(parameters), folder_path + excel_file_name + excel_extension);

complete_path = pwd + "/";
modify_excel_columns(complete_path + folder_path + excel_file_name + excel_extension);

