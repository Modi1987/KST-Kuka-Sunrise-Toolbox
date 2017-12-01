%% Example
% An example script, it is used to show how to use the different
% functions of the KUKA Sunrise matlab toolbox

% First start the server on the KUKA iiwa controller
% Then run the following script in Matlab

% Mohammad SAFEEA, 3rd of May 2017

close all;clear all;clc
warning('off');
ip='172.31.1.147'; % The IP of the controller of the robot
% start a connection with the server
t=net_establishConnection( ip );

if ~exist('t','var') || isempty(t)
  warning('Connection could not be establised, script aborted');
  return;
else
    
%% Turn on blue light
    
      %setBlueOn(t); % turn on blue light
    
      
 %% Move to some initial configuration
    jPos={0,pi*20/180,0,-pi*70/180,0,pi*60/180,0}; % joints angles of initial confuguration
    relVel=0.15; % over-ride relative velocity of joints
    movePTPJointSpace( t , jPos, relVel); % point to point motion in joint space

%% Linear relative motion of end effector, relative to base frame
    deltaX=0;deltaY=0;deltaZ=100.;
    Pos{1}=deltaX;
    Pos{2}=deltaY;
    Pos{3}=deltaZ;

    vel=250; % linear velocity of end effector, mm/sec

    movePTPLineEefRelBase( t , Pos, vel);
    Pos{3}=-deltaZ;
    movePTPLineEefRelBase( t , Pos, vel);

%% Linear relative motion of end effector, relative to EEF frame
    Pos{1}=deltaX;
    Pos{2}=deltaY;
    Pos{3}=deltaZ;

    vel=150; % linear velocity of end effector, mm/sec

    movePTPLineEefRelEef( t , Pos, vel);
    Pos{3}=-deltaZ;
    movePTPLineEefRelEef( t , Pos, vel);

    %setBlueOff(t); % turn off blue light

%% turn off the server
    net_turnOffServer( t );


    fclose(t);
end
    warning('on');
