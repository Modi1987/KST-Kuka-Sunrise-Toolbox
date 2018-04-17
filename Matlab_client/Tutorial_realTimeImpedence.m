%% Example
% real time control of the KUKA iiwa 7 R 800
% the impedence control is turned on
% Moving first joint of the robot, using a sinisoidal function

% An example script, it is used to show how to use the different
% functions of the KUKA Sunrise matlab toolbox

% First start the server on the KUKA iiwa controller
% Then run this script using Matlab

% Copyright: Mohammad SAFEEA, 8th of Nov 2017

% Important: Be careful when runnning the script, be sure that no human, nor obstacles
% are around the robot

close all,clear all;clc;

warning('off')

ip='172.31.1.147'; % The IP of the controller
% start a connection with the server
global t_Kuka;
t_Kuka=net_establishConnection( ip );

if ~exist('t_Kuka','var') || isempty(t_Kuka) || strcmp(t_Kuka.Status,'closed')
  warning('Connection could not be establised, script aborted');
  return;
else
    
      %% Get position roientation of end effector
      
%      jPos={0,pi/6,0,-pi/2,0,pi/2-pi/6,0};
   
        jPos={0,0,0,-pi/2,0,pi/2,0};
      %jPos={0,0,0,0,0,0,0};
      setBlueOff(t_Kuka); % turn Off blue light
    
      relVel=0.15;
      movePTPJointSpace( t_Kuka , jPos, relVel); % move to initial configuration
     %% Pause for 3 seocnds
     pause(3); 
        %% Start direct servo in joint space    
        massOfTool=0.5; % the mass of the tool attached to flange in Kg
        cOMx=0; % X coordinate of the center of mass of the tool in (mm)
        cOMy=0; % Y coordinate of the center of mass of the tool in (mm)
        cOMz=40; % Z coordinate of the center of mass of the tool in (mm)
        cStiness=900; % cartizian stifness
        rStifness=80; % rotational stifness
        nStifness=50; % null space stifness
        
        % Start the realtime control with impedence
        realTime_startImpedanceJoints(t_Kuka,massOfTool,cOMx,cOMy,cOMz,...
        cStiness,rStifness,nStifness);
        
       w=0.6; % motion constants, frequency rad/sec
       A=0.2; % motion constants, amplitude of motion
       
       a=datevec(now);
       t0=a(6)+a(5)*60+a(4)*60*60; % calculate initial time
       
       dt=0;
     precission=1000;
     precission_flag=true;
     tstart=t0;
     counter=0;
     duration=1*60; %1 minutes
     time_stamps=zeros(1,1000*duration);
       while(dt<duration)
         %% ferform trajectory calculation here
          a=datevec(now);
          time=a(6)+a(5)*60+a(4)*60*60;
          dt=time-t0;
          
          temp=A*(1-cos(w*dt));
            for dacount=1:7
                jPosCommand{dacount}=jPos{dacount}+temp;
            end
          counter=counter+1;
          %% Send joint positions to robot
          %sendJointsPositions( t ,jPos);
          sendJointsPositionsf( t_Kuka ,jPosCommand);
          time_stamps(counter)=dt;
           
       end
       tend=time;
       rate=counter/(tend-tstart);
       
       %% Stop the realtime control with impedence motion
       realTime_stopImpedanceJoints( t_Kuka );

       fprintf('\nThe rate of joint nagles update per second is: \n');
       disp(rate);
       fprintf('\n')
       pause(2);
       %% turn off light
       setBlueOff(t_Kuka); 
       
      %% turn off the server
       net_turnOffServer( t_Kuka );


       fclose(t_Kuka);
       
       %% save time stamps
       save('timingdata.mat','time_stamps');
      
end
 warning('on')
