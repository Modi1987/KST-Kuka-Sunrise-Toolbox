function fcn_decodeCommandMoveRobot(str)
%% About:
% This function is used to decode the command string, and then it is used
% to move the robot along the decoded instruction.

%% Areguments:
% str: command string

% Copyright: Mohammad SAFEEA, 13th-Jul-2018

global read_state_var;
% check connection
if fcn_isConnected()
else
    message='Error in function (fcn_decodeCommandMoveRobot), not connected to the robot !!!';
    fcn_errorMessage(message);
    return;
end

% Turn off state read
read_state_var=false;

% decode the motion command
if strncmpi('moveLine',str,max(size('moveLine')))
    moveLinePTP(str);
elseif strncmpi('moveJoints',str,max(size('moveJoints')))
    moveJointsPTP(str);
elseif startsWith(str,'OuputPin')
    setOutputsOfMediaFlange(str);
else
end

% Turn on state read
read_state_var=true;
end

function moveLinePTP(str)
    global iiwa;
    delimiter='_';
    C = fcn_tokenize(str,delimiter);
    for i=2:7
        pos{i-1}=str2num(C{i});
    end
    relVel=10; % velocity mm/sec
    iiwa.movePTPLineEEF(pos, relVel);
end

function moveJointsPTP(str)
    global iiwa;
    delimiter='_';
    C = fcn_tokenize(str,delimiter);
    for i=2:8
        jPos{i-1}=str2num(C{i});
    end
    relVel=0.2; % overrised velocity
    iiwa.movePTPJointSpace(jPos, relVel);
end

%% Control touch-pneumatic media flange output
function setOutputsOfMediaFlange(str)
    global iiwa;
    off={'OuputPin_11_OFF','OuputPin_12_OFF','OuputPin_1_OFF','OuputPin_2_OFF'};
    on={'OuputPin_11_ON','OuputPin_12_ON','OuputPin_1_ON','OuputPin_2_ON'};
    % pin 11
    if strncmpi(off{1},str,max(size(str)))
        iiwa.setPin11Off();
        return;
    end
    if strncmpi(on{1},str,max(size(str)))
        iiwa.setPin11On();
        return;
    end
    % pin 12
	if strncmpi(off{2},str,max(size(str)))
        iiwa.setPin12Off();
        return;
    end
    if strncmpi(on{2},str,max(size(str)))
        iiwa.setPin12On();
        return;
    end
    % pin 1
    if strncmpi(off{3},str,max(size(str)))
        iiwa.setPin1Off();
        return;
    end
    if strncmpi(on{3},str,max(size(str)))
        iiwa.setPin1On();
        return;
    end
    % pin 2
    if strncmpi(off{4},str,max(size(str)))
        iiwa.setPin2Off();
        return;
    end
    if strncmpi(on{4},str,max(size(str)))
        iiwa.setPin2On();
        return;
    end
end