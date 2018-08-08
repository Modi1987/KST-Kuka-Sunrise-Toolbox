%% Example of using KST class for interfacing with KUKA iiwa robots
% This example script is used to show how to utilise
% the soft real time control of the KUKA iiwa 7 R 800 for
% Moving first joint of the robot, using a sinusoidal function

% First start the server on the KUKA iiwa controller
% Then run this script using Matlab

% Important: Be careful when runnning the script, be sure that no human, nor obstacles
% are around the robot

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
disp('Moving first joint of the robot using a sinusoidal function')
    

%% Go to initial position
jPos={0,0,0,0,0,0,0};
relVel=0.1;
iiwa.movePTPJointSpace(jPos, relVel); % move to initial configuration

%% Start direct servo in joint space       
iiwa.realTime_startDirectServoJoints();
w=1.5; % motion constants, frequency rad/sec
A=pi/6; % motion constants, amplitude of motion
counter=0;

%% Initiate timing variables
dt=0;
tic;
t0=toc; % calculate initial time
%% Control loop   
while(dt<(12*pi/w))
    %% Perform trajectory calculation here
    time=toc;
    dt=time-t0;
    jPos{1}=A*(1-cos(w*dt));
    counter=counter+1;
    %% Send joint positions to robot
    iiwa.sendJointsPositions(jPos);
end
tstart=t0;
tend=time;
rate=counter/(tend-tstart);
%% Stop the direct servo motion
iiwa.realTime_stopDirectServoJoints();
fprintf('\nTotal execution time is %f: \n',tend-t0 );
fprintf('\nThe rate of joint nagles update per second is: \n');
disp(rate);
fprintf('\n')
pause(2);
%% turn off server
iiwa.net_turnOffServer()
disp('Direct servo motion completed successfully')
warning('on')



