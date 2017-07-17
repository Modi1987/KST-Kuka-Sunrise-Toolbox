%% This function is used for performing a direct servo motion in joint space, for the KUKA iiwa 7 R 800.
% function [ state ] = realTime_moveOnPathInJointSpace( t , trajectory,delayTime)
% This function is used to move the robot on a trajectory in joint space.
% t: is the TCP/IP connection
% trajectory: is 7xn array, each column of the array is the joints angles
% of the robot.
% delayTime: is the delay time between two joint instructions sent to the robot.
% Copy right, Mohammad SAFEEA, 9th of May 2017


