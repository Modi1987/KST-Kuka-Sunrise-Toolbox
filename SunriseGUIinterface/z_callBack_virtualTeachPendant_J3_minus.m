function z_callBack_virtualTeachPendant_J3_minus()
%% Soft realtime joints control Joint X button callback
% Copyright: Mohammad SAFEEA, 27th-July-2018
global virtual_smartPad_w_joints_command;
disp('Moving J3 in negative direction');
virtual_smartPad_w_joints_command(3)=-1;
end