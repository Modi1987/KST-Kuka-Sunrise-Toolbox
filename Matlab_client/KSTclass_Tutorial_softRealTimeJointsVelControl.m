%% Example of using KST class for interfacing with KUKA iiwa robots

% Soft real-time control of the KUKA 
% control is executed at joint velocity level

% An example script, it is used to show how to use the different
% functions of the KUKA Sunrise Toolbox

% First start the server on the KUKA iiwa controller
% Then run this script using Matlab

% This example works with Sunrise application version KST_1.7  and higher.
% Copyright Mohammad SAFEEA, 8th-August-2018

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

%% Go to initial position
jPos={0,0,0,0,0,0,0};
relVel=0.25;
iiwa.movePTPJointSpace(jPos, relVel); % move to initial configuration

%% Start direct servo in joint space       
iiwa.realTime_startVelControlJoints();

w=2; % motion constants, frequency rad/sec
A=pi/6; % motion constants, amplitude of motion
counter=0;
jvel={0,0,0,0,0,0,0};

%% Initiate timing variables
dt=0;
tic;
t0=toc; % calculate initial time

%% Control loop
while(dt<(8*pi/w))
    %% Perform velocity command calculation here
    time=toc;
    dt=time-t0;
    jvel{1}=A*w*sin(w*dt);
    counter=counter+1;
    %% Send joint velocties to robot
    iiwa.sendJointsVelocities(jvel);
end
tstart=t0;
tend=time;
rate=counter/(tend-tstart);

%% Stop the direct servo motion
iiwa.realTime_stopVelControlJoints();
fprintf('\nTotal execution time is %f: \n',tend-t0 );
fprintf('\nThe rate of command update per second is: \n');
disp(rate);
fprintf('\n')
pause(2);

%% turn off light
iiwa.net_turnOffServer()
disp('Direct servo motion completed successfully')
warning('on')
return;


