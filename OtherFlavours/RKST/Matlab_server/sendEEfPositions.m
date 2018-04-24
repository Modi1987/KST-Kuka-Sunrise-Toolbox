function [ output_args ] = sendEEfPositions( t ,jPos)
%% This function is used internally by other functions

% function [ output_args ] = sendEEfPositions( t ,Pos)
% this function is for direct-servoing in cartizian space
% Pos: is 6 cells array of doubles
% t: is the TCP/IP connection object
% Copy right, Mohammad SAFEEA, 3rd of May 2017

theCommand='cArtixanPosition_';
%jPos;
for i=1:6
    x=jPos{i};
    theCommand=[theCommand,num2str(x),'_'];
end

fprintf(t, theCommand);
message=fgets(t);
end

