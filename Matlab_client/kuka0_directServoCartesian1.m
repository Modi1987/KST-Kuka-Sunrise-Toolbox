%% Example
% real time control of the KUKA iiwa 7 R 800
% Moving EEF of the robot in Z direction using a sinisoidal function

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
global t;
t=net_establishConnection( ip );

if ~exist('t','var') || isempty(t)
  warning('Connection could not be establised, script aborted');
  return;
end
% Joints positions
jPos={0,0,0,-pi/2,0,pi/2,0};
%setBlueOn(t); % turn on blue light
relVel=0.15;
movePTPJointSpace( t , jPos, relVel); % move to initial configuration
%% Get Cartesian position of EEF
fprintf('Cartesian position')
eefpos=getEEFPos( t );
eefposDist=eefpos;
disp(eefpos)
%% Start direct servo in Cartesian space       
realTime_startDirectServoCartesian(t);
disp('Starting direct servo in Cartesian space');
w=2; % motion constants, frequency rad/sec
A=75; % motion constants, amplitude of motion (mm)
tic;
deltaT=0;
counter=0;
initiationFlag=0;
disp('Enter control loop, stream EEF positions')
try
    %% Control loop
    while(deltaT<(6*pi/w))
        if(initiationFlag==0)
            initiationFlag=1;
            t_0=toc;
            t0=t_0;
        else
            time=toc;
            deltaT=time-t0;
            %%%%%%%%%%%%%%%%%%%%%%%%
            %% Perform trajectory calculation here
            eefposDist{3}=eefpos{3}-A*(1-cos(w*deltaT));
            %%%%%%%%%%%%%%%%%%%%%%%%
            % Send EEF position to robot
            if(toc-t_0>0.002)
                counter=counter+1;
                sendEEfPositionf( t ,eefposDist);
                t_0=toc;
            end
        end
    end
    tstart=t0;
    tend=time;
    rate=counter/(tend-tstart);
    %% Stop the direct servo motion
    realTime_stopDirectServoCartesian( t );
    fprintf('\nThe rate of update per second is: \n');
    disp(rate);
    fprintf('\n')
    pause(2);
    %% turn off light
    %setBlueOff(t); 
    %% turn off the server
    net_turnOffServer( t );
    fclose(t);
    warning('on')
catch
    %% turn off the server
    net_turnOffServer( t );   
end