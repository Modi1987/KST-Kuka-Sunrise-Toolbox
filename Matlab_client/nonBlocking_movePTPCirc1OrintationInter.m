function [ state ] = nonBlocking_movePTPCirc1OrintationInter( t , f1,f2, relVel)
%% This nonblocking function is used for moving the endeffector on a circle, for the KUKA iiwa 7 R 800.

%% Syntax:
% [ state ] = nonBlocking_movePTPCirc1OrintationInter( t , f1,f2, vel)

%% About:
% This function is used to move the end-effector on a circle,

%% Arreguments:
% t: is the TCP/IP connection
% f1: intermediate frame, to specify a point from the circle, it is 1x6 cell array.
% f2: final frame, to specify the end point of the circle, it is 1x6 cell array.

% the first three elements of f1 and f2 cell arrays, is the X,Y
% and Z position of the frame (in millimeters)

% the second three elements of f1 and f2 cell arrays, is the
% alpha,beta and gamma rotaion angles (rads) that represent the frame
% orientation

% vel: is the motion linear velocity, mm/sec.

% Copy right, Mohammad SAFEEA, 9th of May 2017

% check also the function: nonBlocking_isGoalReached()

    theCommand=['jRelVel_',num2str(relVel),'_']; % set over ride.
    fprintf(t, theCommand);
    message=fgets(t);
    % The new position of end-effector, described in robot 
    newPos={0,0,0,0,0,0};
    
    newPos{1}=f1{1};
    newPos{2}=f1{2};
    newPos{3}=f1{3};
    newPos{4}=f1{4};
    newPos{5}=f1{5};
    newPos{6}=f1{6};
    
    sendCirc1FramePos( t ,newPos); % send first frame of circle to server on controller.
    
    newPos{1}=f2{1};
    newPos{2}=f2{2};
    newPos{3}=f2{3};
    newPos{4}=f2{4};
    newPos{5}=f2{5};
    newPos{6}=f2{6};
    
    sendCirc2FramePos( t ,newPos); % send second frame of circle to server on controller.
    
    global paramName;
    global paramVal;
    paramName='eefpos';
    paramVal=newPos;
    
    theCommand='doPTPinCSCircle1_';
    fprintf(t, theCommand); % start the point to point motion.
    message=fgets(t);
    
    state=checkAcknowledgment(message);  
    
    
end

function [ output_args ] = sendCirc1FramePos( t ,jPos)
%% sendCircFramePos 
% This function is used to send the first frame of the circle
% to the robot

% Pos: is 6 cells array of doubles
% t: is the TCP/IP connection object
% Copy right, Mohammad SAFEEA, 3rd of May 2017

theCommand='cArtixanPositionCirc1_';

for i=1:6
    x=sprintf('%0.2f',jPos{i});
    theCommand=[theCommand,x,'_'];
end

fprintf(t, theCommand);
message=fgets(t);
end

function [ output_args ] = sendCirc2FramePos( t ,jPos)
%% sendCircFramePos 
% This function is used to send the first frame of the circle
% to the robot

% Pos: is 6 cells array of doubles
% t: is the TCP/IP connection object
% Copy right, Mohammad SAFEEA, 3rd of May 2017

theCommand='cArtixanPositionCirc2_';

for i=1:6
    x=sprintf('%0.2f',jPos{i});
    theCommand=[theCommand,x,'_'];
end

fprintf(t, theCommand);
message=fgets(t);
end


