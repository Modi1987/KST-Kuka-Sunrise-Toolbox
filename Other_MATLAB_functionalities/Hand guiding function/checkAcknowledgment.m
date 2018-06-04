function ret=checkAcknowledgment(message)
%% This function is used to check for the acknowledgement tocken

% Copyright: Mohammad SAFEEA, 9th-April-2018

ak='done';

if ~exist('message','var')
     ret=false;
    return;   
end

if isempty(message)
    ret=false;
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

