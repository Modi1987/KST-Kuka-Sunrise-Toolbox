function factor=jointLimitAvoidance(jointIndex,jPos,dq)
% Return the displacemnt according to joint limits
% Copyright Mohammad SAFEEA, 17th-Aug-2017
clearance=pi/24;
maxLimit=[170,120,170,120,170,120,175]-clearance*ones(1,7);
minLimit=-maxLimit;
i=jointIndex;
    if(abs(jPos{i}+dq)>maxLimit(i))
        factor=0;
    else
        factor=1;
    end
end