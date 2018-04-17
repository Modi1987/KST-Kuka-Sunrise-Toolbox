function CloseGripper(t_Kuka)
%% Copyright: Mohammad SAFEEA 11th-April-2018
setPin11Off(t_Kuka);
pause(1);
setPin1On(t_Kuka);
pause(1);
end