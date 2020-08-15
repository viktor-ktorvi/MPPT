function [output] = QAlgoritam(V, I, epsilon, parameters)
%% Constants
    duty_min = parameters.duty_min;
    duty_max = parameters.duty_max;
    duty_init = parameters.duty_init;
    
    Voc = parameters.Voc;
    Isc = parameters.Isc;

    N = parameters.N; 

    wp = parameters.wp;
    wn = parameters.wn;
    
    alpha = parameters.alpha;
    gamma = parameters.gamma;
    actions = parameters.actions;
    
%% Initializing

    persistent Vold Pold Iold duty_old Q prev_action_index prev_current_index prev_voltage_index prev_deg_index;
    
    if isempty(Vold)
        Vold=0;
        Iold = 0;
        Pold = 0;
        duty_old=duty_init;
        prev_action_index = floor(length(actions)/2) + 1;   % 0 action
        prev_current_index = 1;
        prev_voltage_index = 1;
        prev_deg_index = 1;
        

        % N x I, N x V , 2 x Deg, length(actions) x actions
        Q = zeros(N, N, 2, length(actions)); 
        
    end  
    
    % clamping
    I = clamp(I, 0, Isc);
    V = clamp(V, 0, Voc);
    
    dV = V - Vold;
    dI = I - Iold; 
    P = I*V;
    dP = P - Pold;
    
%% Calculating reward
    if dP < 0
        reward = wn * dP;
    else
        reward = wp * dP;
    end
    
%% Discretizing state
    current_index = round(map(I,0,Isc,1,N));
    voltage_index = round(map(V,0,Voc,1,N));
    
    Deg = abs(deg(I,V,dI,dV));
    if Deg < 5
        Deg_index = 1;
    else
        Deg_index = 2;
    end

%% Q learning
    % update
    Q(prev_current_index, prev_voltage_index, prev_deg_index, prev_action_index) = (1 - alpha) .* Q(prev_current_index, prev_voltage_index, prev_deg_index, prev_action_index) + alpha .* (reward + gamma * max(Q(current_index, voltage_index, Deg_index, :)));
    
    % debug Q table
    Qq = Q;
    
    % best move
    max_val = max(Q(current_index, voltage_index, Deg_index, :));
    
    % if multiple best moves choose random one
    max_indexes = find(Q(current_index, voltage_index, Deg_index, :) == max_val);
    random_index = randi(length(max_indexes));
    
    output = duty_old + actions(max_indexes(random_index));
    
    prev_action_index = max_indexes(random_index);
    
    % exploration
    if rand() < epsilon
        random_index = randi(length(actions));
        output = duty_old + actions(random_index);
        prev_action_index = random_index;
    end
    
%% Clamping 
    output = clamp(output, duty_min, duty_max);
    
%% Saving old values
    prev_current_index = current_index;
    prev_voltage_index = voltage_index;
    prev_deg_index = Deg_index;
    duty_old=output;
    Vold=V;
    Iold = I;
    Pold = P;
end

