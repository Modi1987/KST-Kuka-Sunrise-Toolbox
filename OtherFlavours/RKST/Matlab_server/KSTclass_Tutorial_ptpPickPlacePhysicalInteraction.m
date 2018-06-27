%% Example of using KST class for interfacing with KUKA iiwa robots

% Collaborative pick and place application, the robot detects collision
% with its surrounding while performing the pick and place application,
% when a collision is detected, the robots stops its motion, when the
% operator gives the robot a double touch on the end-effector in the Z
% direcdtion, the robot returns back to doing its operation.

% First start the server on the KUKA iiwa controller
% Then run this script using Matlab

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
disp('An example on using the interruptible PTP motion functions for Human robot collaboration')

%% Move PTP in joint space to some inital position
jPos={0,0,0,-pi/2,0,pi/2,0};
relVel=0.15;
iiwa.movePTPJointSpace(jPos, relVel); % move to initial configuration
%% Move PTP in joint space with torque limits
[ Pos ] = iiwa.getEEFPos();
deltaY=250;
deltaZ=332-150;

joints_indices=[1,2,3,4,5,6,7]; % joint index start from one
max_torque=ones(7,1)*8;
max_torque(1)=3;
min_torque=-max_torque;
VEL=175;
w=17; % weight of tool newton
%% Go down near the table
Pos{3}=Pos{3}-150;
iiwa.moveWaitForDTWhenInterrupted(  ...
     Pos, VEL,joints_indices,max_torque,min_torque,w);
%% Open gripper
iiwa.setPin1Off();
pause(1);
iiwa.setPin11On();
pause(1);
%% Motion twards the box
Pos{2}=Pos{2}-deltaY;
iiwa.moveWaitForDTWhenInterrupted( ...
     Pos, VEL,joints_indices,max_torque,min_torque,w);

Pos{3}=Pos{3}-deltaZ;
iiwa.moveWaitForDTWhenInterrupted(  ...
     Pos, VEL,joints_indices,max_torque,min_torque,w);
%% Close gripper
iiwa.setPin1On();
pause(1);
iiwa.setPin11Off();
pause(1);
%% Picking the box twards the goal
Pos{3}=Pos{3}+deltaZ;
iiwa.moveWaitForDTWhenInterrupted(  ...
     Pos, VEL,joints_indices,max_torque,min_torque,w);

Pos{2}=Pos{2}+2*deltaY;
iiwa.moveWaitForDTWhenInterrupted(  ...
     Pos, VEL,joints_indices,max_torque,min_torque,w);

Pos{3}=Pos{3}-deltaZ;
iiwa.moveWaitForDTWhenInterrupted(  ...
     Pos, VEL,joints_indices,max_torque,min_torque,w);
%% Release the box
% Open gripper
iiwa.setPin1Off();
pause(1);
iiwa.setPin11On();
pause(1);

Pos{3}=Pos{3}+deltaZ;
iiwa.moveWaitForDTWhenInterrupted(  ...
     Pos, VEL,joints_indices,max_torque,min_torque,w);
 
%% Turn off the server
iiwa.net_turnOffServer();




