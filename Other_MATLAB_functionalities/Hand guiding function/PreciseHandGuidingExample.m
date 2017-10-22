%% Example
% This script is used to initialize the precise hand guiding functionality on KUKA
% robot remotely

% Mohammad SAFEEA, 22nd of Oct  2017

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
wightOfTool=0; % weight of the mounted tool and tool changer (if any)
COMofTool=[0;
    0;
    0]; % coordinates of center of mass of tool and toolcanger (if any) described in reference frame of flange.
startPreciseHandGuiding( t,wightOfTool,COMofTool );
           
 
%% turn off the server
net_turnOffServer( t );


fclose(t);
end

