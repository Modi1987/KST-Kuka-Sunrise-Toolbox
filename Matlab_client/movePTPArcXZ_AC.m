%% This function is used for moving the endeffector on an arc in the XZ plane, for the KUKA iiwa 7 R 800.

%% Syntax:
% [ state ] =movePTPArcXZ_AC(t,theta,c,vel)

%% About:
% This function is used to move the end-effector on an arc in the XZ plane,

%% Arreguments:
% t: is the TCP/IP connection
% theta: is the arc angle, in radians
% c: the XZ coordinates of the center of the circle, it is 1x2 vector.
% vel : is a double, defines the motion velocity mm/sec.

% Copy right, Mohammad SAFEEA, 9th of May 2017
