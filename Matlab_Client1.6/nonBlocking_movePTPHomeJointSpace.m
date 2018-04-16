function [ state ] = nonBlocking_movePTPHomeJointSpace( t , relVel)
%% This non-blocking function is used for performing point to point motion
%  in joint space to the home position of the robot, for the KUKA iiwa 7 R 800.

%% Syntax:
% [ state ] = movePTPHomeJointSpace( t , relVel)

%% About:
% This function is used to move the robot to home position, the motion is
% performed in joint space. 

%% Arreguments:
% t: is the TCP/IP connection
% relVel: is a double, from zero to one, specifies the over-ride relative
% velocity. 

% Copy right, Mohammad SAFEEA, 9th of May 2017

% check also the function: nonBlocking_isGoalReached()

    theCommand=['jRelVel_',num2str(relVel),'_']; % set over ride.
    fprintf(t, theCommand);
    message=fgets(t);
    
    jPos=[];
    for i=1:7
        jPos{i}=0;
    end
    
    global paramName;
    global paramVal;
    paramName='jpos';
    paramVal=jPos;
    
    sendJointsPositions( t ,jPos); % send destination joint positions.
    
    theCommand='doPTPinJS';
    fprintf(t, theCommand); % start the point to point motion.
    message=fgets(t);
    state=checkAcknowledgment(message);
    
    
    
end



