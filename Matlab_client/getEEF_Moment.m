%% This function is used to get the endeffector moment of the KUKA iiwa 7 R 800.

%% Syntax:
% [ M ] = getEEF_Moment( t )

%% About:
% This function is used to get the endeffector moment of the KUKA iiwa 7 R 800.
% The moment is measured at the media flange of the robot.

%% Arreguments:
% t: is the TCP/IP connection
% M: is 1x3 cell array. Represinting the  X,Y and Z components of the moment acting on the
% media flange of the robot. The components of the vector of moment are
% described in the robot base frame. The moment is measured in
% (Newton.meter)

% Copy right, Mohammad SAFEEA, 3rd of May 2017
