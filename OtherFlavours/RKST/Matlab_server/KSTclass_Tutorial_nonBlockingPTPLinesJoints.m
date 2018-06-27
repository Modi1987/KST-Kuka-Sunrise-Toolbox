%% Example of using KST class for interfacing with KUKA iiwa robots

% An example script, it is used to show how to use the 
% non-blocking moiton functions of the KST

% First start the server on the KUKA iiwa controller
% Then run the following script in Matlab

% Note you have 60 seconds to connect to server after starting the
% application (MatlabToolboxServer) from the smart pad on the robot controller.

% This example works with Sunrise application version KST_1.7  and higher.
% Copyright Mohammad SAFEEA, 26th-June-2018

close all;clear;clc;
warning('off')
%% Create the robot object
ip='172.31.1.147'; % The IP of the controller
arg1=KST.LBR7R800; % choose the robot iiwa7R800 or iiwa14R820
arg2=KST.Medien_Flansch_elektrisch; % choose the type of flange
Tef_flange=eye(4); % transofrm matrix of EEF with respect to flange
iiwa=KST(ip,arg1,arg2,Tef_flange); % create the object

%% Start a connection with the server
flag=iiwa.net_establishConnection();
if flag==0
    return;
end
pause(1);
disp('Doing some stuff')
    
%% Non blocking motion in Cartesian space
for i=1:3
% Go to some initial position
relVel=0.35; % over ride relative joint velocities
jPos={0, -pi / 180 * 10, 0, -pi / 180 * 100, pi / 180 * 90,pi / 180 * 90, 0};   % initial cofiguration
iiwa.movePTPJointSpace(jPos, relVel);
      
% Get current position of EEF
[ Pos ] = iiwa.getEEFPos(  );
distPos=Pos;
distPos{3}=distPos{3}-100;

% Move non-blocking
vel=25; %25 mm/sec
iiwa.nonBlocking_movePTPLineEEF(distPos, vel);
flag=true;
while ~iiwa.nonBlocking_isGoalReached()
    disp('Cartesian non-blocking motion in progress');
    pause(0.2);
    if(flag)
        iiwa.setBlueOn(  );
        flag=false;
    else
        iiwa.setBlueOff(  );
        flag=true;
    end
end
iiwa.setBlueOff(  );
end
%% Non blocking motion in Cartesian space
for i=1:3
% Go to some initial position
relVel=0.35; % over ride relative joint velocities
jPos={0, -pi / 180 * 10, 0, -pi / 180 * 100, pi / 180 * 90,pi / 180 * 90, 0};   % initial cofiguration
iiwa.movePTPJointSpace(jPos, relVel);
      
% Distination angular position
distPos=jPos;
distPos{3}=distPos{3}-pi/3;

% Move non-blocking
relVel=0.25;
iiwa.nonBlocking_movePTPJointSpace(distPos, relVel);
flag=true;
while ~iiwa.nonBlocking_isGoalReached()
    disp('Joints non-blocking motion in progress');
    pause(0.2);
    if(flag)
        iiwa.setBlueOn(  );
        flag=false;
    else
        iiwa.setBlueOff(  );
        flag=true;
    end
end
iiwa.setBlueOff(  );
end
%% Turn off server
disp('Distination reached');
disp('Turning off server');
iiwa.net_turnOffServer(  );