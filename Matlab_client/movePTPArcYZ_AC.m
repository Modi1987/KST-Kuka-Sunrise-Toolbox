%% This function is used for moving the endeffector on an arc in the YZ plane, for the KUKA iiwa 7 R 800.
% function [ state ] =movePTPArcYZ_AC(t,theta,c,vel)

% This function is used to move the end-effector on an arc in the YZ plane,

% t: is the TCP/IP connection
% theta: is the arc angle, in radians
% c: the YZ coordinates of the center of the circle, it is 1x2 vector.
% vel : is a double, defines the motion velocity mm/sec.

% Copy right, Mohammad SAFEEA, 9th of May 2017
