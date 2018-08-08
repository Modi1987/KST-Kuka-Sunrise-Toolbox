%% Example of using KST class for interfacing with KUKA iiwa robots
% This example script is used to show how to utilise the arcs
% functions integrated into the class KST of the KUKA Sunrise Toolbox

% First start the server on the KUKA iiwa controller
% Then run the following script in Matlab
% Note you have 60 seconds to connect to server after starting the
% application (MatlabToolboxServer) from the smart-pad on the robot controller.

% This example works with Sunrise application version KST_1.7  and higher.
% Copyright Mohammad SAFEEA, 8th-August-2018

close all;clear;clc;
warning('off')
%% Create the robot object
ip='172.31.1.147'; % The IP of the controller
arg1=KST.LBR7R800; % choose the robot iiwa7R800 or iiwa14R820
arg2=KST.Medien_Flansch_elektrisch; % choose the type of flange
Tef_flange=eye(4); % transofrm matrix of EEF with respect to flange.
Tef_flange(3,4)=30/1000;
iiwa=KST(ip,arg1,arg2,Tef_flange); % create the object

%% Start a connection with the server
flag=iiwa.net_establishConnection();
if flag==0
  return;
end
pause(1);
disp('Moving in circles')

%% Go to initial configuration
relVel=0.25; % over ride relative joint velocities

pos={0, -pi / 180 * 10, 0, -pi / 180 * 100, pi / 180 * 90,pi / 180 * 90, 0};   % initial cofiguration

iiwa.movePTPJointSpace( pos, relVel); % go to initial position
%% Move in an arc, the orientation of EEF changes while performing the motion,
% The function utilized (movePTPCirc1OrintationInter)
% f2 is the final frame, at which the arc motion ends
% f1 is an intermidiate frame, through wich the robot passes while
% performing the motion.

f1=iiwa.getEEFPos();
f2=f1;
r=75; % radius of arc
f1{2}=f1{2}+r;
f1{3}=f1{3}-r;
f1{6}=f1{6}+pi/8;

f2{3}=f2{3}-2*r;
f2{6}=f2{6}+pi/2;

vel=150; % linear velocity of end-effector mm/sec
iiwa.movePTPCirc1OrintationInter( f1,f2, vel)

%% Move robot in joint space to some initial configuration
pinit={0,pi*20/180,0,-pi*70/180,0,pi*90/180,0}; % joint angles of initial confuguration
relVel=0.15; % the relative velocity
iiwa.movePTPJointSpace(pinit, relVel); % point to point motion in joint space

%% Move EEF -100 mm in Z direction
deltaX=0.0;deltaY=0;deltaZ=-100.; % relative displacemnets of end-effector
Pos{1}=deltaX;
Pos{2}=deltaY;
Pos{3}=deltaZ;
iiwa.movePTPLineEefRelBase(Pos, vel);

%% Store the current position in the memory
Cen=iiwa.getEEFPos(); % Concider the current position as the center of the arcs

%% Move EEF 50mm in X direction
deltaX=100;deltaY=0;deltaZ=0.;
Pos{1}=deltaX;
Pos{2}=deltaY;
Pos{3}=deltaZ;
iiwa.movePTPLineEefRelBase(Pos, vel);
%% Store the current position in the memory
circle_Starting_Point=iiwa.getEEFPos(); % Consider the current point as circle starting point

%% Move in an arc, the arc is drawn on an incliend plane
% using the function ((movePTPArc_AC))
theta=pi/2; % the angle subtended by the arc at the center ((c))
k=[1;1;1]; % normal vector of the plane, on which the circle is drawn
c=[Cen{1};Cen{2};Cen{3}]; % the center of the arc
vel=100; % the motion velocity mm/sec
iiwa.movePTPArc_AC(theta,c,k,vel)
      
%% Go back to ((circle_Starting_Point)) coordinates
vel=150;
iiwa.movePTPLineEEF(circle_Starting_Point, vel);
%% Move in an arc, the arc is drawn in XY plane
% using the function ((movePTPArcXY_AC))
theta=1.98*pi; % the angle subtended by the arc at the center ((c))
c=[Cen{1};Cen{2}]; % the XY coordinate of the center of the arc
vel=150; % the motion velocity mm/sec
iiwa.movePTPArcXY_AC(theta,c,vel)

%% turn off the server
iiwa.net_turnOffServer();
warning('on')