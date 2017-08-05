%% This function is used to get the endeffector position and orientation of the KUKA iiwa 7 R 800.

%% Syntax:
% [ Pos ] = getEEFPos( t )

%% About:
% This function is used to get the endeffector positions/orientation of the
% KUKA iiwa 7 R 800. The position and orientation is that of the media
% flange of the robot.

%% Arreguments:
% t: is the TCP/IP connection
% Pos: is 1x6 cell array, of the linear and angular positions of the end
% effector, the first three elements are the X,Y and Z positions (unit mm) and the
% last three elements are the alpha, beta and gama angels of the end
% effector (unit radians). The position/orientation of the
% media flange are in realtion to the base reference frame of the robot.

% Copy right, Mohammad SAFEEA, 3rd of May 2017
