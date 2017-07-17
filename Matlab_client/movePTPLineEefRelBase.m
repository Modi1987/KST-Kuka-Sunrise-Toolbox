%% This function is used for moving the endeffector on a line, for the KUKA iiwa 7 R 800.

% function [ state ] = movePTPLineEefRelBase( t , Pos, relVel)

% This function is used to perform linear relative movetion of the end-effector on a line,
% this performs only a linear motion, the orientation of end effector will not be changed.
% t: is the TCP/IP connection
% Pos: is the relative displacement, described in base frame, it is 1x3 cell array.
% relVel: is a double, the over-ride relative velocity.

% refer to example (kuka0_move_lin_relative.m) for more information

% Copy right, Mohammad SAFEEA, 9th of May 2017
