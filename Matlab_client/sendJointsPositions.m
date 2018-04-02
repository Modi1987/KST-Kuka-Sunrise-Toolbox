function [ output_args ] = sendJointsPositions( t ,jPos)
%% This function is used to send the target positions of the joints for the
% direct servo motion
% function [ output_args ] = sendJointsPositions( t ,jPos)
% this function is for direct-servoing in joint space
% jPos: is 7 cells array of doubles
% t: is the TCP/IP connection object
% Copy right, Mohammad SAFEEA, 3rd of May 2017

theCommand='jp_';
for i=1:7
    x=jPos{i};
    theCommand=[theCommand,sprintf('%0.5f',x),'_'];
end

fprintf(t, theCommand);
message=fgets(t);
end

