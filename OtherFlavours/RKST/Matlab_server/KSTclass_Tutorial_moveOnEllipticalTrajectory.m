%% Example of using KST class for interfacing with KUKA iiwa robots

% Moving end-effector of the robot on an ellipse by utilizing the point to
% point elliptical motion functions of the KST


% be careful when runnning the script, be sure that no human, nor obstacles
% are around the robot

% This example works with Sunrise application version KST_1.7  and higher.
% Copyright Mohammad SAFEEA, 26th-June-2018

close all;clear;clc;
warning('off')
%% Create the robot object
ip='172.31.1.147'; % The IP of the controller
arg1=KST.LBR7R800; % choose the robot iiwa7R800 or iiwa14R820
arg2=KST.Medien_Flansch_elektrisch; % choose the type of flange
Tef_flange=eye(4); % transofrm matrix of EEF with respect to flange
iiwa=KST(ip,arg1,arg2,Tef_flange); % create the object

%% Start a connection with the server
flag=iiwa.net_establishConnection();
if flag==0
    return;
end
pause(1);
disp('Doing some stuff')

%% Go to some initial configuration
disp('moving in joint space to initial configuration');
jPos={0., pi / 180 * 30, 0, -pi / 180 * 60, 0,...
                        pi / 180 * 90, 0};
disp(jPos);
relVel=0.15;
iiwa.movePTPJointSpace(jPos, relVel); % move to initial configuration

%% move a little bit back on the X direction
disp('moving -60 mm in the X direction')
deltaX=-60;deltaY=0;deltaZ=0.;
Pos{1}=deltaX;
Pos{2}=deltaY;
Pos{3}=deltaZ;
vel=50;
iiwa.movePTPLineEefRelBase(Pos, vel);
   
%% put the pen on the level of the page
disp('moving -85 mm in the Z direction')
deltaX=0;deltaY=0;deltaZ=-85.;
Pos{1}=deltaX;
Pos{2}=deltaY;
Pos{3}=deltaZ;
vel=50;
iiwa.movePTPLineEefRelBase(Pos, vel);
pause(1);
 
%% Define the ellipse,
disp('Drawing an ellipse in a plane parallel to XY axes of the base')
c=[0; 50]; % this is the displacement of the center of the ellipse with respect to the current position of EEF,
% taken in the XY plane of the robot base 
ratio=0.5; % the radious ratio (a/b) of the ellipse
velocity=40;
accel=25;
theta=2*pi;
TefTool=eye(4);
iiwa.movePTPEllipse_XY(c,ratio,theta,velocity,accel,TefTool);

%% Define the ellipse, dimentsions are in (meter)
disp('Drawing an ellipse in a plane parallel to XY axes of the base')
c=[0; 50]; % this is the displacement of the center of the ellipse with respect to the current position of EEF,
% taken in the XZ plane of the robot base 
ratio=0.5; % the radious ratio (a/b) of the ellipse
velocity=40;
accel=25;
theta=2*pi;
TefTool=eye(4);
iiwa.movePTPEllipse_XZ(c,ratio,theta,velocity,accel,TefTool);

%% Define the ellipse, dimentsions are in (meter)
disp('Drawing an ellipse in a plane parallel to XY axes of the base')
c=[0; 50]; % this is the displacement of the center of the ellipse with respect to the current position of EEF,
% taken in the YZ plane of the robot base 
ratio=0.5; % the radious ratio (a/b) of the ellipse
velocity=40;
accel=25;
theta=2*pi;
TefTool=eye(4);
iiwa.movePTPEllipse_YZ(c,ratio,theta,velocity,accel,TefTool);

iiwa.net_turnOffServer();
