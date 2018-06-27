function [ state ] = movePTPJointSpace( t , jPos, relVel)
%% This function is used for performing point to point motion in joint space,
% for the KUKA iiwa 7 R 800.

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

% Copyright, Mohammad SAFEEA, 9th of May 2017

    theCommand=['jRelVel_',num2str(relVel),'_']; % set over ride.
    fprintf(t, theCommand);
    message=fgets(t);
    
    sendJointsPositions( t ,jPos); % send destination joint positions.
    
    theCommand='doPTPinJS';
    fprintf(t, theCommand); % start the point to point motion.
    message=fgets(t);
    
    readingFlag=false;
    
    message='';
    state=false;
    while readingFlag==false
        message=fgets(t);
        state=checkAcknowledgment(message);
        if state==true
            readingFlag=true;
        end
    end
    
    
    
end



