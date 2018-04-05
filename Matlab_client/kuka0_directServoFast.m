%% Example
% real time control of the KUKA iiwa 7 R 800
% Moving first joint of the robot, using a sinisoidal function

% An example script, it is used to show how to use the different
% functions of the KUKA Sunrise matlab toolbox

% First start the server on the KUKA iiwa controller
% Then run this script using Matlab

% Copy right: Mohammad SAFEEA, 15th of June 2017

% Important: Be careful when runnning the script, be sure that no human, nor obstacles
% are around the robot

close all,clear all;clc;

warning('off')

ip='172.31.1.147'; % The IP of the controller
% start a connection with the server
global t_Kuka;
t_Kuka=net_establishConnection( ip );

if ~exist('t','var') || isempty(t_Kuka)
  warning('Connection could not be establised, script aborted');
  return;
end
    
%% Go to initial position

jPos={0,0,0,0,0,0,0};

setBlueOn(t_Kuka); % turn on blue light

relVel=0.5;
movePTPJointSpace( t_Kuka , jPos, relVel); % move to initial configuration

%% Start direct servo in joint space       
realTime_startDirectServoJoints(t_Kuka);

w=2.0; % motion constants, frequency rad/sec
A=pi/6; % motion constants, amplitude of motion

a=datevec(now);
t0=now*86400; % calculate initial time

dt=0;

tstart=t0;
counter=0;
t_0=now*24*60*60;
%% Control loop
try    
    while(dt<(80*pi/w))
     %% ferform trajectory calculation here
      time=now*86400;
      dt=time-t0;
      jPos{1}=A*(1-cos(w*dt));
      %% Send joint positions to robot
        if(now*86400-t_0>0.002)
            counter=counter+1;
            sendJointsPositionsf( t_Kuka ,jPos);
            t_0=now*86400;
        end
    end
    tend=time;
    rate=counter/(tend-tstart);
    %% Stop the direct servo motion
    realTime_stopDirectServoJoints( t_Kuka );
    fprintf('\nTotal execution time is %f: \n',tend-t0 );
    fprintf('\nThe rate of joint nagles update per second is: \n');
    disp(rate);
    fprintf('\n')
    pause(2);
    %% turn off light
    setBlueOff(t_Kuka);
    net_turnOffServer( t_Kuka )
    disp('Direct servo motion completed successfully')
    warning('on')
    return;
catch
    % in case of error turn off the server
    net_turnOffServer( t_Kuka );
    disp('Error during execution the direct servo motion')
    fclose(t_Kuka);  
    warning('on')
end

