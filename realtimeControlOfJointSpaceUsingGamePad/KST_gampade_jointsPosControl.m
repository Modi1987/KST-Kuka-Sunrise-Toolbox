clear all;
close all;
clc;
%% Start the joystick, make sure that the joystick is connected
instrreset;
ID=1;
joy=vrjoystick(ID);
%% Start the KST, move robot to home position, start directServo function
[tKuka,flag]=startDaDirectServo( );
if flag==false
    fprintf('Can not connect to KST \n');
    fprintf('Program terminated \n');
    return;
end
jPos={0,0,0,0,0,0,0};

%% Draw the interface
[figureHandle,anglesTextHandlesCellArray,labelTextHandlesCellArray]=constructInterface();
%% max angular velocity
w=5*pi/180; % rad/sec
%% Joint space control
firstExecution=0;
jointIndex=1; % the index of the selcted joint for realtime control.

setBackGroundColor(labelTextHandlesCellArray, 1 );

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
        jointIndex=jointIndex+step
        setBackGroundColor(labelTextHandlesCellArray, jointIndex );
        pause(0.5);
        continue;
    end
 %% Control axes
     if(joyStatus(2)==0) 
        % move the axes only if the analog signal corresponding to change
        % axes command is zero. 
        dq=w*dt*joyStatus(3);
        %% Chekc for joint limit avoidance
        dq=dq*jointLimitAvoidance(jointIndex,jPos,dq);
        jPos{jointIndex}=jPos{jointIndex}+dq;
        setJointAngleToText(anglesTextHandlesCellArray, jointIndex,jPos{jointIndex} )
        %sendJointsPositions( tKuka ,jPos);
     end
    
     %% TO be done
     % Add a condition to break the loop, when x button of the gamepad is
     b=button(joy,1);
     if(b==1)
         break;
     end
       
    pause(0.1)
end
close(figureHandle);
    %% turn off the server
    net_turnOffServer( tKuka );
    fclose(tKuka);
    
