%% Example of using KST class for interfacing with KUKA iiwa robots

% Drawing a sequare with a pen using the KUKA iiwa robot

% An example script, it is used to show how to use the different
% functions of the KUKA Sunrise Toolbox

% First start the server on the KUKA iiwa controller
% Then run the following script in Matlab

% be careful when runnning the script, be sure that no human, nor obstacles
% are around the robot

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
    
%% move to initial position
jPos_init={0,pi*20/180,0,-pi*70/180,0,pi*90/180,0}; % initial confuguration
VEL=0.15; % relative velocity
iiwa.movePTPJointSpace(jPos_init, VEL); % point to point motion in joint space

%% Get position roientation of end effector
disp('Cartesian position')
Pos=iiwa.getEEFPos();
disp(Pos);
z_1=Pos{3}; % save initial hight level
z0=448+3; % go to writing position
VEL=50; % velocity of the end effector, mm/sec


%% Insert the Pen at box level
Pos{3}=z0; %% first point
iiwa.movePTPLineEEF(Pos, VEL);

disp=50*2; % length of the side of the sequare

%% move in x positive direction
Pos{1}=Pos{1}+disp; 
iiwa.movePTPLineEEF(Pos, VEL)

%% move in y negative direction
Pos{2}=Pos{2}-disp; 
iiwa.movePTPLineEEF(Pos, VEL)

%% move in x negative direction
Pos{1}=Pos{1}-disp; 
iiwa.movePTPLineEEF(Pos, VEL)

%% move in y positive direction
Pos{2}=Pos{2}+disp; 
iiwa.movePTPLineEEF(Pos, VEL)

%% Go back to initial position
Pos{3}=z_1;
iiwa.movePTPLineEEF(Pos, VEL) 

%% turn off the server
iiwa.net_turnOffServer();

