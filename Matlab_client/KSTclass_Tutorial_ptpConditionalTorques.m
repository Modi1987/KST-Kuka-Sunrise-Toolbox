%% Example of using KST class for interfacing with KUKA iiwa robots

% Example on using the PTP conditional motion functions of the KST

% First start the server on the KUKA iiwa controller
% Then run this script using Matlab

% Important: The code is provided as is, the author does not hold any
% liability what so ever, the scripts are provided under MIT license.

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
jPos{1}=pi/2;
joints_indices=[1,4]; % joint index start from one
max_torque=[5,5];
min_torque=[-5,-5];
res=iiwa.movePTP_ConditionalTorque_JointSpace( ...
    jPos, relVel,joints_indices,max_torque,min_torque);
if(res==1)
    disp('Motion completed successfully');
elseif(res==0)
    disp('Motion interrupted');
elseif(res==-1)
    disp('Error while performing the motion');
end

%% Turn off the server
iiwa.net_turnOffServer(  );
