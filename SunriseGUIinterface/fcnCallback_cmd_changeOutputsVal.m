function fcnCallback_cmd_changeOutputsVal()


% Copyright: Mohammad SAFEEA, 20-July-2018

[flag,string_array]=dialog_setOutput_To_CommandLine();
if flag==false
    return;
else
    fcn_addCommandToCommandLine(string_array);
end
end