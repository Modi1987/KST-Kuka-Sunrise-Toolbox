%% This function is used for performing point to point motion in joint space, for the KUKA iiwa 7 R 800.
% function [ state ] = movePTPJointSpace( t , jPos, relVel)
% This function is used to move the robot point to point in joint space.
% t: is the TCP/IP connection
% jPos: is the destanation position in joint space, it is 1x7 cell array.
% relVel: is a double, the over-ride relative velocity.
% Copy right, Mohammad SAFEEA, 9th of May 2017



