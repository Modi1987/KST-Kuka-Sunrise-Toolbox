function kuka0_motions(t)
%% move to initial position
pinit={0,pi*20/180,0,-pi*70/180,0,pi*90/180,0}; % initial confuguration
relVel=0.15; % relative velocity
movePTPJointSpace( t , pinit, relVel); % point to point motion in joint space
    %% Get the joints positions
      jPos  = getJointsPos( t )
    %% Start the direct servo
     realTime_startDirectServoJoints(t);
     scale=4;
     n=100*scale;
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
         %jPos{2}=jPos{2}+step;
         sendJointsPositions( t ,jPos);
         pause(tempoDaEspera);
         % Generate the trajectory
         counter=counter+1;
         for tt=1:7
             jVec(tt)=jPos{tt};
         end
         jointAnglesArray(:,counter)=jVec;
      end
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
      fprintf('Cartesian position and orientation');
      getEEFPos( t )
      
      %% Get position of end effector
      fprintf('Cartesian position');
      getEEFCartesianPosition( t )
      
      %% Get orientation of end effector
      fprintf('Cartesian orientation');
      getEEFCartesianOrientation( t )
      
      %% Get force at end effector
      fprintf('Cartesian force');
      getEEF_Force(t)
      
      %% Get moment at end effector
      fprintf('moment at eef');
      getEEF_Moment(t)
      
      %% PTP motion
      
     [ jPos ] = getJointsPos( t ); % get current joints position

      
           
      for ttt=1:7  % home position
          homePos{ttt}=0;
      end
      
      relVel=0.15;
      movePTPJointSpace( t , homePos, relVel); % go to home position
      movePTPJointSpace( t , jPos, relVel); % return back to original position
      
      
            %% Get position roientation of end effector
      fprintf('Cartesian position');
      Pos=getEEFPos( t )
      
      relVel=150; % velocity of the end effector, mm/sec
      
      disp=50;
      %% Move the endeffector in the X direction
      index=1;
      Pos{index}=Pos{index}+disp;
      
       movePTPLineEEF( t , Pos, relVel)
pause(0.1)
      Pos{index}=Pos{index}-disp;
      
      movePTPLineEEF( t , Pos, relVel)
      
      %% Move the endeffector in the z direction
 
       index=3;
      Pos{index}=Pos{index}+disp;
      
       movePTPLineEEF( t , Pos, relVel)
pause(0.1)
      Pos{index}=Pos{index}-disp;
      
      movePTPLineEEF( t , Pos, relVel)
end