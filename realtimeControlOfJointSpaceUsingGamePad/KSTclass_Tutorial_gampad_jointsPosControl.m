%% Example of using KST class for interfacing with KUKA iiwa robots

% Using the gamepad for controlling the joints positions of KUKA
% iiwa 7 R 800 robot.
% This script implements a graphical user interface, which gives a feedback
% about the position of the joints' angles.

% This example works with Sunrise application version KST_1.7  and higher.
% Copyright: Mohammad SAFEEA, 29th of June 2018

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

%% Move robot to some initial position   
jPos={0,0,0,0,0,0,0};
relVel=0.15;
iiwa.movePTPJointSpace(jPos, relVel);

%% Draw the interface
[figureHandle,anglesTextHandlesCellArray,labelTextHandlesCellArray]=constructInterface();

%% max angular velocity
w=10*pi/180; % rad/sec

%% Joint space control
firstExecution=0;
jointIndex=1; % the index of the selcted joint for realtime control.

setBackGroundColor(labelTextHandlesCellArray, 1 );
pause(0.1);
frameUpdateCount=0;
maxDisp=1*pi/180;
while true
    joyStatus=read(joy);
    %% Remove the bias in the analog signal
    analogPrecission=1/50;
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
    
    %% Calculate the elapsed time
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
    
%% Change index  of controlled axes, 
% This happens when the left joiystic of the gamepad is moved in up/down
% direction.  
%
    if(abs(joyStatus(2))>0.9)
        step=sign(joyStatus(2))*1;
        jointIndex=jointIndex+step;
        
        if(jointIndex==0)
            jointIndex=7;
        end
        
        if(jointIndex==8)
            jointIndex=1;
        end
        
        setBackGroundColor(labelTextHandlesCellArray, jointIndex );
        pause(0.5);
        continue;
    end
    
 %% Control axes motion
     if(joyStatus(2)==0) 
        % move the axes only if the analog signal corresponding to change
        % axes command is zero. 
        dq=w*dt*joyStatus(3);
        %% Check for joint limit avoidance
        dq=dq*jointLimitAvoidance(jointIndex,jPos,dq);
        if dq>maxDisp
            dq=maxDisp;
        end
        jPos{jointIndex}=jPos{jointIndex}+dq;
        frameUpdateCount=frameUpdateCount+1;
        if(frameUpdateCount==50)
            setJointAngleToText(anglesTextHandlesCellArray, jointIndex,jPos{jointIndex} )
            frameUpdateCount=0;
            pause(0.001);
        end
        iiwa.sendJointsPositions(jPos);
     end
    
     %% A condition to break the loop, when x button of the gamepad is pressed
     b=button(joy,1);
     if(b==1)
         break;
     end
       
end
close(figureHandle);
%% turn off the server
iiwa.net_turnOffServer();
    
