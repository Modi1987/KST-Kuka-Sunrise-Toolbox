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

      %% Get position roientation of end effector
      disp('Cartesian position')
      Pos=getEEFPos( t_Kuka )
      
      relVel=50; % velocity of the end effector, mm/sec
      
      disp=50;
      %% Move the endeffector in the X direction
      index=1;
      Pos{index}=Pos{index}+disp;
      
       movePTPLineEEF( t_Kuka , Pos, relVel)
      pause(0.1)
      Pos{index}=Pos{index}-disp;
      
      movePTPLineEEF( t_Kuka , Pos, relVel)
      
      %% Move the endeffector in the z direction
 
       index=3;
      Pos{index}=Pos{index}+disp;
      
       movePTPLineEEF( t_Kuka , Pos, relVel)
       pause(0.1)
       Pos{index}=Pos{index}-disp;
      
      movePTPLineEEF( t_Kuka , Pos, relVel)
  
      %% Move the endeffector to a distination frame, 
      
       Pos={400,0,580,-pi,0,-pi}; % first configuration
       % the coordinates are:
       % x=400mm, y=0mm, z=580 mm.
       % the rotation angles are:
       % alpha=-180 degrees, beta=0 degrees, gama=-180 degrees
      
       movePTPLineEEF( t_Kuka , Pos, relVel)
       
       Pos={500,0,580,-pi,0,-pi+pi/4}; %% second configuration
       % the coordinates are:
       % x=400mm, y=0mm, z=580 mm.
       % the rotation angles are:
       % alpha=-180 degrees, beta=0 degrees, gama=-165 degrees, 
       setBlueOn(t_Kuka);
       movePTPLineEEF( t_Kuka , Pos, relVel)
       setBlueOff(t_Kuka);
      %% turn off the server
       net_turnOffServer( t_Kuka );


       fclose(t_Kuka);
end
warning('on');
