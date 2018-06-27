function [ret]=realTime_startDirectServoCartesian( t_Kuka )
%% Syntax:
% realTime_startDirectServoCartesian( t_Kuka )

%% About:
% This function is used to turn on the direct servo function on the robot
% This function is for direct-servoing in Cartesian space, i.e. controlling the
% robot at EEF level.
% After starting the direct servo, using this function, you have to send
% the EEF target postitions using the function,
% ((sendEEfPosition)), refer also to the function
% ((realTime_stopDirectServoCartesian)).

%% Arreguments
% t_Kuka: is the TCP/IP connection object

% Copy right, Mohammad SAFEEA, 1st of April 2018

theCommand='stDcEEf_';
fprintf(t_Kuka, theCommand);
message=fgets(t_Kuka);

[ret]=checkAcknowledgment(message);
if ret==true
    disp('Acknowledge, realtime control turned on');
end

delay(0.5); % introduce some time delay, so the robot turns on the direct servo before starting the motion
end

