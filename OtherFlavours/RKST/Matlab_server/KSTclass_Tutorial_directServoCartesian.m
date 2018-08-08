%% Example of using KST class for interfacing with KUKA iiwa robots

% This example is used for real time control of the KUKA iiwa for
% moving EEF of the robot in Z direction using a sinusoidal function

% An example script, it is used to show how to use the different
% functions of the KUKA Sunrise matlab toolbox

% First start the server on the KUKA iiwa controller
% Then run this script using Matlab

% Important: Be careful when runnning the script, be sure that no human, nor obstacles
% are around the robot

% This example works with Sunrise application version KST_1.7  and higher.
% Copyright: Mohammad SAFEEA, 8th-August-2018

close all;clear;clc;
warning('off')
%% Create the robot object
ip='172.31.1.147'; % The IP of the controller
arg1=KST.LBR7R800; % choose the robot iiwa7R800 or iiwa14R820
arg2=KST.Medien_Flansch_elektrisch; % choose the type of flange
Tef_flange=eye(4); % transofrm matrix of EEF with respect to flange
Tef_flange(3,4)=45/1000;
iiwa=KST(ip,arg1,arg2,Tef_flange); % create the object

%% Start a connection with the server
flag=iiwa.net_establishConnection();
if flag==0
  return;
end

%% turn on light, this works only with touch-pneumatic flange
% iiwa.setBlueOn(); % turn on blue light
%% Go to an initial Joints positions
jPos={0,0,0,-pi/2,0,pi/2,0};
relVel=0.15;
iiwa.movePTPJointSpace(jPos, relVel); % move to initial configuration

%% Get Cartesian position of EEF
fprintf('Cartesian position')
eefpos=iiwa.getEEFPos();
eefposDist=eefpos;
disp(eefpos)
%% Start direct servo in Cartesian space       
iiwa.realTime_startDirectServoCartesian();
disp('Starting direct servo in Cartesian space');
w=2; % motion constants, frequency rad/sec
A=75; % motion constants, amplitude of motion (mm)
tic;
t0=toc; % calculate initial time
deltaT=0;
tstart=t0;
counter=0;
disp('Enter control loop, stream EEF positions')

t_0=toc;
while(deltaT<(6*pi/w))
    %% ferform trajectory calculation here
    time=toc;
    deltaT=time-t0;
    eefposDist{3}=eefpos{3}-A*(1-cos(w*deltaT));
    %% Send EEF position to robot
    if(toc-t_0>0.002)
        counter=counter+1;
        iiwa.sendEEfPositionf( eefposDist);
        t_0=toc;
    end
end
tend=time;
rate=counter/(tend-tstart);
%% Stop the direct servo motion
iiwa.realTime_stopDirectServoCartesian();
fprintf('\nThe rate of update per second is: \n');
disp(rate);
fprintf('\n')
pause(2);
%% turn off light, this works only with touch-pneumatic flange
% iiwa.setBlueOff(); 
%% turn off the server
iiwa.net_turnOffServer( );
warning('on')
