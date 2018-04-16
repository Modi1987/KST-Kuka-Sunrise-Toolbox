%% Example
% real time control of the KUKA iiwa 7 R 800
% the impedence control is turned on
% Moving first joint of the robot, using a sinisoidal function

% The external torques are plotted in real-time during the test
% the feedback from the measured torques can be used to for a closed loop
% control

% An example script, it is used to show how to use the different
% functions of the KUKA Sunrise matlab toolbox

% First start the server on the KUKA iiwa controller
% Then run this script using Matlab

% Copyright: Mohammad SAFEEA, 13th of March 2018

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
    
      %% Move point to point to an initial position
        jPos={0,0,0,-pi/2,0,pi/2,0};
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
     tstart=t0;
     counter=0;
     duration=20*60; %1 minutes
     %% Control loop
     % real time plot handles
         colors={'k','b','r','g','c','m','y'};
         figureHandle=figure('Units','inches','Position',[0 0 5 3.75]);
         numOfSamples=120; % number of samples to show in the plot
         timeVec=1:numOfSamples;
         tawVec=zeros(7,numOfSamples);
         plotHandle=[];
         for i=1:7
            plotHandle=[plotHandle,plot(timeVec,tawVec(i,:),colors{i},'LineWidth',2)];
            hold on;
         end
        % format the plot
        ylim([0,8]);
        temp=title('External torques');
        set(temp,'FontSize',16);
        temp=xlabel('Time (seconds)');
        set(temp,'FontSize',14);
        temp=ylabel('Distance (m)');
        set(temp,'FontSize',14);
    
     
       while(dt<duration)
         %% perform trajectory calculation here
          a=datevec(now);
          time=a(6)+a(5)*60+a(4)*60*60;
          dt=time-t0;
          
          temp=A*(1-cos(w*dt));
            for dacount=1:7
                jPosCommand{dacount}=jPos{dacount}+temp;
            end
          counter=counter+1;
          %% Send joint positions to robot
          taw=sendJointsPositionsExTorque( t_Kuka ,jPosCommand);
          
          tawTemp=zeros(7,1);
          for i=1:7
              tawTemp(i)=taw{i};
              torque_array(i,counter)=taw{i};
          end
          % delete first measurment
          tawVec(:,1)=[];
          % add new measurment to end of arrays
          tawVec=[tawVec,tawTemp];
          % update plots data
          for i=1:6
            set(plotHandle(i),'YData',tawVec(i,:));
          end
          set(plotHandle(7),'YData',tawVec(i,:));
          % show plot data
          set(figureHandle,'Visible','on');
           
       end

       
       %% Stop the realtime control with impedence motion
       realTime_stopImpedanceJoints( t_Kuka );

       fprintf('\n Motion stopped \n');
       pause(2);
       %% turn off light
       setBlueOff(t_Kuka); 
       
      %% turn off the server
       net_turnOffServer( t_Kuka );


       fclose(t_Kuka);
       
      
end
warning('on')
