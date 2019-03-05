function [ ret ] = realTime_stopImpedanceJoints( t )
%% About
% This function is used to turn off the realtime control with impedance
% function on the robot

%% Syntax:
% realTime_stopImpedanceJoints(t)

%% Arreguments
% t: is the TCP/IP connection object


% Copy right, Mohammad SAFEEA, 8th of Nov 2017,
% Updated by Mohammad SAFEEA, 01st-March-2019

delay(0.5); % introduce some time delay, so the robot finish his motion before turining off the direct servo
theCommand='stopDirectServoJoints';
fprintf(t, theCommand);

message=fgets(t) % Acknowledge  message of direct servo turned off is
[ret]=checkAcknowledgment(message);
if ret==true
        disp('Acknowledge, real time control turned off'); 
end

%% Following code is added on 1st-April-2019
% It is a rapid fix to a bug where the impedance mode is not turned off
% properly
% The bug was descovered by Steve Kapalan NCSU on 29th-Feb-2019.
if ret==false
    disp('Error could not turn off impedance mode correctly');
    return;
end

while(ret)
% theCommand='Eef_pos';
% fprintf(t, theCommand);
message=fgets(t) % If the impedance mode is turned off properly returned value will be empty, 
[ret]=checkAcknowledgment(message);
% On the other hand, if the impedance mode was not turned off properly the return value will be "done", afterwards the robot goes back to normal operation mode.
% The bug was fixed by diagnosis, the real issue causing it is not known yet.
end
ret=true;
end

