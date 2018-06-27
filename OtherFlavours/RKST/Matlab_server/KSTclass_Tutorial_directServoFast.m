%% Example of using KST class for interfacing with KUKA iiwa robots
% Using soft real time control of the KUKA iiwa 7 R 800
% Moving first joint of the robot, using a sinusoidal function

% An example script, it is used to show how to use the different
% functions of the KUKA Sunrise Toolbox

% First start the server on the KUKA iiwa controller
% Then run this script using Matlab

% Important: Be careful when runnning the script, be sure that no human, nor obstacles
% are around the robot

% This example works with Sunrise application version KST_1.7  and higher.
% Copyright Mohammad SAFEEA, 25th-June-2018

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
disp('Soft realtime control, moving first joint using sinusoidal function');
    
%% Go to initial position
jPos={0,0,0,0,0,0,0};
relVel=0.25;
iiwa.movePTPJointSpace(jPos, relVel); % move to initial configuration

%% Start direct servo in joint space       
iiwa.realTime_startDirectServoJoints();
%% Some variables
w=2.0; % motion constants, frequency rad/sec
A=pi/6; % motion constants, amplitude of motion
dt=0;
counter=0;
%% Initiate timing
tic;
%% Control loop
daCount=0;
while(dt<(6*pi/w))
    if daCount==0
        t0=toc; % calculate initial time
        t_0=toc;
        daCount=1;
    end
 %% perform trajectory calculation here
  time=toc;
  dt=time-t0;
  jPos{1}=A*(1-cos(w*dt));
  %% Send joint positions to robot
    if(toc-t_0>0.003)
        counter=counter+1;
        iiwa.sendJointsPositionsf(jPos);
        t_0=toc;
    end
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
%% Turn off server
iiwa.net_turnOffServer()
disp('Direct servo motion completed successfully')
warning('on')


