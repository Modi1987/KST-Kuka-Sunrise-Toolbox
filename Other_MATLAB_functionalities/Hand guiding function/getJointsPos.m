function [ jPos ] = getJointsPos( t )
%% This function is used to get the joints positions of the KUKA iiwa 7 R 800.

%% Syntax:
% [ jPos ] =getJointsPos( t )

%% About:
% This function is used to get the joints positions of the KUKA iiwa 7 R 800.

%% Arregumetns:
% t: is the TCP/IP connection
% jPos: is 1x7 cell array of the joints' angles of the robot (unit
% Radians). 

% Copyright, Mohammad SAFEEA, 3rd of May 2017

theCommand='getJointsPositions';
fprintf(t, theCommand);
message=fgets(t);


jPos=getDoubleFromString(message);
end

function jPos=getDoubleFromString(message)
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

