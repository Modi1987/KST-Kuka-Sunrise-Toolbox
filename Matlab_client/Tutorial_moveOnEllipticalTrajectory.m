%% KUKA sunrise toolbox example.
% moving end-effector of the robot on an ellipse by utilizing the point to
% point elliptical motion functions of the KST

% Copy right: Mohammad SAFEEA
% 30-April-2018

global t_Kuka;
ip='172.31.1.147';
t_Kuka=net_establishConnection(ip);

if ~exist('t_Kuka','var') || isempty(t_Kuka) || strcmp(t_Kuka.Status,'closed')
  disp('Connection could not be establised, script aborted');
  return;
end

%% Go to some initial configuration
disp('moving in joint space to initial configuration');
jPos={0., pi / 180 * 30, 0, -pi / 180 * 60, 0,...
                        pi / 180 * 90, 0};
disp(jPos);
relVel=0.15;
movePTPJointSpace( t_Kuka , jPos, relVel); % move to initial configuration

%% move a little bit back on the X direction
disp('moving -60 mm in the X direction')
deltaX=-60;deltaY=0;deltaZ=0.;
Pos{1}=deltaX;
Pos{2}=deltaY;
Pos{3}=deltaZ;
vel=50;
movePTPLineEefRelBase( t_Kuka , Pos, vel);
   
%% put the pen on the level of the page
disp('moving -85 mm in the Z direction')
deltaX=0;deltaY=0;deltaZ=-85.;
Pos{1}=deltaX;
Pos{2}=deltaY;
Pos{3}=deltaZ;
vel=50;
movePTPLineEefRelBase( t_Kuka , Pos, vel);
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
movePTPEllipse_XY(t_Kuka,c,ratio,theta,velocity,accel,TefTool);

%% Define the ellipse, dimentsions are in (meter)
disp('Drawing an ellipse in a plane parallel to XY axes of the base')
c=[0; 50]; % this is the displacement of the center of the ellipse with respect to the current position of EEF,
% taken in the XZ plane of the robot base 
ratio=0.5; % the radious ratio (a/b) of the ellipse
velocity=40;
accel=25;
theta=2*pi;
TefTool=eye(4);
movePTPEllipse_XZ(t_Kuka,c,ratio,theta,velocity,accel,TefTool);

%% Define the ellipse, dimentsions are in (meter)
disp('Drawing an ellipse in a plane parallel to XY axes of the base')
c=[0; 50]; % this is the displacement of the center of the ellipse with respect to the current position of EEF,
% taken in the YZ plane of the robot base 
ratio=0.5; % the radious ratio (a/b) of the ellipse
velocity=40;
accel=25;
theta=2*pi;
TefTool=eye(4);
movePTPEllipse_YZ(t_Kuka,c,ratio,theta,velocity,accel,TefTool);

net_turnOffServer(t_Kuka);
