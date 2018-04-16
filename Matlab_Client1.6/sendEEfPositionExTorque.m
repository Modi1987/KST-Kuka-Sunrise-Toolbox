function [ ExTorque ] = sendEEfPositionExTorque( t_Kuka ,EEEFpos)
%% Syntax
% [ ExTorque ] = sendEEfPositionExTorque( t_Kuka ,EEEFpos)

%% About:
% This function is used to send the target positions of the end-effector for the
% direct servo motion and receives the torques due to external forces from the controller

%% Arreguamnets
% t_Kuka: is the TCP/IP connection object
% EEEFpos: is 6 cells array of doubles

%% Returned value
% ExTorque: is 7 cell array of doubles

% Copyright, Mohammad SAFEEA, 1st of April 2018

theCommand='DcSeCarExT_';

for i=1:6
    x=EEEFpos{i};
    theCommand=[theCommand,sprintf('%0.5f',x),'_'];
end
% send the message through network
fprintf(t_Kuka, theCommand);
message=fgets(t);
[ExTorque,k]=
end

