function [ret]=checkAcknowledgment(message)
%% This function is used to check for the acknowledgement tocken

% Copyright: Mohammad SAFEEA, 9th-April-2018

ak='done';
nak='nak';

if ~exist('message','var')
     ret=false;
    return;   
end

if isempty(message)
    ret=false;
    return;
end

temp=message(1:3);
if(strcmp(temp,nak))
    disp('Error, robot can not perform the operation')
    disp('Check the touchpad of the robot for more info')
    ret=true;
    return;
end

for i=1:4
if(message(i)==ak(i))
else
    ret=false;
    return
end
    ret=true;
    return
end

