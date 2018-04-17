function [ state ] = nonBlocking_movePTPLineEEF( t , Pos, relVel)
%% This function is used for performing non-blocking point to point motion in Cartizian space, for the KUKA iiwa 7 R 800.

%% Syntax:
% [ state ] = nonBlocking_movePTPLineEEF( t , Pos, vel)

%% About:
% This function is used to move the end effector on a line.
% When called, the function causes the end-effector to move on a line, the
% robot can keep the orientation of the endeffector fixed, or it can change
% the orientation of the endeffector while moving on the line. If the
% distanation orientation of the robot is defiend, the robot interpolates
% the end-effector orientation while performing the line motion. 

%% Arreguments:
% t: is the TCP/IP connection
% Pos: is the destanation position of media flange of the robot. This
% position is specified relative to robot base frame, it is 1x6 cell array. 
% The first three cells of (Pos) prepresent the X,Y and Z coordinates of end
% effector, in (millimeters)
% The remaining three cells of Pos, are the rotation angle of the end
% effector, alpha, beta and gamma relative to robot base frame in (radians)
% vel: is a double, and it represents the linear motion velocity, mm/sec.

% Copy right, Mohammad SAFEEA, 9th of May 2017

% check also the function: nonBlocking_isGoalReached()

global paramName;
global paramVal;
paramName='eefpos';
paramVal=Pos;

    theCommand=['jRelVel_',num2str(relVel),'_']; % set over ride.
    fprintf(t, theCommand);
    message=fgets(t);
    
    sendEEfPositions( t ,Pos); % send destination joint positions.
    
    
    theCommand='doPTPinCS';
    fprintf(t, theCommand); % start the point to point motion.
    message=fgets(t);
    
    state=checkAcknowledgment(message);
    
end



