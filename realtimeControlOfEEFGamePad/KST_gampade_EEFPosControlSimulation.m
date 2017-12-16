% Copyright Mohammad SAFEEA, 17th-Aug-2017

% Simulation of controlling KUKA iiwa robot using game pad.
% In this script, the code is testsed, a graph showing the joints angles is
% showed to confirm the correctness of the code

clear all;
close all;
clc;
% Start the joystick, make sure that the joystick is connected
instrreset;
ID=1;
joy=vrjoystick(ID);
% Initial configuration
jPos={pi / 180 * 30, pi / 180 * 30, 0, -pi / 180 * 60, 0,...
                        pi / 180 * 90, 0};
% add the KST directory                    
cDir = pwd;
cDir=getTheKSTDirectory(cDir);
addpath(cDir);
% IK solver parameters
numberOfIterations=10;
lambda=0.1;
TefTool=eye(4);

qin=zeros(7,1);
for i=1:7
    qin(i)=jPos{i};
end

[Tt,j]=directKinematics(qin,TefTool); % EEF frame transformation amtrix

% Draw the interface
%[figureHandle,anglesTextHandlesCellArray,labelTextHandlesCellArray]=constructInterface();
% max angular velocity
w=5*pi/180; % rad/sec
% max linear velocity
v=0.05; % m/sec
% Joint space control
firstExecution=0;

% setBackGroundColor(labelTextHandlesCellArray, 1 );
figure();
bufferSize=100;

tempVec=[1:bufferSize];
qVec=zeros(7,bufferSize);

pause(0.1);
% frameUpdateCount=0;
% maxDisp=1*pi/180;
while true
    joyStatus=read(joy);
    % Remove the bias in the analog signal
    analogPrecission=1/20;
    for i=1:4
        if abs( joyStatus(i))<analogPrecission
            joyStatus(i)=0;
        end
    end
    
    % About the variable (joyStatus)
    % joyStatus: is a 4x1 vector, the first and the second elements of this
    % vector correspond to the analog values of the left analog-stick
    % psoition. the third and the fourth elements of this
    % vector correspond to the analog values of the right analog-stick
    % psoition. 
    % 
    % Only the seconds and the third elements of this vector are used for
    % controlling the joints motion of the robot one at a time.
    %
    % The 2d element is used to select the robot axes, this element corresponds
    % to the (up,down) directions of the left analog stick of the gamepad.
    % 
    % The 3rd element is used to control the motion of the selcted axes,
    % this element corresponds to the (right, left) directions of the right
    % analog stick of the gamepad.
    
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
 % Construct motion control command
     n=[joyStatus(3);
         joyStatus(4);
         0];
     k=[0;0;1];
     w_control=w*cross(n,k);
     v_control=v*[joyStatus(1);
         joyStatus(2);
         0];
% Calculate target transform using command, and current transform
     Tt=updateTransform(Tt,w_control,v_control,dt);
     
     qt=kukaDLSSolver( qin, Tt, TefTool,numberOfIterations,lambda );

     flag=jointLimitReached(qt);
     if flag==true;
         qt=qin;
     end
    
     % A condition to break the loop, when x button of the gamepad is
     % pressed
     b=button(joy,1);
     if(b==1)
         break;
     end
        
        qVec(:,1)=[];
        qVec=[qVec,columnVec(qt)];
        plot(tempVec,qVec);
        pause(0.001)
end

