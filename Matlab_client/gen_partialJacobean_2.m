function [J, p0, p1] = gen_partialJacobean_2(a, d, alfa, TefTool, q, first_frame_index, second_frame_index, x)
%% Args:
% q: is (7x1) vector of the joint angles of the manipulatorn
% a, d, alfa: is dh paramters for the manipulator
% first_frame_index, second_frame_index: first and second dh 
                                        frames between which the force is applied
% x: is a scalar from 0 to 1, when zero the force is applied on the frame defined by
%    first_frame_index, when one the force is applied on the frame defined by 
%    second_frame_index

%% Return value:
% J: is the partial jacobean

% Mohammad SAFEEA 3rd Nov 2024

    % input checks
    q=aux_check_cell_convert2mat(q);

    % Initialize transformation matrices
    T = zeros(4,4,7);
    T(:,:,1) = getDHMatrix(alfa{1}, q(1), d{1}, a{1});
    
    for i = 2:7
        T(:,:,i) = T(:,:,i-1) * getDHMatrix(alfa{i}, q(i), d{i}, a{i});
        T(:,:,i) = normalizeColumns(T(:,:,i));
    end
    
    % Extend to end-effector if necessary
    T(:,:,7) = T(:,:,7) * TefTool;
    T(:,:,7) = normalizeColumns(T(:,:,7));
    
    % Position of the point on the link
    p0 = T(1:3, 4, first_frame_index);
    p1 = T(1:3, 4, second_frame_index);
    pos = p0 * (1 - x) + x * p1;
    
    % Partial Jacobian calculation
    J = zeros(6, 7);
    for i = 1:7
        k = T(1:3, 3, i);
        pij = pos - T(1:3, 4, i);
        J(1:3, i) = cross(k, pij);
        J(4:6, i) = k;
    end
end

