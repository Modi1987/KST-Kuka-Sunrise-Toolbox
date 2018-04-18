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
message=fgets(t_Kuka);
[ExTorque,k]=getDoubleFromString(message);
end

function [jPos,j]=getDoubleFromString(message)
n=max(max(size(message)));
j=0;
numString=[];
for i=1:n
    if message(i)=='_'
        j=j+1;
        jPos{j}=str2num(numString);
        numString=[];
    else
        numString=[numString,message(i)];
    end
end
end
