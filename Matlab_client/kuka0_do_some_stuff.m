%% Example
% An example script, it is used to show how to use the different
% functions of the KUKA Sunrise matlab toolbox
% First start the server on the KUKA iiwa controller
% Then run the following script using Matlab

% Copyright: Mohammad SAFEEA, 3rd of May 2017

% Important: Be careful when runnning the script, be sure that no human, nor obstacles
% are around the robot

close all,clear all;clc
warning('off');
ip='172.31.1.147'; % The IP of the robot controller
% start a connection with the server
t=net_establishConnection( ip );

if ~exist('t','var') || isempty(t)
  warning('Connection could not be establised, script aborted');
  return;
else
%% move to some initial configuration
    pinit={0,pi*20/180,0,-pi*70/180,0,pi*90/180,0}; % joints angles of initial confuguration
    relVel=0.15; % over-ride relative velocity of joints
    movePTPJointSpace( t , pinit, relVel); % point to point motion in joint space

%% Get the joints positions
     fprintf('\nJoints positions of robot are \n')
     [ jPos ] = getJointsPos( t )
%% Start the real time motion control loop on the server
     realTime_startDirectServoJoints(t);
     scale=4;
     n=60*scale;
     step=pi/(n*12);
     tempoDaEspera=0.001/scale;
     
     jointAnglesArray=zeros(7,2*n); % Array used to store the trajectory in joint space
     counter=0;
     jVec=zeros(7,1);

     accel_range=20; % acceleration range
     for i=1:n
        if(i<accel_range)
                 stepVal=step*i/accel_range; % motion step increments
        else
                stepVal=step;
        end
         jPos{1}=jPos{1}+stepVal;
         sendJointsPositions( t ,jPos);
         pause(tempoDaEspera);
         % Generate the trajectory
          counter=counter+1;
         for tt=1:7
             jVec(tt)=jPos{tt};
         end
         jointAnglesArray(:,counter)=jVec;
     end
     
      for i=1:n
        if((n-i)<accel_range) % deceleration range
                 stepVal=step*(n-i)/accel_range; % motion step increments
        else
                stepVal=step;
        end
         jPos{1}=jPos{1}-stepVal;
         sendJointsPositions( t ,jPos);
         pause(tempoDaEspera);
         % Generate the trajectory
         counter=counter+1;
         for tt=1:7
             jVec(tt)=jPos{tt};
         end
         jointAnglesArray(:,counter)=jVec;
      end
      pause(1);
      realTime_stopDirectServoJoints( t );

      
     
%% Flash the blue light for 3 seconds
    
    setBlueOff(t);
    setBlueOn(t);
    pause(3);
    setBlueOff(t);


%% Play the motion again from the trajectory array
      trajectory=jointAnglesArray;
      delayTime=tempoDaEspera;
      realTime_moveOnPathInJointSpace( t , trajectory,delayTime);
      
     
%% Get position orientation of end effector
      fprintf('Cartesian position')
      getEEFPos( t )
      
%% Get position of end effector
      fprintf('\nCartesian position/orientation of end-effector is \n')
      getEEFCartesianPosition( t )
      
%% Get orientation of end effector
      fprintf('\nCartesian orientation of end effector \n')
      getEEFCartesianOrientation( t )
      
%% Get force at end effector
      fprintf('\nCartesian force \n')
      getEEF_Force(t)
      
%% Get moment at end effector
      fprintf('\nmoment at eef \n')
      getEEF_Moment(t)
      
%% Point to point motion in joint space
      
     [ jPos ] = getJointsPos( t ); % get current joints position

      
           
      for ttt=1:7  % home position
          homePos{ttt}=0;
      end
      
      relVel=0.15; % relative over-ride velocity of joints
      movePTPJointSpace( t , homePos, relVel); % go to home position
      movePTPJointSpace( t , jPos, relVel); % return back to initial position
      
%% turn off the server
       net_turnOffServer( t );


       fclose(t);
end
warning('on');

