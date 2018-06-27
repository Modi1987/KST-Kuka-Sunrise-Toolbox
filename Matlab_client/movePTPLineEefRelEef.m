function [ state ] = movePTPLineEefRelEef( t , Pos, relVel)
%% This function is used for moving the endeffector on a line, for the KUKA iiwa 7 R 800.

%% Syntax:
% [ state ] = movePTPLineEefRelEef( t , Pos, vel)

%% About:
% This function is used to move the end-effector on a line, relative to end effector frame,
% this performs only a linear motion, the orientation of end effector will not be changed.
% For more information refer to example (kuka0_move_lin_relative.m)..

%% Arreguments:
% t: is the TCP/IP connection
% Pos: is the destanation position of end effector, described in end
% effector frame, it is 1x3 cell array. 
% vel: is a double, the linear velocity of the endeffector (unit mm/sec).

% Copy right, Mohammad SAFEEA, 9th of May 2017

    theCommand=['jRelVel_',num2str(relVel),'_']; % set over ride.
    fprintf(t, theCommand);
    message=fgets(t);
    % The new position of end-effector, described in robot 
    newPos={0,0,0,0,0,0};
    newPos{1}=Pos{1};
    newPos{2}=Pos{2};
    newPos{3}=Pos{3};
    
    
    sendEEfPositions( t ,newPos); % send destination joint positions.
    
    
    theCommand='doPTPinCSRelEEF';
    fprintf(t, theCommand); % start the point to point motion.
    message=fgets(t);
    
    readingFlag=false;
    
    message='';
    state=false;
    while readingFlag==false
        message=fgets(t);
        state=checkAcknowledgment(message);
        if state
            readingFlag=true;
        end
    end
    
    
    
end



