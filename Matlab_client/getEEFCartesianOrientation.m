%% This function is used to get the endeffector cartizian orientation of the KUKA iiwa 7 R 800.

%% Syntax:
% [ Ori ] = getEEFCartizianOrientation( t )

%% About:
% This function is used to get the endeffector cartizian orientation of the KUKA iiwa 7 R 800.
% The orientation is of the media flange of the robot relative to the base
% frame of the robot.

%% Arreguments:
% t: is the TCP/IP connection
% Ori: is 1x3 cell array,  alpha,beta and gama angles of the endeffector,
% the angles are measured in radians.

% Copy right, Mohammad SAFEEA, 3rd of May 2017
