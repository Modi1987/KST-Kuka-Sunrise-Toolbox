function [C]=gen_CentrifugalMatrix(q,Pcii,Icii,mcii,dq)
%% This function is used to calculate the mass matrix of the KUKA iiwa 7 R 800 manipulator

% Arreguments:
%--------------------
% q: is 1x7 vector, joint nagles vector of the manipulator
% dq: is 1x7 vector, joint angular velocity vector 
% Pcii: is 3X7 matrix while each column represents the local coordinates
% of the center of mass of each link.
% Icii: is (3x3x7) matrix, each 3x3 matrix of which represnets the
% associated link inertial tensor represented in its local inertial frame
% mcii: is (1x7) vector, each element of which specifies a mass of one of
% the links

% Return value:
%--------------------
% C: 7x7 matrix, the centrifugal matrix of the KUKA iiwa 7 R 800.

% Copyright: Mohammad SAFEEA, 9th-April-2018

T=kukaGetKenimaticModelAccelerated(q);
C=GetCentrifugalMatrix_2(T,Pcii,Icii,mcii,dq);