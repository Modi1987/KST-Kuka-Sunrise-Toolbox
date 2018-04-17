function [ ret ] = sendJointsVelocities( t_Kuka ,jvel)
%% Applicable to KST 1.6

%% Syntax:
% [ ret ] = sendJointsVelocities( t_Kuka ,jvel)

%% About
% This function is used to send the target velocities of the joints for the
% direct servo motion.

%% Arreguments:
% jvel: is 7 cells array of doubles, representing joints velocities in (rad/sec)
% t_Kuka: is the TCP/IP connection object

%% Return value:
% ret: 'true' if the joints positions message has been received and processed
% successfully by the server, otherwise 'false' is returned.

% Copy right, Mohammad SAFEEA, 15th-April-2018

theCommand='velJDC_';
for i=1:7
    x=jvel{i};
    theCommand=[theCommand,sprintf('%0.5f',x),'_'];
end

fprintf(t_Kuka, theCommand);
message=fgets(t_Kuka);
ret=checkAcknowledgment(message);
end

