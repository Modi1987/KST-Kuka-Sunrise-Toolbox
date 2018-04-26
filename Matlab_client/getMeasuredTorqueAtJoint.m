function [ torque ] = getMeasuredTorqueAtJoint( t,k )
%% This function is used to get the measured torque at some joint, for the KUKA iiwa 7 R 800.

%% Syntax:
% [ torque ] = getMeasuredTorqueAtJoint( t,k )

%% About:
% This function is used to get torque measurment form the torque sensor of
% some joint of the robot.

%% Arreguments:
% t: is the TCP/IP connection
% k: is joint index. A number from 1 to 7.
% torque: is the value of the torque measured at joint (k) due to external
% force/moment acting on the robot. Unit (Newton.meter)

% Copyright, Mohammad SAFEEA, 11th of May 2017

if(k>7)
    disp('Error KUKA has only 7 joints');
    return;
end

if(k<1)
    return;
end

    theCommand='Torques_m_J';  
    fprintf(t, theCommand);
    message=fgets(t);
      
    torques=getDoubleFromString(message);
    torque=torques{k};
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

