%% Example of using KST class for interfacing with KUKA iiwa robots

% This example usied in soft real time control of the KUKA iiwa 7 R 800
% for moving first joint of the robot, using a sinusoidal function, time
% delays are also plotted

% An example script, it is used to show how to use the different
% functions of the KUKA Sunrise matlab toolbox

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
disp('Moving first joint of the robot using a sinusoidal function')

%% Go to some initial position
jPos={0,0,0,0,0,0,0};
relVel=0.15;
iiwa.movePTPJointSpace(jPos, relVel); % move to initial configuration

%% Start direct servo in joint space       
iiwa.realTime_startDirectServoJoints();

w=0.8*2; % motion constants, frequency rad/sec
A=pi/6; % motion constants, amplitude of motion

a=datevec(now);
t0=a(6)+a(5)*60+a(4)*60*60; % calculate initial time

dt=0;
precission=1000;
precission_flag=true;
tstart=t0;
counter=0;
duration=0.5*60; %0.5 minute
time_stamps=zeros(1,1000*duration);
while(dt<duration)
 %% ferform trajectory calculation here
  a=datevec(now);
  time=a(6)+a(5)*60+a(4)*60*60;
  dt=time-t0;

  jPos{7}=A*(1-cos(w*dt));
  if precission_flag
    for temp_i=1:7
        jPos{temp_i}=floor(jPos{temp_i}*precission)/precission; % limit the number of decimal degits to 3
    end
  end
  counter=counter+1;
  %% Send joint positions to robot
  iiwa.sendJointsPositions(jPos);
  time_stamps(counter)=dt;

end
tend=time;
rate=counter/(tend-tstart);
%% Stop the direct servo motion
iiwa.realTime_stopDirectServoJoints();

fprintf('\nThe rate of joint nagles update per second is: \n');
disp(rate);
fprintf('\n')
pause(2);


%% turn off the server
iiwa.net_turnOffServer();

%% Plot timing delays, using the collected timing stamps
timeIntervals=time_stamps(2:counter)-time_stamps(1:counter-1);
time_stamps=time_stamps(1:counter-1);
plot(time_stamps,timeIntervals);
warning('on')
