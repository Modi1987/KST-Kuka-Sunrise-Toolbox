function [ state ] = movePTP_ConditionalTorque_Circ1OrintationInter( t_Kuka , f1,f2, VEL,joints_indices,max_torque,min_torque)
%% This function is used for moving the end-effector on a circle, for the KUKA iiwa 7 R 800.
% this motion is interruptible when one or more of the joints-torques exceed the predefined limits 

%% Syntax:
% [ state ] = movePTP_ConditionalTorque_Circ1OrintationInter( t_Kuka , f1,f2, VEL,joints_indices,max_torque,min_torque)

%% About:
% This function is used to move the end-effector on a circle,

%% Arreguments:
% t_Kuka: is the TCP/IP connection
% f1: intermediate frame, to specify a point from the circle, it is 1x6 cell array.
% f2: final frame, to specify the end point of the circle, it is 1x6 cell array.
% the first three elements of f1 and f2 cell arrays, is the X,Y
% and Z position of the frame (in millimeters)
% the second three elements of f1 and f2 cell arrays, is the
% alpha,beta and gamma rotaion angles (rads) that represent the frame
% orientation
% VEL: is the motion linear velocity, mm/sec.
% joints_indices: is a vector of the indices of the joints where the
% torques limits are to be imposed, the joints are indexed starting from one.
% max_torque: is a vector of the maximum torque limits for the joints
% specified in the (joints_indices) vector.
% min_torque: is a vector of the minimum torque limits for the joints
% specified in the (joints_indices) vector. 

%% Return value:
% state: a number equals to one if the motion is completed sccessfully or a
% zero if the motion was interrupted due to external contact with the
% robot.
% if there is an error, the return value is minus one

% Copyright, Mohammad SAFEEA, 9th of April 2018

if((size(VEL,1)==1)&&(size(VEL,2)==1))
else
    disp('Error, velocity is a double and shall not be an array');
    state=-1;
    return;
end
% Check if the inputs "joints_indices,max_torque,min_torque" are vectors
if(isVec(joints_indices)==0)
    disp('Error, joints_indices shall be a vector');
    state=-1;
    return;
end
if(isVec(max_torque)==0)
    disp('Error, max_torque shall be a vector');
    state=-1;
    return;
end
if(isVec(min_torque)==0)
    disp('Error, min_torque shall be a vector');
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

% The new position of end-effector, described in robot 
newPos={0,0,0,0,0,0};

newPos{1}=f1{1};
newPos{2}=f1{2};
newPos{3}=f1{3};
newPos{4}=f1{4};
newPos{5}=f1{5};
newPos{6}=f1{6};

sendCirc1FramePos( t_Kuka ,newPos); % send first frame of circle to server on controller.

newPos{1}=f2{1};
newPos{2}=f2{2};
newPos{3}=f2{3};
newPos{4}=f2{4};
newPos{5}=f2{5};
newPos{6}=f2{6};

ret=sendCirc2FramePos( t_Kuka ,newPos); % send second frame of circle to server on controller.
if(ret==false)
    disp('Error, could not perform the motion due to the acknowledgment message was not received');
    disp('Check connection between PC and Robot');
    state=-1;
    return;
end

theCommand='doPTP!CSCircle1_';
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
    message=fgets(t);
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

function [ ret ] = sendCirc1FramePos( t ,jPos)
%% sendCircFramePos 
% This function is used to send the first frame of the circle
% to the robot

% Pos: is 6 cells array of doubles
% t: is the TCP/IP connection object
% Copy right, Mohammad SAFEEA, 3rd of May 2017

theCommand='cArtixanPositionCirc1_';

for i=1:6
    x=sprintf('%0.5f',jPos{i});
    theCommand=[theCommand,x,'_'];
end

fprintf(t, theCommand);
message=fgets(t);
ret=checkAcknowledgment(message);
end

function [ ret ] = sendCirc2FramePos( t ,jPos)
%% sendCircFramePos 
% This function is used to send the first frame of the circle
% to the robot

% Pos: is 6 cells array of doubles
% t: is the TCP/IP connection object
% Copy right, Mohammad SAFEEA, 3rd of May 2017

theCommand='cArtixanPositionCirc2_';

for i=1:6
    x=sprintf('%0.5f',jPos{i});
    theCommand=[theCommand,x,'_'];
end

fprintf(t, theCommand);
message=fgets(t);
ret=checkAcknowledgment(message);
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
