%% Example of using KST class for interfacing with KUKA iiwa robots

% An example script, it is used to show how to use the different
% functions of the KUKA Sunrise Toolbox

% First start the server on the KUKA iiwa controller
% Then run the following script in Matlab

% This example works with Sunrise application version KST_1.7  and higher.
% Copyright Mohammad SAFEEA, 8th-August-2018

close all;clear;clc;
warning('off')
%% Create the robot object
ip='172.31.1.147'; % The IP of the controller
arg1=KST.LBR7R800; % choose the robot iiwa7R800 or iiwa14R820
arg2=KST.Medien_Flansch_elektrisch; % choose the type of flange
Tef_flange=eye(4); % transofrm matrix of EEF with respect to flange
Tef_flange(3,4)=50/1000;
iiwa=KST(ip,arg1,arg2,Tef_flange); % create the object

%% Start a connection with the server
flag=iiwa.net_establishConnection();
if flag==0
    return;
end
pause(1);
disp('Doing some stuff')

%% move to initial position
pinit={0,pi*20/180,0,-pi*70/180,0,pi*90/180,0}; % initial confuguration
relVel=0.15; % relative velocity
iiwa.movePTPJointSpace(pinit, relVel); % point to point motion in joint space

%% Get position roientation of end effector
disp('Cartesian position')
Pos=iiwa.getEEFPos();
disp(Pos)

%% Move the endeffector in the X direction
Vel=50; % velocity of the end effector, mm/sec
disp=50;
index=1;

Pos{index}=Pos{index}+disp;
iiwa.movePTPLineEEF(Pos, Vel)

pause(0.1)

Pos{index}=Pos{index}-disp;
iiwa.movePTPLineEEF(Pos, Vel)

%% Move the endeffector in the z direction
index=3;

Pos{index}=Pos{index}+disp;
iiwa.movePTPLineEEF(Pos, Vel)

pause(0.1)

Pos{index}=Pos{index}-disp;
iiwa.movePTPLineEEF(Pos, Vel)

%% Move the endeffector to a distination frame, 

Pos={400,0,580,-pi,0,-pi}; % first configuration
% the coordinates are:
% x=400mm, y=0mm, z=580 mm.
% the rotation angles are:
% alpha=-180 degrees, beta=0 degrees, gama=-180 degrees
iiwa.movePTPLineEEF(Pos, Vel)

Pos={500,0,580,-pi,0,-pi+pi/4}; %% second configuration
% the coordinates are:
% x=400mm, y=0mm, z=580 mm.
% the rotation angles are:
% alpha=-180 degrees, beta=0 degrees, gama=-165 degrees, 
iiwa.movePTPLineEEF(Pos, Vel)

%% turn off the server
iiwa.net_turnOffServer();

warning('on');
