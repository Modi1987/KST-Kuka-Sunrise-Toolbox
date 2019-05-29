function [flag,feedBack]=nonBlockingCheck_WithFeedback(t_Kuka, param)
% This functions is used with nonBlocking motion functions to check whether
% the non-blcokking motion is finished execution, in addition this function
% returns a feedback about the state of the robot.

%% Syntax:
% [flag]=nonBlockingCheck_WithFeedback(t_Kuka, param)

%% Arguments
% t_Kuka: is the TCP/IP connection object 
% param: an integer value used to specify the feedback required from the
% robot (EEF force, EEF moment, joints torques, joint angles), please check
% the "feedBack" variable in the "return value" section-below for more info
% about the supported values of (param).

%% return value
% flag is a numerical value:
% flag=1: signifies the goal is reached
% flag=0: signifies the goal is not reached
% flag=-1: signifies an error
% feedBack: a cell array representing the feedback from the robot, the
% dimention of the array and the information in its cells depend
% on the value of the "param" argument as in the following table:
%-------------------------------------------------
% param | feedback  
%   1   | force at EEF described in frame of EEF
%   2   | external torques at the joints
%   3   | measured torques at the joints
%   4   | joints positions from internal encoders
%--------------------------------------------------
% Copyright: Mohammad SAFEEA 12th-May-2019

global paramName;
global paramVal;
paramArg_CarLevel={'DcSeCarEEfFrelEEF_','DcSeCarExT_','DcSeCarMT_','DcSeCarJP_'};
sleeping_time=0.005;
x='eefpos';
%% if motion at EEF level
if(strcmp(x,paramName))
    % check size of array
    if(max(size(paramVal))==6)
    else
        flag=-1;
        return;
    end
% check if parameters are equal
    paramArg=paramArg_CarLevel{param};
    [feedBack,tempFlag]=GetFeedback( t_Kuka,paramArg );
    if tempFlag==false
        flag=1;
        pause(sleeping_time);
    else
        flag=0;
        pause(sleeping_time);
    end
    return;
end
%% if motion at joint space level
x='jpos';
if(strcmp(x,paramName))
    % check size of array
    if(max(size(paramVal))==7)
    else
        flag=-1;
        return;
    end
    % check if parameters are equal
    paramArg=paramArg_CarLevel{param};
    [feedBack,tempFlag]=GetFeedback( t_Kuka,paramArg );
    if tempFlag==false
        flag=1;
        pause(sleeping_time);
    else
        flag=0;
        pause(sleeping_time);
    end
    return;
end
% otherwise
flag=-1;
end

function [ feeadback,flag ] = GetFeedback( t_Kuka, paramArg )
EEEFpos={0,0,0,0,0,0};
theCommand=paramArg;

for i=1:6
    x=EEEFpos{i};
    theCommand=[theCommand,sprintf('%0.5f',x),'_'];
end
% send the message through network
fprintf(t_Kuka, theCommand);
message=fgets(t_Kuka);
[feeadback,N]=getDoubleFromString(message);
if(N==0) % when motion is finished, server returns "done+stopCharacter", raising this case
    flag=false; % segnifies motion is done
    message=fgets(t_Kuka);
    [feeadback,N]=getDoubleFromString(message);
    pause(0.1); % wait for sometime
else
    flag=true;
end
end


function [jPos,j]=getDoubleFromString(message)
n=max(max(size(message)));
j=0;
numString=[];
for i=1:n
    if message(i)=='_'
        j=j+1;
        jPos{j}=str2num(numString);
        numString=[];
    else
        numString=[numString,message(i)];
    end
end
if j==0
    jPos={0};
end
end
