%% Example of using KST class for interfacing with KUKA iiwa robots

% An example script, it is used to show how to use the different
% functions of the KUKA Sunrise Toolbox

% First start the server on the KUKA iiwa controller
% Then run the following script in Matlab

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
jPos={0,pi*20/180,0,-pi*70/180,0,pi*60/180,0}; % initial confuguration
relVel=0.15; % relative velocity
iiwa.movePTPJointSpace(jPos, relVel); % point to point motion in joint space

%% Linear relative motion of end effector, relative to base frame
deltaX=0;deltaY=0;deltaZ=100.;
Pos{1}=deltaX;
Pos{2}=deltaY;
Pos{3}=deltaZ;

vel=250; % linear velocity of end effector, mm/sec
iiwa.movePTPLineEefRelBase(Pos, vel);
Pos{3}=-deltaZ;
iiwa.movePTPLineEefRelBase(Pos, vel);

%% Linear relative motion of end effector, relative to EEF frame
Pos{1}=deltaX;
Pos{2}=deltaY;
Pos{3}=deltaZ;

vel=150; % linear velocity of end effector, mm/sec

iiwa.movePTPLineEefRelEef(Pos, vel);
Pos{3}=-deltaZ;
iiwa.movePTPLineEefRelEef(Pos, vel);


%% turn off the server
iiwa.net_turnOffServer();
warning('on');
