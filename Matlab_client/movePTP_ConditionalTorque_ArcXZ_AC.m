function [ state ] =movePTP_ConditionalTorque_ArcXZ_AC(t_Kuka,theta,c,VEL,joints_indices,max_torque,min_torque)
%% This function is used for moving the endeffector on an arc in the XZ plane, for the KUKA iiwa 7 R 800.
% this motion is interruptible when one or more of the joints-torques exceed the predefined limits

%% Syntax:
% [ state ] =movePTP_ConditionalTorque_ArcXZ_AC(t_Kuka,theta,c,VEL,joints_indices,max_torque,min_torque)

%% About:
% This function is used to move the end-effector on an arc in the XZ plane,

%% Arreguments:
% t_Kuka: is the TCP/IP connection
% theta: is the arc angle, in radians
% c: the XZ coordinates of the center of the circle, it is 1x2 vector.
% VEL : is a double, defines the motion velocity mm/sec.
% joints_indices: is a vector of the indices of the joints where the
% torques limits are to be imposed, the joints are indexed starting from one.
% max_torque: is a vector of the maximum torque limits for the joints
% specified in the (joints_indices) vector.
% min_torque: is a vecotr of the minimum torque limits for the joints
% specified in the (joints_indices) vector. 

%% Return value:
% state: a number equals to one if the motion is completed sccessfully or a
% zero if the motion was interrupted due to external contact with the
% robot.
% if there is an error, the return value is minus one

% Copy right, Mohammad SAFEEA, 9th of April 2018

if((size(VEL,1)==1)&&(size(VEL,2)==1))
else
    disp('Error, velocity is a double and shall not be an array');
    state=-1;
    return;
end

k=[0;1;0];
pos=getEEFPos( t_Kuka );
c=colVec(c);
c1=[c(1);pos{2};c(2)];
[ state ] =movePTP_ConditionalTorque_Arc_AC(t_Kuka,theta,c1,k,VEL,joints_indices,max_torque,min_torque);

end

function [ y ] = colVec( v)
% Convert a vector to a column vector:
    if(size(v,2)==1)
        y=v;
    else
        y=v';
    end
end