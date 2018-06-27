function [ ret ] = realTime_startDirectServoJoints( t )
%% Syntax:
% realTime_startDirectServoJoints( t_Kuka )

%% Arregument
% t: is the TCP/IP connection object

%% About:
% This function is used to turn on the direct servo function on the robot
% This function is for direct-servoing in joint space, i.e. controlling the
% robot at joints level.
% After starting the direct servo, using this function, you have to send
% the joints positions target postitions using the function,
% ((sendJointsPositions)), refer also to the function
% ((stopDirectServoJoints)).

theCommand='startDirectServoJoints';
fprintf(t, theCommand);
message=fgets(t);

[ret]=checkAcknowledgment(message);

if ret==true
        disp('Acknowledge, realtime control turned on');  
end
delay(0.5); % introduce some time delay, so the robot turns on the direct servo before starting the motion
end

