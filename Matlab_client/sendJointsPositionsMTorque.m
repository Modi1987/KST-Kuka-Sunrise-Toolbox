%% Supported by KST 1.2

%% [ torques ] = sendJointsPositionsMTorque( t ,jPos) 
% This function is used to send the target positions of the joints for the
% direct servo motion
% this function is for direct-servoing in joint space

%% Arreguments
% jPos: is 7 cells array of doubles
% t: is the TCP/IP connection object

%% Return value
% torques: 7x1 cell array of joints torques, (raw data) as measured by the
% torque sensors from the joints

% Copy right, Mohammad SAFEEA, 13th-march-2018
