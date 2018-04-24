function [ f ] = getEEF_Force( t )
%% This function is used to get the force acting at the endeffector of the KUKA iiwa 7 R 800.

%% Syntax:
% [ f ] = getEEF_Force( t )

%% About:
% This function is used to get the endeffector force of the KUKA iiwa 7 R 800.
% The force is measured at the media flange of the robot. The components of
% the force vector are described in the base refernce frame of the robot.

%% Arreguments:
% t: is the TCP/IP connection
% f: is 1x3 cell array. Representing the  X,Y and Z components of the force acting on the
% endeffector the forces are measured in (Newton).

% Copyright, Mohammad SAFEEA, 3rd of May 2017

theCommand='Eef_force';
fprintf(t, theCommand);
message=fgets(t);
%disp(message)
[P1,N]=getDoubleFromString(message);

for i=1:3
    f{i}=P1{i};
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

