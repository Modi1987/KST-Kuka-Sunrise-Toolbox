function [the_position, the_force] = gen_estimateTouchForcePosition_1(a, d, alfa, TefTool, q, taw)
%% Args:
% a, d, alfa: is dh paramters for the manipulator
% TefTool: eef_tool tranform to flange
% q: is (7x1) vector of the joint angles of the manipulatorn
% taw: is (7x1) external torques vector as measured from the robot controller

%% Return value:
% J: is the partial jacobean

% Mohammad SAFEEA 3rd Nov 2024

    % Initialize indices and placeholders for best solution
    array_first_dh_frame_index  = [2, 4, 6];
    array_second_dh_frame_index = [4, 6, 7];
    minimum_cost = inf;
    the_position = [];
    the_force = [];

    q = aux_ensure_a_column_vector(q);
    taw = aux_ensure_a_column_vector(taw);

    for i = 1:3
        first_frame_index  = array_first_dh_frame_index(i);
        second_frame_index = array_second_dh_frame_index(i);
        
        % Define cost function for optimization
        fun = @(var_force_x) costFunction(a, d, alfa, TefTool, q, first_frame_index, second_frame_index, taw, var_force_x);
        % touch force component from -50 N to 50 N
        lb = -50 * ones(4, 1);
        ub = 50 * ones(4, 1);
        lb(4)=0; ub(4)=1; % x from zero to one
        seed = zeros(4, 1);
        
        % Run optimization
        solution = fmincon(fun, seed, [], [], [], [], lb, ub, []);
        solution = aux_to_column_vector(solution);
        
        % Extract force and position scalar x from the solution
        force = solution(1:3);
        x = solution(4);

        % Calculate the cost for the current solution
        the_cost = costFunction(a, d, alfa, TefTool, q, first_frame_index, second_frame_index, taw, solution);
        
        % Check if this is the best solution so far
        if the_cost < minimum_cost
            % Update minimum cost and the corresponding best solution
            minimum_cost = the_cost;
            [~, p0, p1] = gen_partialJacobean_2(a, d, alfa, TefTool, q, first_frame_index, second_frame_index, x);
            the_position = p0 * (1 - x) + p1 * x;
            the_force = force;
        end
    end
end

function cost = costFunction(a, d, alfa, TefTool, q, first_frame_index, second_frame_index, taw, var_force_x)    
    % Extract force and x from optimization variables
    force = var_force_x(1:3);
    x = var_force_x(4);
    
    % Calculate partial Jacobian
    [J, ~, ~] = gen_partialJacobean_2(a, d, alfa, TefTool, q, first_frame_index, second_frame_index, x);
    Jpartial = J(1:3, 1:first_frame_index);
    
    % Compute error and cost
    e = taw - Jpartial' * force;
    cost = 0.5 * e' * e;
end
