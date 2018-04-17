%% Example
% An example script, it is used to show how to use the arcs
% functions of the KUKA iiwa matlab toolbox
% First start the server on the KUKA iiwa controller
% Then run the following script in Matlab

% Note you have 60 seconds to connect to server after starting the
% application (MatlabToolboxServer) from the smart pad on the robot controller.

% Mohammad SAFEEA, 3rd of May 2017

close all,clear all;clc;
warning('off');
ip='172.31.1.147'; % The IP of the controller
% start a connection with the server
global t_Kuka;
t_Kuka=net_establishConnection( ip );

if ~exist('t_Kuka','var') || isempty(t_Kuka) || strcmp(t_Kuka.Status,'closed')
  warning('Connection could not be establised, script aborted');
  return;
else


      %% Go to initial configuration
      relVel=0.25; % over ride relative joint velocities
      
      pos={0, -pi / 180 * 10, 0, -pi / 180 * 100, pi / 180 * 90,pi / 180 * 90, 0};   % initial cofiguration

      movePTPJointSpace( t_Kuka , pos, relVel); % go to home position
      %% Move in an arc, the orientation of EEF changes while performing the motion,
      % The function utilized (movePTPCirc1OrintationInter)
      % f2 is the final frame, at which the arc motion ends
      % f1 is an intermidiate frame, through wich the robot passes while
      % performing the motion.
      
      f1=getEEFPos( t_Kuka );
      f2=f1;
      r=75;
      f1{2}=f1{2}+r;
      f1{3}=f1{3}-r;
      f1{6}=f1{6}+pi/8;
      
      f2{3}=f2{3}-2*r;
      f2{6}=f2{6}+pi/2;
      
      vel=150; % linear velocity of end-effector mm/sec
      movePTPCirc1OrintationInter( t_Kuka , f1,f2, vel)
      
          %% Move robot in joint space to some initial configuration
pinit={0,pi*20/180,0,-pi*70/180,0,pi*90/180,0}; % joint angles of initial confuguration
relVel=0.15; % the relative velocity
movePTPJointSpace( t_Kuka , pinit, relVel); % point to point motion in joint space

%% Move EEF -100 mm in Z direction
deltaX=0.0;deltaY=0;deltaZ=-100.; % relative displacemnets of end-effector
Pos{1}=deltaX;
Pos{2}=deltaY;
Pos{3}=deltaZ;
movePTPLineEefRelBase( t_Kuka , Pos, vel);

%% Store the current position in the memory
Cen=getEEFPos(t_Kuka); % Concider the current position as the center of the arcs

%% Move EEF 50mm in X direction
deltaX=100;deltaY=0;deltaZ=0.;
Pos{1}=deltaX;
Pos{2}=deltaY;
Pos{3}=deltaZ;
movePTPLineEefRelBase( t_Kuka , Pos, vel);
%% Store the current position in the memory
circle_Starting_Point=getEEFPos( t_Kuka ); % Consider the current point as circle starting point

%% Move in an arc, the arc is drawn on an incliend plane
% using the function ((movePTPArc_AC))
theta=pi/2; % the angle subtended by the arc at the center ((c))
k=[1;1;1]; % normal vector of the plane, on which the circle is drawn
c=[Cen{1};Cen{2};Cen{3}]; % the center of the arc
vel=100; % the motion velocity mm/sec
movePTPArc_AC(t_Kuka,theta,c,k,vel)
      
%% Go back to ((circle_Starting_Point)) coordinates
vel=150;
movePTPLineEEF( t_Kuka , circle_Starting_Point, vel);
%% Move in an arc, the arc is drawn in XY plane
% using the function ((movePTPArcXY_AC))
theta=1.98*pi; % the angle subtended by the arc at the center ((c))
c=[Cen{1};Cen{2}]; % the XY coordinate of the center of the arc
vel=150; % the motion velocity mm/sec
movePTPArcXY_AC(t_Kuka,theta,c,vel)

      %% turn off the server
       net_turnOffServer( t_Kuka );


       fclose(t_Kuka);
end

warning('on');