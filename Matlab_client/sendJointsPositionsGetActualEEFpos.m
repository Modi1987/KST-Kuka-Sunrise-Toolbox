%% Supported by KST 1.2

%%  [ EEF_POS ] = sendJointsPositionsGetActualEEFpos( t ,jPos) 
% This function is used to send the target positions of the joints for the
% direct servo motion
% this function is for direct-smart-servoing in joint space

%% Arreguments
% jPos: is 7 cells array of doubles
% t: is the TCP/IP connection object


%% Return value
% EEF_POS: 6x1 cell array of EEF position

% Copy right, Mohammad SAFEEA, 13th-March-2018
