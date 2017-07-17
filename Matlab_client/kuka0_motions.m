function kuka0_motions(t)
%% move to initial position
pinit={0,pi*20/180,0,-pi*70/180,0,pi*90/180,0}; % initial confuguration
relVel=0.15; % over-riderelative velocity of joints
movePTPJointSpace( t , pinit, relVel); % point to point motion in joint space
    %% Get the joints positions
      jPos  = getJointsPos( t );
      fprintf('\n joints positions of the robot are: \n')
      jPos
    %% Start the direct servo, and move the first joint of the robot in realtime.
     realTime_startDirectServoJoints(t);
     scale=4;
     n=100*scale;
     step=pi/(n*12);
     tempoDaEspera=0.001/scale;
     % The array ((jointAnglesArray)): is an array of the motion trajectory in joint space
     jointAnglesArray=zeros(7,2*n);
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
%% Read joints positions
      for tttt=1:10
          getJointsPos( t )
      end

%% Flash the blue light of the robot
    
    setBlueOff(t);
    setBlueOn(t);
    pause(3);
    setBlueOff(t);


      %% Play the motion again, from the previously generated trajectory
      trajectory=jointAnglesArray;
      delayTime=tempoDaEspera;
      realTime_moveOnPathInJointSpace( t , trajectory,delayTime);

      

      
      %% Get position/orientation of end effector
      fprintf('\nCartesian position and orientation \n');
      getEEFPos( t )
      
      %% Get position of end effector
      fprintf('\nCartesian position \n');
      getEEFCartesianPosition( t )
      
      %% Get orientation of end effector
      fprintf('\nCartesian orientation \n');
      getEEFCartesianOrientation( t )
      
      %% Get force at end effector
      fprintf('\nCartesian force \n');
      getEEF_Force(t)
      
      %% Get moment at end effector
      fprintf('\nmoment at EEF \n');
      getEEF_Moment(t)
      
      %% PTP motion
      
     [ jPos ] = getJointsPos( t ); % get current joints position

      
           
      for ttt=1:7  % home position
          homePos{ttt}=0;
      end
      
      relVel=0.15; % over-ride relative velocity of joints
      movePTPJointSpace( t , homePos, relVel); % go to home position
      movePTPJointSpace( t , jPos, relVel); % return back to original position
      
      
%% Get position orientation of end effector
      fprintf('Cartesian position');
      Pos=getEEFPos( t )

%% Move the endeffector in the X direction
      disp=50; % displacement mm
      index=1;
      Pos{index}=Pos{index}+disp;
      relVel=150; % velocity of the end effector, mm/sec      
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