%% This function is used for moving the endeffector on a line, for the KUKA iiwa 7 R 800.

%% Syntax:
% [ state ] = movePTPLineEefRelBase( t , Pos, vel)

%% About:
% This function is used to perform linear relative movetion of the end-effector on a line,
% this performs only a linear motion, the orientation of end effector will not be changed.
% For more information refer to the example file (kuka0_move_lin_relative.m).

%% Arreguments:
% t: is the TCP/IP connection
% Pos: is the relative displacement, described in base frame, it is 1x3
% cell array, (unit millimeters)
% vel: is a double, represents the linear velocity of the motion (unit
% mm/sec). 

% Copy right, Mohammad SAFEEA, 9th of May 2017
