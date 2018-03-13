%% Supported by KST 1.2

%% [ JPOS ] = sendJointsPositionsGetActualJpos( t ,jPos) 
% This function is used to send the target positions of the joints for the
% direct servo motion
% this function is for direct-smart-servoing in joint space

%% Arreguments
% jPos: is 7 cells array of doubles
% t: is the TCP/IP connection object

%% Return value
% JPOS: 7x1 cell array of joints positions

% Copy right, Mohammad SAFEEA, 13th-March-2018
