function [ G ] = gen_GravityVector(q,Pcii,mcii)
 %% This function is used to calculate gravity-compensation vector of the KUKA iiwa 7 R 800 manipulator
% This function proposes that the robot is mounted upright with the base in the
% horizontal poistion.
 
% Arreguments:
%--------------------
% q: is 1x7 vector, joint nagles vector of the manipulator
% Pcii: is 3X7 matrix while each column represents the local coordinates
% of the center of mass of each link.
% mcii: is (1x7) vector, each element of which specifies a mass of one of
% the links

% Return value:
%--------------------
% G: 7x1 matrix, the torques vector due to gravity-compensation of the KUKA iiwa 7 R 800.

% Copyright: Mohammad SAFEEA, 9th-April-2018

G=zeros(7,1);
g=[0;0;9.81]; % (-) gravity acceleration vector described in base frame of the robot
T=kukaGetKenimaticModelAccelerated(q);

% loop through the joints
for j=1:7
    mj=zeros(3,1);
    pj=T(1:3,4,j);
    % calculate the moment
    for i=7:-1:j
        pci=T(1:3,4,i)+T(1:3,1:3,i)*Pcii(:,i);
        pcij=pci-pj;
        mj=mj+cross(pcij,mcii(i)*g);
    end
    G(j)=T(1:3,3,j)'*mj;
end

end

