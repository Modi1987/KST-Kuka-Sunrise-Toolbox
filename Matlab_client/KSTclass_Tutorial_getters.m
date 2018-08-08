%% Example of using KST class for interfacing with KUKA iiwa robots

% An example script, it is used to show how to use the different
% getter functions of the KUKA Sunrise Toolbox
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
Tef_flange(3,4)=30/1000;
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

%% Get the joints positions
jPos  = iiwa.getJointsPos();
fprintf('The joints positions of the robot are: \n');
disp(jPos);

%% Get position roientation of end effector
fprintf('Cartesian position/orientation of end-effector:\n');
pos=iiwa.getEEFPos();
disp(pos);

%% Get position of end effector
fprintf('Cartesian position of end-effecotr:\n')
cpos=iiwa.getEEFCartesianPosition();
disp(cpos);

%% Get orientation of end effector
fprintf('Cartesian orientation of end-effecotr:\n')
orie=iiwa.getEEFCartesianOrientation();
disp(orie);
      
%% Get force at end effector
fprintf('Cartesian force acting at end effector:\n')
f=iiwa.getEEF_Force();
disp(f);

%% Get moment at end effector
fprintf('moment at eef\n');
m=iiwa.getEEF_Moment();
disp(m);
  
%% turn off the server
iiwa.net_turnOffServer();



