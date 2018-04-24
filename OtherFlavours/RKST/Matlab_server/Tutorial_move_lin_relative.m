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
    
      %% Get position roientation of end effector
    
      setBlueOn(t_Kuka); % turn on blue light
    
      
          %% move to initial position
jPos={0,pi*20/180,0,-pi*70/180,0,pi*60/180,0}; % initial confuguration
relVel=0.15; % relative velocity
movePTPJointSpace( t_Kuka , jPos, relVel); % point to point motion in joint space

%% Linear relative motion of end effector, relative to base frame
deltaX=0;deltaY=0;deltaZ=100.;
Pos{1}=deltaX;
Pos{2}=deltaY;
Pos{3}=deltaZ;

vel=250; % linear velocity of end effector, mm/sec

movePTPLineEefRelBase( t_Kuka , Pos, vel);
Pos{3}=-deltaZ;
movePTPLineEefRelBase( t_Kuka , Pos, vel);

%% Linear relative motion of end effector, relative to EEF frame
Pos{1}=deltaX;
Pos{2}=deltaY;
Pos{3}=deltaZ;

vel=150; % linear velocity of end effector, mm/sec

movePTPLineEefRelEef( t_Kuka , Pos, vel);
Pos{3}=-deltaZ;
movePTPLineEefRelEef( t_Kuka , Pos, vel);
  
setBlueOff(t_Kuka); % turn off blue light

      %% turn off the server
       net_turnOffServer( t_Kuka );


       fclose(t_Kuka);
end
warning('on');
