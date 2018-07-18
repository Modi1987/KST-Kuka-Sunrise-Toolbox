function startPreciseHandGuiding1( t,wightOfTool,COMofTool )
%% About:
% This function is used to start the handguiding functionality on the robot

%% Syntax:
% [ output_args ] = startPreciseHandGuiding1( t,wightOfTool,COMofTool )

%% Arreguments:
% t: is the TCP/IP connection object
% wightOfTool: weight of the tool connected to the flange in newton, unit Newtons.
% COMofTool: coordinates of the center of mass of the tool, descirbed in
% the reference frame of the flange (mm).

% Copy right, Mohammad SAFEEA, 22nd of Oct 2017

com=colVec(COMofTool)/1000; % convert from mm to meter
wot=-wightOfTool; % negtive, wight of tool described in base frame of robot

if(sum(size(com)==[3,1])==2)
else
    fprintf('Error: COMofTool vector is not in the right dimention \n');
    disp('Function termintated');
    return;
end

if norm(com)>0.5
    fprintf('Error: COMofTool vector shall not have a norm bigger than 0.5 meters \n');
    disp('Function termintated');
    return;
end

if(sum(size(wot)==[1,1])==2)
else
    fprintf('Error: wightOfTool variable is not in the right dimention \n');
    disp('Function termintated');
    return;
end

s='preciseHandGuiding1';
s=[s,'_',num2str(wot)];
for i=1:3
	s=[s,'_',num2str(com(i))];
end
theCommand=s;
fprintf(t, theCommand);

fprintf('Precise hand gudining functionality is started \n');
fprintf('To terminate the precise hand guding function, press the green button for more than 5 sec');
fprintf('\n keep pressing until the red light starts to flicker then release your hand, ')
fprintf('\n the hand guiding mode will be terminated ');

    message='';
    w = warning ('off','all');
    readingFlag=false;
    while readingFlag==false
        message=fgets(t);
        
        if checkAcknowledgment(message)
            readingFlag=true;
        end
    end
     w = warning ('on','all');
    fprintf('Hand gudining was terminated by user at robot side \n');
end

function y=colVec(x)
    if(size(x,2)==1)
        y=x;
    else
        y=x';
    end
end
