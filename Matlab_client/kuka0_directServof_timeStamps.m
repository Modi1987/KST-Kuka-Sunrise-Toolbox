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
global t;
t=net_establishConnection( ip );

if ~exist('t','var') || isempty(t)
  warning('Connection could not be establised, script aborted');
  return;
else
    
      %% Get position roientation of end effector
      
      jPos={0,0,0,0,0,0,0};
    
      setBlueOff(t); % turn Off blue light
    
      relVel=0.15;
      movePTPJointSpace( t , jPos, relVel); % move to initial configuration
 
        %% Start direct servo in joint space       
        realTime_startDirectServoJoints(t);
        
       w=0.8*2; % motion constants, frequency rad/sec
       A=pi/6; % motion constants, amplitude of motion
       
       a=datevec(now);
       t0=a(6)+a(5)*60+a(4)*60*60; % calculate initial time
       
       dt=0;
     precission=1000;
     precission_flag=true;
     tstart=t0;
     counter=0;
     duration=15*60; %15 minutes
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
          %sendJointsPositions( t ,jPos);
          sendJointsPositionsf( t ,jPos);
          time_stamps(counter)=dt;
           
       end
       tend=time;
       rate=counter/(tend-tstart);
       %% Stop the direct servo motion
       realTime_stopDirectServoJoints( t );

       fprintf('\nThe rate of joint nagles update per second is: \n');
       disp(rate);
       fprintf('\n')
       pause(2);
       %% turn off light
       setBlueOff(t); 
       
      %% turn off the server
       net_turnOffServer( t );


       fclose(t);
       
       %% save time stamps
       save('timingdata.mat','time_stamps');
      
end
 warning('on')
