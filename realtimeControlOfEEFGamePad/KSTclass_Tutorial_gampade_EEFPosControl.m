%% Example of using KST class for interfacing with KUKA iiwa robots

% Using the gamepad for controlling the end-effector of the KUKA
% iiwa 7 R 800 robot.

% 1- Left joystick of the game pad is used to control the X-Y motion of the end effector. 
%   a- Move the left joystick right and left to move the end-effector along the X axes. 
%   b- Move the left joystick up or down to move the end-effector along the Y axes. 
%   c- Combination is used to move the end-effector along X and Y
%   simultaneously
% ------------------------------------- 
% 2- Right joystick of the game pad is used to control the orientation of the end effector around the X and the Y axes. 
%   a- Move the right joystick right and left to rotate the end-effector around the X axes. 
%   b- Move the right joystick up or down to rotate the end-effector around the Y axes.
%   c- Combination is used to rotate the end-effector around X and Y
%   simultaneously
% -------------------------------------

% Warning: keep away from joint limits, and singularities they are not
% yet taken into consideratio.
% The Toolbox is a work in progress, other functionalities are going to be
% added with time.

% This example works with Sunrise application version KST_1.7  and higher.
% Copyright: Mohammad SAFEEA, 25th of June 2018

close all;clear;clc;
warning('off')
% Start the joystick, make sure that the joystick is connected
instrreset;
ID=1;
joy=vrjoystick(ID);
%% Add path of KST class to work space
cDir = pwd;
cDir=getTheKSTDirectory(cDir);
addpath(cDir);

%% Instantiate the KST object
ip='172.31.1.147'; % The IP of the controller
arg1=KST.LBR7R800; % choose the robot iiwa7R800 or iiwa14R820
arg2=KST.Medien_Flansch_elektrisch; % choose the type of flange
Tef_flange=eye(4); % transofrm matrix of EEF with respect to flange
iiwa=KST(ip,arg1,arg2,Tef_flange); % create the object

%% Start a connection with the server
flag=iiwa.net_establishConnection();
if flag==0
	fprintf('Can not connect to KST \n');
    fprintf('Program terminated \n');
    return;
end

% Initial configuration
jPos={0, pi / 180 * 30, 0, -pi / 180 * 60, 0,...
                        pi / 180 * 90, 0};
% Move robot to initial configuration
relVel=0.15;
iiwa.movePTPJointSpace(jPos, relVel); % move to initial configuration
 
% Start direct servo in joint space       
iiwa.realTime_startDirectServoJoints();

% IK solver parameters
numberOfIterations=10;
lambda=0.1;
TefTool=eye(4);

% Initial configuration vector
qin=zeros(7,1);
for i=1:7
    qin(i)=jPos{i};
end

% Ttransformation matrix at initial configurarion
[Tt,j]=iiwa.directKinematics(qin); 


% max angular velocity, at which the end-effector can rotate.
w=5*pi/180; % rad/sec
% max linear velocity, at which the end-effector can move.
v=0.05; % m/sec
% Joint space control
firstExecution=0;

pause(0.1);

% filtering buffer, value
c=0.9;
joyStatus=read(joy);
filter=zeros(size(joyStatus));

% Control loop
while true
    joyStatus=read(joy);
    % Remove the bias in the input analog signal
    analogPrecission=1/20;
    for i=1:4
        if abs( joyStatus(i))<analogPrecission
            joyStatus(i)=0;
        end
    end
    filter=c*filter+(1-c)*joyStatus;
    joyStatus=filter;
    
    % About the variable (joyStatus)
    % joyStatus: is a 4x1 vector, the first and the second elements of this
    % vector correspond to the analog values of the left analog-stick
    % psoition. the third and the fourth elements of this
    % vector correspond to the analog values of the right analog-stick
    % psoition. 
    % 
    % All foour elemets of the analog signal of the vector  (joyStatus) are used for
    % controlling the end-effector.
    %
    
    % Calculate the elapsed time between updates
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
 % Construct motion control command
     n=[joyStatus(4);
         joyStatus(3);
         0];
     k=[0;0;1];
     w_control=w*cross(n,k);
     v_control=v*[joyStatus(2);
         joyStatus(1);
         0];
% Calculate target transform using command, and current transform
     Tt=updateTransform(Tt,w_control,v_control,dt);

     for i=1:7
         qin(i)=jPos{i};
     end
     
      qt=kukaDLSSolver( qin, Tt, TefTool,numberOfIterations,lambda );
      
      if(size(qt)==[7,1])
          errorFlag=false;
          for i=1:7
              if abs(qt(i)-qin(i))>pi*0.5/180
                  errorFlag=true;
              end
          end
      % check joints limits
     qt=iiwa.gen_InverseKinematics( qin, Tt,numberOfIterations,lambda );
     flag=jointLimitReached(qt);
     % if the motion causes joint limit violation, stay in the current configuration
     if flag==true;
         qt=qin;
     end
     
          if errorFlag==false
              for i=1:7
                  jPos{i}=qt(i);
              end
          end
      end
      iiwa.sendJointsPositions(jPos);

    
     % A condition to break the loop, when x button of the gamepad is
     % pressed
     b=button(joy,1);
     if(b==1)
         break;
     end
       
end
% turn off the server
% close connection
iiwa.net_turnOffServer();

    
