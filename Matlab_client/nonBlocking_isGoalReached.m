function [flag]=nonBlocking_isGoalReached(t_Kuka)
% this functions is used with nonBlocking motion functions to chekc whether
% the goal is reached.

%% Syntax:
% [flag]=nonBlocking_isGoalReached()

%% Arreguments
% t_Kuka: is the TCP/IP connection object 

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
    [eefpos,tempFlag]=GetActualEEFpos( t_Kuka );
    if tempFlag==false
        flag=1;
        return;
    end
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
    pause(0.1);
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
    [eefpos,tempFlag]=GetActualJOINTSpos( t_Kuka );
    if tempFlag==false
        flag=1;
        return;
    end
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
    pause(0.1);
    return;
end
end


function [ EEFpos,flag ] = GetActualEEFpos( t_Kuka )
EEEFpos={0,0,0,0,0,0};
theCommand='DcSeCarEEfP_';

for i=1:6
    x=EEEFpos{i};
    theCommand=[theCommand,sprintf('%0.5f',x),'_'];
end
% send the message through network
fprintf(t_Kuka, theCommand);
message=fgets(t_Kuka);
[EEFpos,N]=getDoubleFromString(message);
if(N==0)
    flag=false;
    message=fgets(t_Kuka);
    [EEFpos,N]=getDoubleFromString(message);
else
    flag=true;
end
end

function [ EEFpos,flag ] = GetActualJOINTSpos( t_Kuka )
EEEFpos={0,0,0,0,0,0};
theCommand='DcSeCarJP_';

for i=1:6
    x=EEEFpos{i};
    theCommand=[theCommand,sprintf('%0.5f',x),'_'];
end
% send the message through network
fprintf(t_Kuka, theCommand);
message=fgets(t_Kuka);
[EEFpos,N]=getDoubleFromString(message);
if(N==0)
    flag=false;
    message=fgets(t_Kuka);
    [EEFpos,N]=getDoubleFromString(message);
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
