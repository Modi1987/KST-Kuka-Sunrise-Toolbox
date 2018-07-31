function fcnCallback_cmd_save_coammnd_line_Program()
%% Save a program into command-line

%% Copyright: Mohammad SAFEEA, 2018-07-20

% Open file dialog
[file,path] = uiputfile('*.mat','Save File AS');
try
    if sum(sum([file,path] ))==0
        disp('No file was selected');
        return;
    end
catch
end

% Get the program from the Command Line window
h=findobj(0,'tag','txt_CommandLine');
iiwa_gui_commandLine_Ascii_Program20180720_Mo_Saf=get(h,'String');

% Save file into the path
currentPath=pwd;
try
    cd(path);
    save(file,'iiwa_gui_commandLine_Ascii_Program20180720_Mo_Saf');
    cd(currentPath);
catch
    message='Can not save the file into the selected path';
    fcn_errorMessage(message);
    disp('Access denied, can not save file');
    cd(currentPath);
    return;
end

%isfield(x,'tty')

end