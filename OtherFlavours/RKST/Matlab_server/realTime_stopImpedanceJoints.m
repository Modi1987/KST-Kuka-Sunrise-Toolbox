function [ ret ] = realTime_stopImpedanceJoints( t )
%% About
% This function is used to turn off the realtime control with impedance
% function on the robot

%% Syntax:
% realTime_stopImpedanceJoints(t)

%% Arreguments
% t: is the TCP/IP connection object


% Copy right, Mohammad SAFEEA, 8th of Nov 2017

delay(0.5); % introduce some time delay, so the robot finish his motion before turining off the direct servo
theCommand='stopDirectServoJoints';
fprintf(t, theCommand);

message=fgets(t); % Acknowledge  message of direct servo turned off is
[ret]=checkAcknowledgment(message);
if ret==true
        disp('Acknowledge, real time control turned off'); 
end

end

