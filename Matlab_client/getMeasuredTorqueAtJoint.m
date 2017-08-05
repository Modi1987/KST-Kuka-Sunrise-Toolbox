%% This function is used to get the measured torque at some joint, for the KUKA iiwa 7 R 800.

%% Syntax:
% [ torque ] = getMeasuredTorqueAtJoint( t,k )

%% About:
% This function is used to torque acting on some joint of the robot due to
% external force/moment acting on the robot.

%% Arreguments:
% t: is the TCP/IP connection
% k: is joint index. A number from 1 to 7.
% torque: is the value of the torque measured at joint (k) due to external
% force/moment acting on the robot. Unit (Newton.meter)

% Copy right, Mohammad SAFEEA, 11th of May 2017
