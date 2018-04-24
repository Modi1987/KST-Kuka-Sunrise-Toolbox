function [ ret ] = sendEEfPosition( t_Kuka ,EEEFpos)
%% Syntax
% sendEEfPosition( t_Kuka ,EEEFpos)

%% About:
% This function is used to send the target positions of the end-effector for the
% direct servo motion
% this function is for direct-servoing in Cartesian space

%% Arreguamnets
% t_Kuka: is the TCP/IP connection object
% EEEFpos: is 6 cells array of doubles, first three elements represent
% (X,Y,Z) coordinates in (mm), rest three elements represent fixed rotation
% angles of EEF in (rads)

%% Return value:
% ret: 'true' if the joints positions message has been received and processed
% successfully by the server, otherwise 'false' is returned.

% Copy right, Mohammad SAFEEA, 1st of April 2018

theCommand='DcSeCarW_';

for i=1:6
    x=EEEFpos{i};
    theCommand=[theCommand,sprintf('%0.5f',x),'_'];
end
% send the message through network
fprintf(t_Kuka, theCommand);
message=fgets(t_Kuka);
ret=checkAcknowledgment(message);
end

