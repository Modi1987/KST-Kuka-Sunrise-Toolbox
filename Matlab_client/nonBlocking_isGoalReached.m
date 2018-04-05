function [flag]=nonBlocking_isGoalReached(t)
% this functions is used with nonBlocking motion functions to chekc whether
% the goal is reached.

%% Syntax:
% [flag]=nonBlocking_isGoalReached()

%% return value
% flag is a numerical value:
% flag=1: signifies the goal is reached
% flag=0: signifies the goal is not reached
% flag=-1: signifies an error

% Copy right: Mohammad SAFEEA 04th-April-2018

global paramName;
global paramVal;
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
    flag=1;
    eefpos=getEEFPos( t );
    for i=1:6
        x1=paramVal{i};
        x2=eefpos{i};
        clearance=0.2; % 0.2 mm precission
        if((x1>(x2-clearance))&&(x1<(x2+clearance)))
        else
            flag=0;
            return;
        end
    end
    pause(1);
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
    flag=1;
    eefpos=getJointsPos( t );
    for i=1:6
        x1=paramVal{i};
        x2=eefpos{i};
        clearance=0.1*pi/180; % 0.1 degree precission
        if((x1>(x2-clearance))&&(x1<(x2+clearance)))
        else
            flag=0;
            return;
        end
    end
    pause(1);
    return;
end
end