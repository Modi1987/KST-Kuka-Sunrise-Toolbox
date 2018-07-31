function z_callBack_virtualTeachPendant_J4_minus()
%% Soft realtime joints control Joint X button callback
% Copyright: Mohammad SAFEEA, 27th-July-2018
global virtual_smartPad_w_joints_command;
disp('Moving J4 in negative direction');
virtual_smartPad_w_joints_command(4)=-1;
end