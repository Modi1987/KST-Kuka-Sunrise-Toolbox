function [ state ] = nonBlocking_movePTPJointSpace( t , jPos, relVel)
%% This function is used for performing non-blocking point to point motion in joint space,
% for the KUKA iiwa 7 R 800.

%% Syntax:
% [ state ] = nonBlocking_movePTPJointSpace( t , jPos, relVel)

%% About:
% This function is used to move the robot point to point in joint space.

%% Arreguments:
% t: is the TCP/IP connection
% jPos: is the destanation position in joint space, it is 1x7 cell array,
% joint angles are in radians.
% relVel: is a double, from zero to one, specifies the over-ride relative
% velocity. 

% Copy right, Mohammad SAFEEA, 9th of May 2017

% check also the function: nonBlocking_isGoalReached()

    global paramName;
    global paramVal;
    paramName='jpos';
    paramVal=jPos;
    
    theCommand=['jRelVel_',num2str(relVel),'_']; % set over ride.
    fprintf(t, theCommand);
    message=fgets(t);
    
    sendJointsPositions( t ,jPos); % send destination joint positions.
    
    theCommand='doPTPinJS';
    fprintf(t, theCommand); % start the point to point motion.
    message=fgets(t);
    state=checkAcknowledgment(message);
    
    
end



