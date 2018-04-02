%% Example
% An example script, it is used to show how to use the different
% functions of the KUKA iiwa matlab toolbox

% First start the server on the KUKA iiwa controller
% Then run the following script in Matlab

% Mohammad SAFEEA, 3rd of May 2017

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

      %% Get position roientation of end effector
      disp('Cartesian position')
      Pos=getEEFPos( t )
      
      relVel=50; % velocity of the end effector, mm/sec
      
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
  
      %% Move the endeffector to a distination frame, 
      
       Pos={400,0,580,-pi,0,-pi}; % first configuration
       % the coordinates are:
       % x=400mm, y=0mm, z=580 mm.
       % the rotation angles are:
       % alpha=-180 degrees, beta=0 degrees, gama=-180 degrees
      
       movePTPLineEEF( t , Pos, relVel)
       
       Pos={500,0,580,-pi,0,-pi+pi/4}; %% second configuration
       % the coordinates are:
       % x=400mm, y=0mm, z=580 mm.
       % the rotation angles are:
       % alpha=-180 degrees, beta=0 degrees, gama=-165 degrees, 
       setBlueOn(t);
       movePTPLineEEF( t , Pos, relVel)
       setBlueOff(t);
      %% turn off the server
       net_turnOffServer( t );


       fclose(t);
end
warning('on');
