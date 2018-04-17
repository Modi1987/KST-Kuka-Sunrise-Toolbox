%% Example
% Collaborative pick and place application, the robot detects collision
% with its surrounding while performing the pick and place application,
% when a collision is detected, the robots stops its motion, when the
% operator gives the robot a double touch on the end-effector in the Z
% direcdtion, the robot returns back to doing its operation.

% PTP motion conditional torques, KUKA iiwa 7 R 800

% An example script, it is used to show how to use the different
% functions of the KUKA Sunrise matlab toolbox

% First start the server on the KUKA iiwa controller
% Then run this script using Matlab

% Copyright: Mohammad SAFEEA, 11th of April 2018

% Important: Be careful when runnning the script, 

close all,clear all;clc;

warning('off')

ip='172.31.1.147'; % The IP of the controller
% start a connection with the server
global t_Kuka;
t_Kuka=net_establishConnection( ip );

if ~exist('t_Kuka','var') || isempty(t_Kuka) || strcmp(t_Kuka.Status,'closed')
  disp('Connection could not be establised, script aborted');
  return;
end
disp('An example on using the interruptible PTP motion functions for Human robot collaboration')
%% Move PTP in joint space to some inital position
jPos={0,0,0,-pi/2,0,pi/2,0};
relVel=0.15;
movePTPJointSpace( t_Kuka , jPos, relVel); % move to initial configuration
%% Move PTP in joint space with torque limits
[ Pos ] = getEEFPos( t_Kuka );
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
moveWaitForDTWhenInterrupted( t_Kuka ,...
     Pos, VEL,joints_indices,max_torque,min_torque,w);
%% Open gripper
OpenGripper(t_Kuka);
%% Motion twards the box
Pos{2}=Pos{2}-deltaY;
moveWaitForDTWhenInterrupted( t_Kuka ,...
     Pos, VEL,joints_indices,max_torque,min_torque,w);

Pos{3}=Pos{3}-deltaZ;
moveWaitForDTWhenInterrupted( t_Kuka ,...
     Pos, VEL,joints_indices,max_torque,min_torque,w);
%% Close gripper
CloseGripper(t_Kuka);
%% Picking the box twards the goal
Pos{3}=Pos{3}+deltaZ;
moveWaitForDTWhenInterrupted( t_Kuka ,...
     Pos, VEL,joints_indices,max_torque,min_torque,w);

Pos{2}=Pos{2}+2*deltaY;
moveWaitForDTWhenInterrupted( t_Kuka ,...
     Pos, VEL,joints_indices,max_torque,min_torque,w);

Pos{3}=Pos{3}-deltaZ;
moveWaitForDTWhenInterrupted( t_Kuka ,...
     Pos, VEL,joints_indices,max_torque,min_torque,w);
%% Release the box
OpenGripper(t_Kuka);
Pos{3}=Pos{3}+deltaZ;
moveWaitForDTWhenInterrupted( t_Kuka ,...
     Pos, VEL,joints_indices,max_torque,min_torque,w);
 
%% Turn off the server
net_turnOffServer( t_Kuka );
fclose(t_Kuka);




