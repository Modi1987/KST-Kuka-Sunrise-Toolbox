function [ state ] = movePTP_ConditionalTorque_JointSpace( t , jPos, relVel,joints_indices,max_torque,min_torque)
%% This function is used for performing point to point motion in joint space,
% for the KUKA iiwa 7 R 800.
% this motion is interruptatble through a conditional 

%% Syntax:
% [ state ] = movePTPJointSpace( t , jPos, relVel)

%% About:
% This function is used to move the robot point to point in joint space.

%% Arreguments:
% t: is the TCP/IP connection
% jPos: is the destanation position in joint space, it is 1x7 cell array,
% joint angles are in radians.
% relVel: is a double, from zero to one, specifies the over-ride relative
% velocity. 
% joints_indices: is a vector of the indices of the joints where the
% torques limits are to be imposed, the joints are indexed starting from one.
% max_torque: is a vector of the maximum torque limits for the joints
% specified in the (joints_indices) vector.
% min_torque: is a vecotr of the minimum torque limits for the joints
% specified in the (joints_indices) vector. 

% Copyright, Mohammad SAFEEA, 9th of May 2017

% Check if the inputs "joints_indices,max_torque,min_torque" are vectors
    if(isVec(joints_indices)==0)
        disp('error, joints_indices shall be a vector')
        return;
    end
    if(isVec(max_torque)==0)
        disp('error, max_torque shall be a vector')
        return;
    end
    if(isVec(min_torque)==0)
        disp('error, min_torque shall be a vector')
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
        disp('sizes of vectors "joints_indices" and "min_torque" shall be equal');
        return;
    end
    n=size(max_torque,1);
    if(j_num==n)
    else
        disp('sizes of vectors "joints_indices" and "max_torque" shall be equal');
        return;
    end

    theCommand=['jRelVel_',num2str(relVel),'_']; % set over ride.
    fprintf(t, theCommand);
    message=fgets(t);
    
    sendJointsPositions( t ,jPos); % send destination joint positions.
    
    theCommand='doPTP!inJS';
    for i=1:j_num
        datemp=joints_indices(i)-1;
        theCommand=[theCommand,'_',num2str(datemp)];
        datemp=min_torque(i);
        theCommand=[theCommand,'_',num2str(datemp)];
        datemp=max_torque(i);
        theCommand=[theCommand,'_',num2str(datemp)];
    end
    
    fprintf(t, theCommand); % start the point to point motion.
    message=fgets(t);
if checkAcknowledgment(message)
    disp('Motion started successfully');
else
    disp('Error could not perform the motion');
    return;
end
    %% Check the return from the server
    message='';
    
    while true
        message=fgets(t);
        daSize=max(size(message));
        if(daSize>2)
            if(strfind(message,'done'))
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

