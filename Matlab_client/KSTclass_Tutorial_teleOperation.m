%% Example of using KST class for interfacing with KUKA iiwa robots

% Controlling KUKA iiwa robot using 3D mouse.

% Important note: when operating the robot with 3D mouse
% do not drive the robot near joints limits
% or near work space limits, the author is not liable for any sort of
% injury or loss of property due to the use of the provided programs.

% This example works with Sunrise application version KST_1.7  and higher.
% Copyright Mohammad SAFEEA, 26th-June-2018

close all;clear;clc;
instrreset;
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
disp('Control iiwa using 3D mouse')
disp('Do not move the robot near joint limits')
disp('Do not move the robot near work space limits')

% Initial configuration
jPos={0.0, pi / 180 * 30, 0, -pi / 180 * 60, 0,...
                    pi / 180 * 90, 0};
relVel=0.15;
iiwa.movePTPJointSpace(jPos, relVel); % move to initial configuration

% Start direct servo in joint space       
iiwa.realTime_startDirectServoJoints();

% IK solver parameters
numberOfIterations=10;
lambda=0.1;
%% Tool transform matrix
TefTool=eye(4);
TefTool(1,4)=0.0;
TefTool(2,4)=0.0;
TefTool(3,4)=0.04;

%% initial configuration vector
qin=zeros(7,1);
daINDEX=0;
for i=1:7
qin(i)=jPos{i};
end

%% setup the mouse
% setup the mouse, normally it should be in USB1
ID = 'USB1';
MOUSE = [];
try
% try to create the space mouse object MOUSE
MOUSE = vrspacemouse(ID);
catch ME
fprintf('Unable to initialize the Space Mouse on port %s.\n', ID);
end

MOUSE.PositionSensitivity = 1e-2*10;
MOUSE.RotationSensitivity = 1e-5*10000;
vector = [1;2;3;4;5;6];

%% Variables Initiation
[Tt,j]=iiwa.directKinematics(qin); % EEF frame transformation amtrix
filterVar=0.2;
v_control=zeros(3,1);
w_control=zeros(3,1);
firstExecution=0;
linearVelocityScale=4500;
angularVelocityScale=4000;
% Transform the measurments, change it accouding to your own 3D mouse
% configuration
darV=[1 0 0;
0 -1 0;
0 0 -1];

darW=[0 -1 0;
1 0 0;
0 0 0];

pause(0.1);


disp('Control is activeted');
disp('Use space mouse to control the robot');
%% Control loop
while true

% Calculate the elapsed time
if(firstExecution==0)
    firstExecution=1;
    a=datevec(now);
    timeNow=a(6)+a(5)*60+a(4)*60*60; % calculate time at this instant
    dt=0; % elapsed is zero at first excution
    time0=timeNow;
else
    a=datevec(now);
    timeNow=a(6)+a(5)*60+a(4)*60*60; % calculate time at this instant
    dt=timeNow-time0; % calculate elapsed time interval
    time0=timeNow;
end

% Read input data from mouse
 mouseSpeed = speed(MOUSE, vector);

%% Calculate the cartesian motion command 
%------------------------------------------------------------------------
normalizedAngularMotionInput=[mouseSpeed(4);
     mouseSpeed(5);
     mouseSpeed(6)]/angularVelocityScale; % normalized angular motion command,
% calculated from mouse measurments
normalizedLinearMotionInput=[mouseSpeed(1); 
    mouseSpeed(2); 
    mouseSpeed(3)]/linearVelocityScale;% normalized linear motion command,
% calculated from mouse measurments

w_control=filterVar*w_control+(1-filterVar)*darV*normalizedAngularMotionInput;
v_control=filterVar*v_control+(1-filterVar)*darV*normalizedLinearMotionInput;

% Calculate target transform using command, and current transform
[Tt,notImportant]=iiwa.directKinematics(qin);
Tt=updateTransform2(Tt,w_control,v_control,dt);

qt= iiwa.gen_InverseKinematics(qin, Tt,numberOfIterations,lambda );
% A condition to break the loop, when first space mouse button is
% pressed
if button(MOUSE, 1) == 1
    break;
end

for i=1:7
    jPos{i}=qt(i);
end
%% Send reference joints to robot
iiwa.sendJointsPositions(jPos);
%% update initial positions, target transform
qin=qt;
end

%% Turn off the direct servo
iiwa.realTime_stopDirectServoJoints();

%% turn Off blue light
iiwa.net_turnOffServer();

