function fcnCallback_stateTimer()
%% About:
% call back to read state of the robot

% Copyright: Mohammad SAFEEA, 10th-July-2018

global read_state_var
global executionNum;
global iiwa;



global txt_torque_Handles;
global txt_jpos_Handles;
global txt_pos_Handles;

global feedback_eef_pos;
global feedback_jpos;

% if (read_state_var==false) do not update
if read_state_var==false
    return;
end

if executionNum==0
    jPos = iiwa.getJointsPos();
    executionNum=executionNum+1;
    for i=1:7
        h=txt_jpos_Handles{i};
        feedback_jpos{i}=jPos{i};
        temp=jPos{i}*180/pi;
        st=sprintf('%0.2fS',temp);
        set(h,'String',st);
    end
end

if executionNum==1
    taw=iiwa.getJointsExternalTorques();
    executionNum=executionNum+1;
    for i=1:7
        h=txt_torque_Handles{i};
        st=sprintf('%0.2fS',taw{i});
        set(h,'String',st);
    end
end

if executionNum==2
    pos=iiwa.getEEFPos();
    executionNum=0;
    for i=1:6
        h=txt_pos_Handles{i};
        feedback_eef_pos{i}=pos{i};
        if i<4
            temp=pos{i};
            st=sprintf('%0.2fS',temp);
        else
            temp=pos{i}*180/pi;
            st=sprintf('%0.2fS',temp);
        end
        set(h,'String',st);
    end
end 

end