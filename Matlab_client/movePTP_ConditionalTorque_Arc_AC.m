function [ state ] =movePTP_ConditionalTorque_Arc_AC(t_Kuka,theta,c,k,VEL,joints_indices,max_torque,min_torque)
%% This function is used for moving the end-effector on an arc, for the KUKA iiwa 7 R 800.
% this motion is interruptible when one or more of the joints-torques exceed the predefined limits 

%% Syntax
% [ state ] =movePTP_ConditionalTorque_Arc_AC(t_Kuka,theta,c,k,relVel,joints_indices,max_torque,min_torque)

%% About:
% This function is used to move the end-effector on an arc,

%% Arreguments:
% t_Kuka: is the TCP/IP connection
% theta: is the arc angle, in radians.
% c: the x,y,z coordinates of the center of the circle, it is 1x3 vector.
% k: is the normal vector on the plane of the arc, it is 1x3
% vector.
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

c=colVec(c);
k=colVec(k);

pos=getEEFPos( t_Kuka );
p1=[pos{1};pos{2};pos{3}];
p1=colVec(p1);

r=norm(p1-c);

if(or(r==0,theta==0))
 return;
end
normK=norm(k);
if(normK==0)
 fprintf('Norm of direction vector k shall not be zero \n');
 return;
end
k=k/normK;

s=(p1-c)/r;
n=cross(k,s);

c1=r*cos(theta/2)*s+r*sin(theta/2)*n+c;
c2=r*cos(theta)*s+r*sin(theta)*n+c;

f1=pos;
i=1;
f1{i}=c1(i);
i=i+1;
f1{i}=c1(i);
i=i+1;
f1{i}=c1(i);



f2=pos;
i=1;
f2{i}=c2(i);
i=i+1;
f2{i}=c2(i);
i=i+1;
f2{i}=c2(i);



state=movePTP_ConditionalTorque_Circ1OrintationInter( t_Kuka , f1,f2,...
    VEL,joints_indices,max_torque,min_torque);


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

