function [ret]=realTime_stopDirectServoCartesian( t )
%% Syntax:
% [ret]=realTime_stopDirectServoCartesian( t_Kuka )


%% About
% This function is used to turn off the direct servo function on the robot
% this function is for direct-servoing in joint space

%% Arreguments
% t_Kuka: is the TCP/IP connection object

% Copy right, Mohammad SAFEEA, 1st of April 2018
pause(1); % introduce some time delay, so the robot finish his motion before turining off the direct servo
theCommand='stopDirectServoJoints';
fprintf(t, theCommand);

message=fgets(t); % Acknowledge  message of direct servo turned off is
[ret]=checkAcknowledgment(message);
if ret==true
        disp('Acknowledge, real time control turned off');   
end

end

