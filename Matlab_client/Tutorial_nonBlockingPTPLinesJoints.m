%% Example
% An example script, it is used to show how to use the 
% non-blocking moiton functions of the KST

% First start the server on the KUKA iiwa controller
% Then run the following script in Matlab

% Note you have 60 seconds to connect to server after starting the
% application (MatlabToolboxServer) from the smart pad on the robot controller.

% Mohammad SAFEEA, 3rd of May 2017

close all,clear all;clc;
warning('off');
ip='172.31.1.147'; % The IP of the controller
% start a connection with the server
global t_Kuka;
t_Kuka=net_establishConnection( ip );

if ~exist('t_Kuka','var') || isempty(t_Kuka) || strcmp(t_Kuka.Status,'closed')
  disp('Connection could not be establised, script aborted');
  return;
end

%% Non blocking motion in Cartesian space
for i=1:3
% Go to some initial position
relVel=0.35; % over ride relative joint velocities
jPos={0, -pi / 180 * 10, 0, -pi / 180 * 100, pi / 180 * 90,pi / 180 * 90, 0};   % initial cofiguration
movePTPJointSpace( t_Kuka , jPos, relVel);
      
% Get current position of EEF
[ Pos ] = getEEFPos( t_Kuka );
distPos=Pos;
distPos{3}=distPos{3}-100;

% Move non-blocking
vel=5*5;
nonBlocking_movePTPLineEEF( t_Kuka , distPos, vel);
flag=true;
while ~nonBlocking_isGoalReached(t_Kuka)
    disp('Cartesian non-blocking motion in progress');
    pause(0.2);
    if(flag)
        setBlueOn( t_Kuka );
        flag=false;
    else
        setBlueOff( t_Kuka );
        flag=true;
    end
end
setBlueOff( t_Kuka );
end
%% Non blocking motion in Cartesian space
for i=1:3
% Go to some initial position
relVel=0.35; % over ride relative joint velocities
jPos={0, -pi / 180 * 10, 0, -pi / 180 * 100, pi / 180 * 90,pi / 180 * 90, 0};   % initial cofiguration
movePTPJointSpace( t_Kuka , jPos, relVel);
      
% Distination angular position
distPos=jPos;
distPos{3}=distPos{3}-pi/3;

% Move non-blocking
relVel=0.25;
nonBlocking_movePTPJointSpace( t_Kuka , distPos, relVel);
flag=true;
while ~nonBlocking_isGoalReached(t_Kuka)
    disp('Joints non-blocking motion in progress');
    pause(0.2);
    if(flag)
        setBlueOn( t_Kuka );
        flag=false;
    else
        setBlueOff( t_Kuka );
        flag=true;
    end
end
setBlueOff( t_Kuka );
end
%% Turn off server
disp('Distination reached');
net_turnOffServer( t_Kuka );