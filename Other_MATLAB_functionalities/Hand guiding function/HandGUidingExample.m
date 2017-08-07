%% Example
% This script is used to initialize the hand guiding functionality on KUKA
% robot remotely

% Mohammad SAFEEA, 9th of June 2017

%% Connecting to server
fprintf('Connecting to server....')

ip='172.31.1.147'; % The IP of the controller
% start a connection with the server
t=net_establishConnection( ip );

if ~exist('t','var') || isempty(t)
  warning('Connection could not be establised, script aborted');
  return;
else

%% Start handguiding functionality   
startHandGuiding( t )
           
 
%% turn off the server
net_turnOffServer( t );


fclose(t);
end

