function [ taw ] = gen_InverseDynamics(q,Pcii,Icii,mcii,dq,d2q)
%% This function is used to calculate the inverse dynamics of the KUKA iiwa 7  R 800
% This function proposes that the robot is mounted with the base in the
% horizontal poistion.

% Arreguments:
%--------------------
% q: is 1x7 vector, joint nagles vector of the manipulator
% dq: is 1x7 vector, joint angular velocity vector 
% d2q: is 1x7 vector, joint angular acceleration vector 
% Pcii: is 3X7 matrix while each column represents the local coordinates
% of the center of mass of each link.
% Icii: is (3x3x7) matrix, each 3x3 matrix of which represnets the
% associated link inertial tensor represented in its local inertial frame
% mcii: is (1x7) vector, each element of which specifies a mass of one of
% the links

% Return value:
%--------------------
% taw: 7x1 vector, the torques on the joints.

% Copyright: Mohammad SAFEEA, 9th-April-2018

[M]=gen_MassMatrix(q,Pcii,Icii,mcii);
[B]=gen_CoriolisMatrix(q,Pcii,Icii,mcii,dq);
[ G ] = gen_GravityVector(q,Pcii,mcii);
% convert angular velocity/acceleration into column vectors
dq=columnVec(dq);
d2q=columnVec(d2q);
taw=M*d2q+B*dq+G;
end

function y=columnVec(x)
if(size(x,2)==1)
    y=x;
else
    y=x';
end
end

