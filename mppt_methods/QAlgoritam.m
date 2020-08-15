function [output, Qq] = QAlgoritam(V, I, epsilon)
%% Constants
    duty_init=0.3;
    duty_min=0.0;
    duty_max=1.0;
    
    Voc = 21.9;
    Isc = 1.84;

    N = 10; % broj tacaka za diskretizsaciju stanja
    % mozda je malo pa ne hvata sistem lepo
    % mozda je mnogo pa ne uspeva da istrenira

    % dsp limit
    min_step = 0.0025;
    big_step = 3*min_step;

    % positive reward coef
    wp = 1;
    % negative reward coef
    wn = 4;
    
    % learning rate
    alpha = 0.1;
    % discount facor
    gamma = 0.9;

    % actions
    actions = [ -min_step, 0, min_step];
%% Initializing

    persistent Vold Iold duty_old Q prev_action_index prev_current_index prev_voltage_index prev_deg_index;
    
    if isempty(Vold)
        Vold=0;
        Iold = 0;
        duty_old=duty_init;
        prev_action_index = floor(length(actions)/2) + 1;
        prev_current_index = 1;
        prev_voltage_index = 1;
        prev_deg_index = 1;
        

        % N x I, N x V , 2 x Deg, length(actions) x actions
        Q = zeros(N, N, 2, length(actions)); 
    end  
    
    if I < 0
        I = 0;
    end
    
    if I > Isc
        I = Isc;
    end
    
    if V < 0
        V = 0;
    end
    
    if V > Voc
        V = Voc;
    end
    
    dV = V - Vold;
    dI = I - Iold; 
    dP = dI * dV;
    
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
    Qq = Q;
    % best move
    [~, argmax] = max(Q(current_index, voltage_index, Deg_index, :));
    output = duty_old + actions(argmax);
    
    % exploration
    if rand() < epsilon
        random_index = rand()*(length(actions) - 1) + 1;
        output = duty_old + actions(round(random_index));
    end
    
%% Clamping 
    if output >duty_max
     output=duty_max;
    else
        if output<duty_min
            output=duty_min;
        end
    end
    
    
%% Saving old values
    prev_action_index = argmax;
    prev_current_index = current_index;
    prev_voltage_index = voltage_index;
    prev_deg_index = Deg_index;
    duty_old=output;
    Vold=V;
    Iold = I;
end

