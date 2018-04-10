%% Example
% PTP motion conditional torques, KUKA iiwa 7 R 800

% An example script, it is used to show how to use the different
% functions of the KUKA Sunrise matlab toolbox

% First start the server on the KUKA iiwa controller
% Then run this script using Matlab

% Copyright: Mohammad SAFEEA, 8th of April 2018

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
jPos{1}=pi/2;
joints_indices=[1,4]; % joint index start from one
max_torque=[5,5];
min_torque=[-5,-5];
res=movePTP_ConditionalTorque_JointSpace( t_Kuka...
    , jPos, relVel,joints_indices,max_torque,min_torque);
if(res==1)
    disp('Motion completed successfully');
elseif(res==0)
    disp('Motion interrupted');
elseif(res==-1)
    disp('Error while performing the motion');
end
%% Turn off the server
net_turnOffServer( t_Kuka );
fclose(t_Kuka);
