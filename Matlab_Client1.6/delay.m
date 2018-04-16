function delay(delayTime)
%% This function is used to introduce some delay
% delayTime: is the time of delay in seconds

% Copyright: Mohammad SAFEEA, 9th-April-2018

a=datevec(now);
t0=a(6)+a(5)*60+a(4)*60*60; % calculate initial time
t=t0;
while(t-t0<delayTime)
a=datevec(now);
t=a(6)+a(5)*60+a(4)*60*60; % calculate initial time
end


end

