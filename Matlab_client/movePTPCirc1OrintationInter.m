%% This function is used for moving the endeffector on a circle, for the KUKA iiwa 7 R 800.

%% Syntax:
% [ state ] = movePTPCirc1OrintationInter( t , f1,f2, vel)

%% About:
% This function is used to move the end-effector on a circle,

%% Arreguments:
% t: is the TCP/IP connection
% f1: intermediate frame, to specify a point from the circle, it is 1x6 cell array.
% f2: final frame, to specify the end point of the circle, it is 1x6 cell array.

% the first three elements of f1 and f2 cell arrays, is the X,Y
% and Z position of the frame (in millimeters)

% the second three elements of f1 and f2 cell arrays, is the
% alpha,beta and gamma rotaion angles (rads) that represent the frame
% orientation

% vel: is the motion linear velocity, mm/sec.

% Copy right, Mohammad SAFEEA, 9th of May 2017
