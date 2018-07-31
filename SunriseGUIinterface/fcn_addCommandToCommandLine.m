function fcn_addCommandToCommandLine(strArray)
%% About
% Adds commands into the command line

%% Areguments
% strArray: a string array, each element contains a command

% Copyright: Mohammad SAFEEA, 12-July-2018

% if aregument is null then return
if isempty(strArray)
    return;
end

% else add the commands into the command line
h=findobj(0,'tag','txt_CommandLine');
st=get(h,'String');

index=max(size(st));
n=max(size(strArray));

for i=1:n
    st{index+i}=strArray{i};
end

set(h,'String',st);

end