function [ torques ] = getJointsMeasuredTorques( t )
%% This function is used to get the joints measured torques, for the KUKA iiwa 7 R 800.

%% Syntax:
%  [ torques ] = getJointsMeasuredTorques( t )

%% About:
% This function is used to get the measured torques of the joints. Those
% measurments are aquired from the torque-sensors incorporated in the
% joints of the robot.  

%% Arreguments:
% t: is the TCP/IP connection
% torques: the measured torques of the joints, it is
% 1x7 cell array (unit Newton.Meter).

% Copyright, Mohammad SAFEEA, 11th of May 2017

    theCommand='Torques_m_J';  
    fprintf(t, theCommand);
    message=fgets(t);
      
    torques=getDoubleFromString(message);
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

