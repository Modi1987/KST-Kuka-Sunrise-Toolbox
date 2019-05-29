function [ EEF_force ] = sendEEfPositionGetEEF_Force_rel_EEF( t_Kuka ,EEEFpos)
%% Supported by KST 1.7 LTS and above

%% Syntax
% [ EEF_force ] = sendEEfPositionGetEEF_Force_rel_EEF( t_Kuka ,EEEFpos)

%% About:
% This function is used to send the target positions of the end-effector for the
% direct servo motion and receives the external force acting at the EEF
% from the robot controller.

%% Arguments
% t_Kuka: is the TCP/IP connection object
% EEFpos: is 6 cell array of doubles, first three elements represent the
% x,y and z coordinates of EEF described in base frame of the robot, second
% three elements represent the orientation of the EEF described in fixed ZYX
% rotation angles with respect to robots base frame.

%% Return value:
% EEF_force: is 3 cell array of doubles, the cell elements represent
% the components of the force acting at the EEF (described in EEF frame).

% Copyright, Mohammad SAFEEA, 9th of May 2019

theCommand='jpEEfFrelEEF_';

for i=1:6
    x=EEEFpos{i};
    theCommand=[theCommand,sprintf('%0.5f',x),'_'];
end
% send the message through network
fprintf(t_Kuka, theCommand);
message=fgets(t_Kuka);
[EEF_force,N]=getDoubleFromString(message);
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
