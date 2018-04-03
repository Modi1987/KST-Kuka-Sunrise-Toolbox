function [ flag ] = jointLimitReached( q )
% This function is used to signal whether the joint limit is reached,

% Arreguments:
% q: the joint angles.

% Output:
% flage: a boolean equal to false if the joint angle is not reached, true
% otherwise.

% Copyright Mohammad SAFEEA, 17th-Aug-2017
clearance=pi/24;
maxLimit=[170,120,170,120,170,120,175]-clearance*ones(1,7);
flag=false;
for i=1:7
    if(abs(q(i))>maxLimit(i))
        flag=true;
        return;
    end
end


end

