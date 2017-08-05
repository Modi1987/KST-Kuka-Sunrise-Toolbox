%% This function is used to get the endeffector cartizian position of the KUKA iiwa 7 R 800.

%% Syntax:
% [ Pos ] = getEEFCartesianPosition( t )

%% About
% This function is used to get the endeffector Cartesian position of the KUKA iiwa 7 R 800.
% The position is of the media flange of the robot, and it is measured
% relative to the robot base frame.

%% Arreguments:
% t: is the TCP/IP connection
% Pos: is 1x3 cell array. Representing the  X,Y and Z positions of the
% endeffector. The returned values are in (millimeters)

% Copy right, Mohammad SAFEEA, 3rd of May 2017

