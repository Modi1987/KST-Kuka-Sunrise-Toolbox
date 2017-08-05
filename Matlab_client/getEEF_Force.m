%% This function is used to get the force acting at the endeffector of the KUKA iiwa 7 R 800.

%% Syntax:
% [ f ] = getEEF_Force( t )

%% About:
% This function is used to get the endeffector force of the KUKA iiwa 7 R 800.
% The force is measured at the media flange of the robot. The components of
% the force vector are described in the base refernce frame of the robot.

%% Arreguments:
% t: is the TCP/IP connection
% f: is 1x3 cell array. Representing the  X,Y and Z components of the force acting on the
% endeffector the forces are measured in (Newton).

% Copy right, Mohammad SAFEEA, 3rd of May 2017

