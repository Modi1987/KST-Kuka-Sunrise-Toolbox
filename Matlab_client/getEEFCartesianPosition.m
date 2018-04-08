function [ Pos ] = getEEFCartesianPosition( t )
%% This function is used to get the endeffector cartizian position of the KUKA iiwa 7 R 800.

%% Syntax:
% [ Pos ] = getEEFCartesianPosition( t )

%% About
% This function is used to get the endeffector Cartesian position of the KUKA iiwa 7 R 800.
% The position is of the media flange of the robot, and it is measured
% relative to the robot base frame.

%% Arreguments:
% t: is the TCP/IP connection
% Pos: is 1x3 cell array. Representing the  X,Y and Z positions of the
% endeffector. The returned values are in (millimeters)

% Copyright, Mohammad SAFEEA, 3rd of May 2017

theCommand='Eef_pos';
fprintf(t, theCommand);
message=fgets(t);
%disp(message)
[P1,N]=getDoubleFromString(message);

for i=1:3
    Pos{i}=P1{i};
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

