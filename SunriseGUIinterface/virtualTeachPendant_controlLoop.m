function virtualTeachPendant_controlLoop()
%% The virtual teach pendant
% moving the robot from a graphical user interface using the soft realtime
% control functions of the KST.

% Copyright: Mohammad SAFEEA 2018-July-26

global iiwa;
global virtual_smartPad_ControlLoopeEnabled;
% Magnitudes of motion velocities
global virtualTeachPendantLinearVelocityMagnitude; % mm/sec
global virtualTeachPendantAngularVelocityMagnitude; % degree/sec
global virtualTeachPendantJointVelocityMagnitude; % degree/sec

vel=zeros(6,1);
w_joints_command=zeros(7,1);
velFiltered=zeros(6,1);
w_filtered_joints_command=zeros(7,1);
retentionVal=0.7;
% Start soft realtime control
iiwa.realTime_startDirectServoJoints();
pause(0.1);
% Initiate current joint angles
jPos=iiwa.getJointsPos();
qin=zeros(7,1);
for i=1:7
    qin(i)=jPos{i};
end
% Solver's parameters
n=20;
lambda=0.05;
% Timing variables
tic;
daCounter=0;
timeZero=toc;
tOld=timeZero;
% Control loop
while virtual_smartPad_ControlLoopeEnabled
    pause(0.001); % around 330 times a second
    tNow=toc;
    deltaT=tNow-tOld;
    if deltaT>0.004
        tOld=tNow;
        daCounter=daCounter+1;
        % Direct kinematics
        [T0,J]=iiwa.directKinematics(qin); % EEF frame transformation matrix
        % Sample the input command
        [vel,w_joints_command]=getVelocity();
        velFiltered=velFiltered*retentionVal+vel*(1-retentionVal);
        w_filtered_joints_command=...
            w_filtered_joints_command*retentionVal+w_joints_command*(1-retentionVal);
        % Update transform
        w=velFiltered(4:6)*(virtualTeachPendantAngularVelocityMagnitude*pi/180);
        v=velFiltered(1:3)*(virtualTeachPendantLinearVelocityMagnitude/1000);
        wJoints=w_joints_command*(virtualTeachPendantJointVelocityMagnitude*pi/180);
        [ Tt ] = updateTransform(T0,w,v,deltaT);
        % Inverse kinematics
        [ qs ] = iiwa.gen_InverseKinematics( qin, Tt,n,lambda );
        % Update joints positions
        for i=1:7
            qs(i)=qs(i)+wJoints(i)*deltaT;
            jPos{i}=qs(i);
        end  
        % Update initial position
        qin=qs;
        iiwa.sendJointsPositionsf(jPos);
        showJointAngleFeedBackOnText(qs)
    end
end
timeFinal=toc;
disp('The loop rate (HZ):');
disp(daCounter/(timeFinal-timeZero));
% Turn off direct servo control
iiwa.realTime_stopDirectServoJoints();
end

function showJointAngleFeedBackOnText(q)
global virtualTeachPendantJointAnglesTextHandles;
global virtualTeachPendantIsAlive;
for i=1:7
	handle=virtualTeachPendantJointAnglesTextHandles{i};
	dastr=num2str(q(i));
    if virtualTeachPendantIsAlive==true
        set(handle,'String',dastr);
    end
end
end

function [vel,w_joints_command]=getVelocity()
global virtual_smartPad_Xplus;
global virtual_smartPad_Xminus;
global virtual_smartPad_Yplus;
global virtual_smartPad_Yminus;
global virtual_smartPad_Zplus;
global virtual_smartPad_Zminus;

global virtual_smartPad_WXplus;
global virtual_smartPad_WXminus;
global virtual_smartPad_WYplus;
global virtual_smartPad_WYminus;
global virtual_smartPad_WZplus;
global virtual_smartPad_WZminus;

global virtual_smartPad_w_joints_command;

vel=zeros(6,1);

vel(1)=virtual_smartPad_Xplus-virtual_smartPad_Xminus;
vel(2)=virtual_smartPad_Yplus-virtual_smartPad_Yminus;
vel(3)=virtual_smartPad_Zplus-virtual_smartPad_Zminus;

vel(4)=virtual_smartPad_WXplus-virtual_smartPad_WXminus;
vel(5)=virtual_smartPad_WYplus-virtual_smartPad_WYminus;
vel(6)=virtual_smartPad_WZplus-virtual_smartPad_WZminus;

w_joints_command=virtual_smartPad_w_joints_command;

end