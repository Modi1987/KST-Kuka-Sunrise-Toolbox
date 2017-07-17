%% This function is used for performing point to point motion in Cartizian space, for the KUKA iiwa 7 R 800.

% function [ state ] = movePTPLineEEF( t , Pos, vel)

% This function is used to move the end effector in a line.
% t: is the TCP/IP connection

% Pos: is the destanation position of end effector, cartizian space, it is 1x6 cell array.
% The first three cells of Pos prepresent the X,Y and Z coordinates of end
% effector

% The remaining three cells of Pos, are the rotation angle of the end
% effector, alpha, beta and gamma,

% When called, the function causes the end-effector to move on a line,
% the robot interpolates the end-effector orientation while performing the line motion.

% vel: is a double, the linear motion velocity, mm/sec.

% Copy right, Mohammad SAFEEA, 9th of May 2017



