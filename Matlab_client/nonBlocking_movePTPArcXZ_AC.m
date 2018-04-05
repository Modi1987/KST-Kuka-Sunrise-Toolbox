function [ state ] =nonBlocking_movePTPArcXZ_AC(t,theta,c,vel)
%% This non-blocking function is used for moving the endeffector on an arc in the XZ plane, for the KUKA iiwa 7 R 800.

%% Syntax:
% [ state ] =nonBlocking_movePTPArcXZ_AC(t,theta,c,vel)

%% About:
% This function is used to move the end-effector on an arc in the XZ plane,

%% Arreguments:
% t: is the TCP/IP connection
% theta: is the arc angle, in radians
% c: the XZ coordinates of the center of the circle, it is 1x2 vector.
% vel : is a double, defines the motion velocity mm/sec.

% Copy right, Mohammad SAFEEA, 9th of May 2017

% check also the function: nonBlocking_isGoalReached()

    k=[0;1;0];
    pos=getEEFPos( t );
    c=colVec(c);
    c1=[c(1);pos{2};c(2)];
    state=nonBlocking_movePTPArc_AC(t,theta,c1,k,vel);

end

function [ y ] = colVec( v)
% Convert a vector to a column vector:
    if(size(v,2)==1)
        y=v;
    else
        y=v';
    end
end