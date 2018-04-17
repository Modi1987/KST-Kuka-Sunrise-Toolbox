function [ JPOS ] = sendJointsPositionsGetActualJpos( t_Kuka ,jPos) 
%% Supported by KST 1.2

%% [ JPOS ] = sendJointsPositionsGetActualJpos( t ,jPos) 
% This function is used to send the target positions of the joints for the
% direct servo motion
% this function is for direct-smart-servoing in joint space

%% Arreguments
% jPos: is 7 cells array of doubles
% t: is the TCP/IP connection object

%% Return value
% JPOS: 7x1 cell array of joints positions

% Copy right, Mohammad SAFEEA, 13th-March-2018

theCommand='jpJP_';
for i=1:7
    x=jPos{i};
    theCommand=[theCommand,sprintf('%0.5f',x),'_'];
end

fprintf(t_Kuka, theCommand);
message=fgets(t_Kuka);
[ JPOS,n ]=getDoubleFromString(message);
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