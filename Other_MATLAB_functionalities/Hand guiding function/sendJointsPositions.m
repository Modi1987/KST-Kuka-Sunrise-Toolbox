function [ ret ] = sendJointsPositions( t_Kuka ,jPos)
%% Syntax:
% [ ret ] = sendJointsPositions( t_Kuka ,jPos)

%% About
% This function is used to send the target positions of the joints for the
% direct servo motion.

%% Arreguments:
% jPos: is 7 cells array of doubles, representing joints angles in (rads)
% t_Kuka: is the TCP/IP connection object

%% Return value:
% ret: 'true' if the joints positions message has been received and processed
% successfully by the server, otherwise 'false' is returned

% Copy right, Mohammad SAFEEA, 3rd of May 2017

theCommand='jp_';
for i=1:7
    x=jPos{i};
    theCommand=[theCommand,sprintf('%0.5f',x),'_'];
end

fprintf(t_Kuka, theCommand);
message=fgets(t_Kuka);
ret=checkAcknowledgment(message);
end

