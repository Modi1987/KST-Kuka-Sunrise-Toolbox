% Copyright Mohammad SAFEEA, 2nd-May-2018

% Controlling KUKA iiwa robot using 3D mouse.

% Important note: when operating the robot with 3D mouse
% do not drive the robot near joints limits
% or near work space limits

clear all;
close all;
clc;
instrreset;

%% Start the KST, move robot to initial configuration, start directServo function
ip='172.31.1.147'; % The IP of the controller
% start a connection with the server
global t_Kuka;
t_Kuka=net_establishConnection( ip );

if ~exist('t_Kuka','var') || isempty(t_Kuka) || strcmp(t_Kuka.Status,'closed')
  disp('Connection could not be establised, script aborted');
  return;
else
    disp('Connection established')
end
setBlueOn(t_Kuka); % turn on blue light
% Initial configuration
jPos={0.0, pi / 180 * 30, 0, -pi / 180 * 60, 0,...
                        pi / 180 * 90, 0};
relVel=0.15;
movePTPJointSpace( t_Kuka , jPos, relVel); % move to initial configuration
 
% Start direct servo in joint space       
realTime_startDirectServoJoints(t_Kuka);

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
[Tt,j]=directKinematics(qin,TefTool); % EEF frame transformation amtrix
filterVar=0.2;
v_control=zeros(3,1);
w_control=zeros(3,1);
firstExecution=0;
linearVelocityScale=4500;
angularVelocityScale=4000;
% Transform the measurment, change it accouding to your own 3D mouse
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
     [Tt,notImportant]=directKinematics(qin,TefTool);
     Tt=updateTransform2(Tt,w_control,v_control,dt);
     
     qt=kukaDLSSolver( qin, Tt, TefTool,numberOfIterations,lambda );
  
    % A condition to break the loop, when first space mouse button is
    % pressed
    if button(MOUSE, 1) == 1
        break;
    end
        
    for i=1:7
        jPos{i}=qt(i);
    end
    %% Send reference joints to robot
    sendJointsPositions( t_Kuka ,jPos);
    %% update initial positions, target transform
    qin=qt;
 
end
%% Turn off the direct servo
realTime_stopDirectServoJoints(t_Kuka);
%% turn Off blue light
setBlueOff(t_Kuka); 
% turn off the server
% close connection
net_turnOffServer( t_Kuka );
fclose(t_Kuka);

close all;
