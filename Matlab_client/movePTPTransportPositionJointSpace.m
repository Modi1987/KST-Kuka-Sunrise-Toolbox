%% This function is used for performing point to point motion in joint space 
% to the transport position of the robot, for the KUKA iiwa 7 R 800

%% Syntax:
% [ state ] = movePTPTransportPositionJointSpace( t , relVel)

%% About:
% This function is used to move the robot point to point in joint space.

%% Arreguments:
% t: is the TCP/IP connection
% relVel: is a double, from zero to one, specifies the over-ride relative
% velocity. 

% Copy right, Mohammad SAFEEA, 9th of May 2017
