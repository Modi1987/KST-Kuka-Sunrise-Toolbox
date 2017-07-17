%% This function is used for moving the endeffector on a circle, for the KUKA iiwa 7 R 800.

% function [ state ] = movePTPCirc1OrintationInter( t , f1,f2, relVel)

% This function is used to move the end-effector on a circle,

% t: is the TCP/IP connection
% f1: intermediate frame, to specify a point from the circle, it is 1x6 cell array.
% f2: final frame, to specify the end point of the circle, it is 1x6 cell array.

% the first three elements of cell array represent the X,Y and Z position of
% the frame

% the second three elements of cell array represent the alpha,beta
% and gamma rotaion angles (rads) that represent the frame orientation

% relVel: is a double, the over-ride relative velocity.
% Copy right, Mohammad SAFEEA, 9th of May 2017
