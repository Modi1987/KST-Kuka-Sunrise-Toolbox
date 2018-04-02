%% Example
% An example script, it is used to show how to use the different
% functions of the KUKA iiwa matlab toolbox
% First start the server on the KUKA iiwa controller
% Then run the following script using Matlab

% Copyright: Mohammad SAFEEA, 3rd of May 2017

% Important: Be careful when runnning the script, be sure that no human, nor obstacles
% are around the robot

close all,clear all,clc
warning('off');
ip='172.31.1.147'; % The IP of the controller
% start a connection with the server
t=net_establishConnection( ip );

if ~exist('t','var') || isempty(t)
  warning('Connection could not be establised, script aborted');
  return;
else
    %% move to initial position
pinit={0,pi*20/180,0,-pi*70/180,0,pi*90/180,0}; % initial confuguration
relVel=0.15; % relative velocity
movePTPJointSpace( t , pinit, relVel); % point to point motion in joint space

    %% Get the joints positions
     [ jPos ] = getJointsPos( t )
    %% Start the direct servo
     realTime_startDirectServoJoints(t);
     scale=4;
     n=60*scale;
     step=pi/(n*12);
     tempoDaEspera=0.001/scale;
     % the following array is the trajectory
     jointAnglesArray=zeros(7,2*n);
     counter=0;
     jVec=zeros(7,1);
     for i=1:n
         jPos{1}=jPos{1}+step;
         %jPos{2}=jPos{2}-step;
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
         jPos{1}=jPos{1}-step;
        % jPos{2}=jPos{2}+step;
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
%% error in here, check for reason
      for tttt=1:10
          getJointsPos( t )
      end

      
     
    %[ linearPos,angularPos ] = kuka3_getEEFPos( t )

    % move along a trajectory using the direct servo function
    
    setBlueOff(t);
    setBlueOn(t);
    pause(3);
    setBlueOff(t);


      %% Play the motion again, from the trajectory
      trajectory=jointAnglesArray;
      delayTime=tempoDaEspera;
      realTime_moveOnPathInJointSpace( t , trajectory,delayTime);
      
     
      %% Get position roientation of end effector
      fprintf('Cartesian position')
      getEEFPos( t )
      
      %% Get position of end effector
      fprintf('Cartesian position')
      getEEFCartesianPosition( t )
      
      %% Get orientation of end effector
      fprintf('Cartesian orientation')
      getEEFCartesianOrientation( t )
      
      %% Get force at end effector
      fprintf('Cartesian force')
      getEEF_Force(t)
      
      %% Get moment at end effector
      fprintf('moment at eef')
      getEEF_Moment(t)
      
      %% PTP motion
      
     [ jPos ] = getJointsPos( t ); % get current joints position

      
           
      for ttt=1:7  % home position
          homePos{ttt}=0;
      end
      
      relVel=0.15;
      movePTPJointSpace( t , homePos, relVel); % go to home position
      movePTPJointSpace( t , jPos, relVel); % return back to original position
      
      %% turn off the server
       net_turnOffServer( t );


       fclose(t);
end
warning('on');

