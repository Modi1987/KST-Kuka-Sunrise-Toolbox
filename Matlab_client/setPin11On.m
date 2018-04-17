function [ ret ] = setPin11On( t_Kuka )
%% About:
% This function is used to set on the Pin 11 on the KUKA iiwa 7 R 800.

%% Syntax:
% [ ret ] = setPin11On( t_Kuka )

%% Arreguments:
% t_Kuka: is the TCP/IP connection

%% Return value:
% ret: a boolean variable
% true: if the message is treated successfully
% false: if an error has happened

% Copy right, Mohammad SAFEEA, 3rd of May 2017

theCommand='pin11on';
fprintf(t_Kuka, theCommand);
message=fgets(t_Kuka);
ret=checkAcknowledgment(message);
end
