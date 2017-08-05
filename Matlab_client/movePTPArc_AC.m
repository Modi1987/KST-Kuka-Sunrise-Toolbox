%% This function is used for moving the endeffector on an arc, for the KUKA iiwa 7 R 800.

%% Syntax
% [ state ] =movePTPArc(t,theta,c,k,vel)

%% About:
% This function is used to move the end-effector on an arc,

%% Arreguments:
% t: is the TCP/IP connection
% theta: is the arc angle, in radians.
% c: the x,y,z coordinates of the center of the circle, it is 1x3 vector.
% k: is the normal vector on the plane of the arc, it is 1x3
% vector.
% vel : is a double, defines the motion velocity mm/sec.

% Copy right, Mohammad SAFEEA, 9th of May 2017
