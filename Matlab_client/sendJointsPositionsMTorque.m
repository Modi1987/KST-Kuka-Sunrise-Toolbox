function  [ torques ] = sendJointsPositionsMTorque( t_Kuka ,jPos) 
%% Supported by KST 1.2 and above

%% Syntax
% [ torques ] = sendJointsPositionsMTorque( t ,jPos) 

%% About
% This function is used to send the target positions of the joints for the
% direct servo motion
% this function is for direct-servoing in joint space

%% Arreguments
% t_Kuka: is the TCP/IP connection object
% jPos: is 7 cells array of doubles

%% Return value
% torques: 7x1 cell array of joints torques, (raw data) as measured by the
% torque sensors from the joints

% Copy right, Mohammad SAFEEA, 13th-march-2018

theCommand='jpMT_';
for i=1:7
    x=jPos{i};
    theCommand=[theCommand,sprintf('%0.5f',x),'_'];
end

fprintf(t_Kuka, theCommand);
message=fgets(t_Kuka);
[ torques,n ]=getDoubleFromString(message);
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