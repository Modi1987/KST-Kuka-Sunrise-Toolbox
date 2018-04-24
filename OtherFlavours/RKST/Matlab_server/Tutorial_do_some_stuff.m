%% Example
% An example script, it is used to show how to use the different
% functions of the KUKA iiwa matlab toolbox

% First run the following script in Matlab
% Then start the client on the KUKA iiwa controller

% Mohammad SAFEEA, 24th of April 2018

close all,clear all,clc
warning('off');
ip='172.31.1.147'; % The IP of the controller
% start a connection with the server
t_Kuka=net_establishConnection( ip );

if ~exist('t_Kuka','var') || isempty(t_Kuka) || strcmp(t_Kuka.Status,'closed')
  warning('Connection could not be establised, script aborted');
  return;
else
    %% move to initial position
pinit={0,pi*20/180,0,-pi*70/180,0,pi*90/180,0}; % initial confuguration
relVel=0.15; % relative velocity
movePTPJointSpace( t_Kuka , pinit, relVel); % point to point motion in joint space

    %% Get the joints positions
     [ jPos ] = getJointsPos( t_Kuka )
    %% Start the direct servo
     realTime_startDirectServoJoints(t_Kuka);
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
         sendJointsPositions( t_Kuka ,jPos);
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
         sendJointsPositions( t_Kuka ,jPos);
         pause(tempoDaEspera);
         % Generate the trajectory
         counter=counter+1;
         for tt=1:7
             jVec(tt)=jPos{tt};
         end
         jointAnglesArray(:,counter)=jVec;
      end
      pause(1);
      realTime_stopDirectServoJoints( t_Kuka );
%% error in here, check for reason
      for tttt=1:10
          getJointsPos( t_Kuka )
      end

      
     
    %[ linearPos,angularPos ] = kuka3_getEEFPos( t )

    % move along a trajectory using the direct servo function
    
    setBlueOff(t_Kuka);
    setBlueOn(t_Kuka);
    pause(3);
    setBlueOff(t_Kuka);


      %% Play the motion again, from the trajectory
      trajectory=jointAnglesArray;
      delayTime=tempoDaEspera;
      realTime_moveOnPathInJointSpace( t_Kuka , trajectory,delayTime);
      
     
      %% Get position roientation of end effector
      fprintf('Cartesian position')
      getEEFPos( t_Kuka )
      
      %% Get position of end effector
      fprintf('Cartesian position')
      getEEFCartesianPosition( t_Kuka )
      
      %% Get orientation of end effector
      fprintf('Cartesian orientation')
      getEEFCartesianOrientation( t_Kuka )
      
      %% Get force at end effector
      fprintf('Cartesian force')
      getEEF_Force(t_Kuka)
      
      %% Get moment at end effector
      fprintf('moment at eef')
      getEEF_Moment(t_Kuka)
      
      %% PTP motion
      
     [ jPos ] = getJointsPos( t_Kuka ); % get current joints position

      
           
      for ttt=1:7  % home position
          homePos{ttt}=0;
      end
      
      relVel=0.15;
      movePTPJointSpace( t_Kuka , homePos, relVel); % go to home position
      movePTPJointSpace( t_Kuka , jPos, relVel); % return back to original position
      
      %% turn off the server
       net_turnOffServer( t_Kuka );


       fclose(t_Kuka);
end
warning('on');

