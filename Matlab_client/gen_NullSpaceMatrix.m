function [ N ] = gen_NullSpaceMatrix(q)
 % About
 %-----------
 % This function is used for calculating the Null space projection matrix
 % of the KUKA iiwa 7 R 800 manipulator 
 
% Arreguments:
%--------------------
% q: is 1x7 vector, joint nagles vector of the manipulator

% Return value:
%--------------------
% N: 7x7 matrix, null space projection matrix for the KUKA iiwa 7 R 800.

% Copyright: Mohammad SAFEEA, 17th-April-2018

TefTool=eye(4);
[eef_transform,J]=gen_DirectKinematics(q,TefTool);
N=eye(7)-J'*inv(J*J')*J;

end

