function sendJointsPositionsf( t_Kuka ,jPos)
%% Syntax:
% sendJointsPositionsf( t_Kuka ,jPos)

%% About
% This function is used to send the target positions of the joints for the
% direct servo motion
% this function is for direct-servoing in joint space

%% Arreguments
% jPos: is 7 cells array of doubles
% t: is the TCP/IP connection object


% Copy right, Mohammad SAFEEA, 3rd of May 2017

theCommand='jf_';
for i=1:7
    x=jPos{i};
    theCommand=[theCommand,sprintf('%0.5f',x),'_'];
end
fprintf(t_Kuka, theCommand);
end

