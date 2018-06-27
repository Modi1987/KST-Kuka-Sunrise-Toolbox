%% Example of using KST class for interfacing with KUKA iiwa robots

% An example script, it is used to show how to use the different
% functions of the KUKA Sunrise Toolbox
% First start the server on the KUKA iiwa controller
% Then run the following script using Matlab

% Important: Be careful when runnning the script, be sure that no human, nor obstacles
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
pinit={0,pi*20/180,0,-pi*70/180,0,pi*90/180,0}; % initial confuguration
relVel=0.15; % relative velocity
iiwa.movePTPJointSpace( pinit, relVel); % point to point motion in joint space

%% Get the joints positions
[ jPos ] = iiwa.getJointsPos();

%% Start the direct servo
iiwa.realTime_startDirectServoJoints();
scale=4;
n=60*scale;
step=pi/(n*12);
tempoDaEspera=0.001/scale;
% the following array is the trajectory
jointAnglesArray=zeros(7,2*n);
counter=0;
jVec=zeros(7,1);
for i=1:n
 jPos{1}=jPos{1}+step;
 iiwa.sendJointsPositions(jPos);
 delay(tempoDaEspera);
 % Generate the trajectory
  counter=counter+1;
 for tt=1:7
     jVec(tt)=jPos{tt};
 end
 jointAnglesArray(:,counter)=jVec;
end

for i=1:n
 jPos{1}=jPos{1}-step;
 iiwa.sendJointsPositions(jPos);
 delay(tempoDaEspera);
 % Generate the trajectory
 counter=counter+1;
 for tt=1:7
     jVec(tt)=jPos{tt};
 end
 jointAnglesArray(:,counter)=jVec;
end
pause(1);
iiwa.realTime_stopDirectServoJoints();
%% Read joints positions ten times
for tttt=1:10
  iiwa.getJointsPos()
end

iiwa.setBlueOff();
iiwa.setBlueOn();
pause(3);
iiwa.setBlueOff();


%% Play the motion again, from the trajectory
trajectory=jointAnglesArray;
delayTime=tempoDaEspera;
iiwa.realTime_moveOnPathInJointSpace(trajectory,delayTime);


%% Get position roientation of end effector
fprintf('Cartesian position')
iiwa.getEEFPos()

%% Get position of end effector
fprintf('Cartesian position')
iiwa.getEEFCartesianPosition()

%% Get orientation of end effector
fprintf('Cartesian orientation')
iiwa.getEEFCartesianOrientation()

%% Get force at end effector
fprintf('Cartesian force')
iiwa.getEEF_Force()

%% Get moment at end effector
fprintf('moment at eef')
iiwa.getEEF_Moment()

%% PTP motion

[ jPos ] = iiwa.getJointsPos(); % get current joints position

for ttt=1:7  % home position
  homePos{ttt}=0;
end

relVel=0.15;
iiwa.movePTPJointSpace( homePos, relVel); % go to home position
iiwa.movePTPJointSpace( jPos, relVel); % return back to original position

%% turn off the server
iiwa.net_turnOffServer( );

