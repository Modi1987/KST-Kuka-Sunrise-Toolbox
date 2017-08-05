%% This function is used for performing point to point motion
%  in joint space to the home position of the robot, for the KUKA iiwa 7 R 800.

%% Syntax:
% [ state ] = movePTPHomeJointSpace( t , relVel)

%% About:
% This function is used to move the robot to home position, the motion is
% performed in joint space. 

%% Arreguments:
% t: is the TCP/IP connection
% relVel: is a double, the over-ride relative velocity.

% Copy right, Mohammad SAFEEA, 9th of May 2017
