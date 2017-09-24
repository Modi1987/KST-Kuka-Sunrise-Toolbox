clear all;
close all;
clc;
%% Start the joystick
instrreset;
ID=1;
joy=vrjoystick(ID);
%% Start the KST
cDir = pwd;
cDir=getTheKSTDirectory(cDir);
addpath(cDir);

warning('off');
ip='172.31.1.147'; % The IP of the controller
% start a connection with the server
global tKuka;
tKuka=net_establishConnection( ip );

if ~exist('tKuka','var') || isempty(tKuka)
  warning('Connection could not be establised, script aborted');
  return;
end
 %% Move robot to home position   
      jPos={0,0,0,0,0,0,0};
    
      setBlueOff(t); % turn Off blue light
    
      relVel=0.15;
      movePTPJointSpace( t , jPos, relVel); % move to initial configuration
 
%% Start direct servo in joint space       
       realTime_startDirectServoJoints(t);
        
%% Draw the interface

%% max angular velocity
w=1; % rad/sec
%% Joint space control
firstExecution=0;
jointIndex=1; % the index of the selcted joint for realtime control.
while true
    joyStatus=read(joy);
    %% Remove the bias in the analog signal
    analogPrecission=1/50;
    for i=1:4
        if abs( joyStatus(i))<analogPrecission
            joyStatus(i)=0;
        end
    end
    % 2d element is used to select axes
    % 3d element is used to control axes position
    %% Calculate elapsed time
    if(firstExecution==0)
        firstExecution=1;
        a=datevec(now);
        timeNow=a(6)+a(5)*60+a(4)*60*60; % calculate time at this instant
        dt=0; % elapsed is zero at first excution
        time0=timenow;
    else
        a=datevec(now);
        timeNow=a(6)+a(5)*60+a(4)*60*60; % calculate time at this instant
        dt=timeNow-time0; % calculate elapsed time interval
        time0=timenow;
    end
%% Change index  of controlled axes  
    if(abs(joyStatus(2))>0.9)
        step=sign(joyStatus(2))*1;
        jointIndex=jointIndex+step
        pause(0.5);
        continue;
    end
 %% Control axes
     if(joyStatus(2)==0) 
        % move the axes only if the change axes analog signal is zero.
        dq=w*dt*joyStatus(3);
        %% Add joint limit avoidance
        dq=dq*jointLimitAvoidance(jointIndex,jPos,dq);
        jPos{jointIndex}=jPos{jointIndex}+dq;
        sendJointsPositions( tKuka ,jPos);
     end
    
    %% turn off the server
    net_turnOffServer( t );
    fclose(t);
       
    pause(0.1)
end
