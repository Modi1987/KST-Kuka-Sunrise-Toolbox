function [ state ] = movePTP_ConditionalTorque_LineEEF( t_Kuka , Pos, VEL,joints_indices,max_torque,min_torque)
%% This function is used for performing point to point motion in Cartizian space, for the KUKA iiwa 7 R 800.
% this motion is interruptible when one or more of the joints-torques exceed the predefined limits 

%% Syntax:
% [ state ] = movePTP_ConditionalTorque_LineEEF( t , Pos, relVel,joints_indices,max_torque,min_torque)

%% About:
% This function is used to move the end effector on a line.
% When called, the function causes the end-effector to move on a line, the
% robot can keep the orientation of the endeffector fixed, or it can change
% the orientation of the endeffector while moving on the line. If the
% distanation orientation of the robot is defiend, the robot interpolates
% the end-effector orientation while performing the line motion. 

%% Arreguments:
% t_Kuka: is the TCP/IP connection
% Pos: is the destanation position of media flange of the robot. This
% position is specified relative to robot base frame, it is 1x6 cell array. 
% The first three cells of (Pos) prepresent the X,Y and Z coordinates of end
% effector, in (millimeters)
% The remaining three cells of Pos, are the rotation angle of the end
% effector, alpha, beta and gamma relative to robot base frame in (radians)
% VEL: is a double, and it represents the linear motion velocity, mm/sec.
% joints_indices: is a vector of the indices of the joints where the
% torques limits are to be imposed, the joints are indexed starting from one.
% max_torque: is a vector of the maximum torque limits for the joints
% specified in the (joints_indices) vector.
% min_torque: is a vector of the minimum torque limits for the joints
% specified in the (joints_indices) vector. 
% if there is an error, the return value is minus one

%% Return value:
% state: a number equals to one if the motion is completed sccessfully or a
% zero if the motion was interrupted due to external contact with the
% robot.

% Copy right, Mohammad SAFEEA, 9th of April 2018

if((size(VEL,1)==1)&&(size(VEL,2)==1))
else
    disp('Error, relative velocity is a double and shall not be an array');
    state=-1;
    return;
end

% Check if the inputs "joints_indices,max_torque,min_torque" are vectors
if(isVec(joints_indices)==0)
    disp('Error, joints_indices shall be a vector')
    state=-1;
    return;
end
if(isVec(max_torque)==0)
    disp('Error, max_torque shall be a vector')
    state=-1;
    return;
end
if(isVec(min_torque)==0)
    disp('Error, min_torque shall be a vector')
    state=-1;
    return;
end

joints_indices=colVec(joints_indices);
max_torque=colVec(max_torque);
min_torque=colVec(min_torque);

% Check if size of vectrs are equal
j_num=size(joints_indices,1);
n=size(min_torque,1);
if(j_num==n)
else
    disp('Error, sizes of vectors "joints_indices" and "min_torque" shall be equal');
    state=-1;
    return;
end
n=size(max_torque,1);
if(j_num==n)
else
    disp('Error, sizes of vectors "joints_indices" and "max_torque" shall be equal');
    state=-1;
    return;
end

theCommand=['jRelVel_',num2str(VEL),'_']; % set over ride.
fprintf(t_Kuka, theCommand);
message=fgets(t_Kuka);
if checkAcknowledgment(message)
else
    disp('Error, could not perform the motion due to the acknowledgment message was not received');
    disp('Check connection between PC and Robot');
    state=-1;
    return;
end

sendEEfPositions( t_Kuka ,Pos); % send destination joint positions.


theCommand='doPTP!inCS';
for i=1:j_num
    datemp=joints_indices(i)-1;
    theCommand=[theCommand,'_',num2str(datemp)];
    datemp=min_torque(i);
    theCommand=[theCommand,'_',num2str(datemp)];
    datemp=max_torque(i);
    theCommand=[theCommand,'_',num2str(datemp)];
end

fprintf(t_Kuka, theCommand); % start the point to point motion.
message=fgets(t_Kuka);
if checkAcknowledgment(message)
    disp('Motion started successfully');
else
    disp('Error, could not perform the motion due to the acknowledgment message was not received');
    disp('Check connection between PC and Robot');
    state=-1;
    return;
end

%% Check the return from the server
message='';

while true
    message=fgets(t_Kuka);
    daSize=max(size(message));
    if(daSize>2)
        if(strfind(message,'done')==1)
            state=1;
            return;
        end
        if(strfind(message,'interrupted')==1)
            state=0;
            return;
        end
    end
end



end

function y=colVec(x)
    if(size(x,2)==1)
        y=x;
    else
        y=x';
    end
end

function y=isVec(x)
    y=0;
    if(size(x,2)==1)
        y=1;
    end
    if(size(x,1)==1)
        y=1;
    end
end


