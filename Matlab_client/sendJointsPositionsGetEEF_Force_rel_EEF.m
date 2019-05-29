function  [ EEF_force ] = sendJointsPositionsGetEEF_Force_rel_EEF( t_Kuka ,jPos) 
%% Supported by KST 1.7 LTS and above

%% Syntax
%  [ EEF_force ] = sendJointsPositionsGetEEF_Force_rel_EEF( t ,jPos) 

%% About
% This function is used to send the target positions of the joints for the
% direct servo motion while receiving a feedback about external force at EEF
% described in EEF reference frame.
% This function is for direct/smart servoing in joint space

%% Arguments
% jPos: is 7 cells array of doubles
% t_Kuka: is the TCP/IP connection object

%% Return value:
% EEF_force: is 3 cell array of doubles, the cell elements represent
% the components of the force acting at the EEF (described in EEF frame).

% Copyright, Mohammad SAFEEA, 9th of May 2019

theCommand='DcSeCarEEfFrelEEF_';
for i=1:7
    x=jPos{i};
    theCommand=[theCommand,sprintf('%0.5f',x),'_'];
end

fprintf(t_Kuka, theCommand);
message=fgets(t_Kuka);
[ EEF_force,N ]=getDoubleFromString(message);
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