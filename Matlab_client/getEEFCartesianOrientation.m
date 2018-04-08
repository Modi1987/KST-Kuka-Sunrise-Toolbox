function [ Pos ] = getEEFCartesianOrientation( t )
%% This function is used to get the endeffector cartizian orientation of the KUKA iiwa 7 R 800.

%% Syntax:
% [ Ori ] = getEEFCartisianOrientation( t )

%% About:
% This function is used to get the endeffector cartizian orientation of the KUKA iiwa 7 R 800.
% The orientation is of the media flange of the robot relative to the base
% frame of the robot.

%% Arreguments:
% t: is the TCP/IP connection
% Ori: is 1x3 cell array,  alpha,beta and gama angles of the endeffector,
% the angles are measured in radians.

% Copyright, Mohammad SAFEEA, 3rd of May 2017

theCommand='Eef_pos';
fprintf(t, theCommand);
message=fgets(t);
%disp(message)
[P1,N]=getDoubleFromString(message);
ttt=0;
for i=4:6
    ttt=ttt+1;
    Pos{ttt}=P1{i};
end

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

