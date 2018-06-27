function [ qs ] = kukaDLSSolver_1( qin, Tt, TefTool,n,lambda,dh )
%% This is a DLS sovler of the inverse kinematics for the KUKA iiwa 7 R 800 robot.

% Inputs:
%-------------
% qin: the initial (current) configuration (joint angles in radians) of
% the robot.
% Tt: is the target transformation matrix position/orientation of the
% TefTool: is the transform matrix from the tool to the flange of the robot
% robot in Cartesian space 
% lambda: is the dls constant
% n: is the number of iterations

% Outputs:
%-------------
% qs: the solution joint angles of the robot.

q=qin;
for i=1:n
    xt=Tt(1:3,4);
    [T,J]=directKinematics_1(q,TefTool,dh);
    x=T(1:3,4);
    % Linear displacment error
    ex=xt-x; % error in positioning
    % Orientation displacment errors
    da=deltAngle(Tt(1:3,1:3),T(1:3,1:3));
    eo=da; % error in orientation
    e=[ex;eo];  % error vector
    
    % update the joint angles
    JJT=J*J'+lambda*eye(6);
    tempVec=JJT\e;
    q=q+J'*tempVec;
    
end % loop n iterations
qs=q;

end



function da=deltAngle(Rt,Rin)
% This function is used to calculate the angular displacments from the
% rotational matrix,

% Inputs:
% Rt:   The target rotational matrix.
% Rin:  The initial rotational matrix.

% Outputs:
% da: angular displacments around the X,Y and Z axes.

    deltaR=Rt-Rin;
    R=Rin;
    vec=[deltaR(:,1);
        deltaR(:,2);
        deltaR(:,3)];
    M=[skew(R(1:3,1));
        skew(R(1:3,2));
        skew(R(1:3,3))];
    da=-M\vec;
end

function X=skew(v)
a=v(1);
b=v(2);
c=v(3);
X=[0   -c   b ;
 c    0  -a ;
-b    a   0  ];
end