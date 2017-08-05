%% This function is used to get the joints measured torques, for the KUKA iiwa 7 R 800.

%% Syntax:
%  [ torques ] = getJointsMeasuredTorques( t )

%% About:
% This function is used to get the measured torques of the joints. Those
% measurments are aquired from the torque-sensors incorporated in the
% joints of the robot.  

%% Arreguments:
% t: is the TCP/IP connection
% torques: the measured torques of the joints, it is
% 1x7 cell array (unit Newton.Meter).

% Copy right, Mohammad SAFEEA, 11th of May 2017

