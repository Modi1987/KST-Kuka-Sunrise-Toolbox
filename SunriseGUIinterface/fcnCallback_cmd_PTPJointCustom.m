function fcnCallback_cmd_PTPJointCustom()
%% Adds motion command to commandline
% The motion command is point to point line.

[Flag,jAngle]=dialog_jointAnlgesInput();
if Flag==false
    return;
end

costumJpos=jAngle;
if exist('costumJpos')
else
    disp('Error in {fcnCallback_cmd_PTPJointCurrent}')
    disp('Variable {costumJpos} does not exist or cleared')
    return;
end

if isempty(costumJpos)
    disp('Error in {fcnCallback_cmd_PTPJointCurrent}')
    disp('Variable {costumJpos} is empty')
    return;
end

if max(size(costumJpos))==7
    for i=1:7
        costumJpos{i}=costumJpos{i};
    end
    fcn_addToTextboxJointsPTPMotion(costumJpos)
else
    disp('Error in {fcnCallback_cmd_PTPJointCurrent}')
    disp('Variable {costumJpos} is not right size')   
end

end