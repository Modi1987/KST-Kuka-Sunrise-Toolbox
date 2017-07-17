%% This function is used to turn on the direct servo function on the robot
% function [ output_args ] = realTime_startDirectServoJoints( t )
% This function is for direct-servoing in joint space, i.e. controlling the
% robot at joint level.
% After starting the direct servo, using this function, you have to send
% the joint target postitions using the function,
% ((kuka8_sendJointsPositions)), refer also to the function
% ((kuka9_stopDirectServoJoints)).
% t: is the TCP/IP connection object
% Copy right, Mohammad SAFEEA, 3rd of May 2017

