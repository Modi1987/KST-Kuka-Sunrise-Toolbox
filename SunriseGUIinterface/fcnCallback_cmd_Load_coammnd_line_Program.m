function fcnCallback_cmd_Load_coammnd_line_Program()
%% Load a pre-saved program into command-line

% Copyright: Mohammad SAFEEA, 2018-07-20

% Open file dialog, to select file to load
[file,path] = uigetfile('*.mat');
try
    if sum(sum([file,path] ))==0
        disp('No file was selected');
        return;
    end
catch
end

% Load file into the path
x=[];
currentPath=pwd;
try
    cd(path);
    x=load(file);
    cd(currentPath);
catch
    message='Can not load the file from the selected path';
    fcn_errorMessage(message);
    disp('Access denied, can not load file');
    cd(currentPath);
    return;
end


res=isfield(x,'iiwa_gui_commandLine_Ascii_Program20180720_Mo_Saf');
if res==0
    message='File is corrupted or a unsupported file format.';
    fcn_errorMessage(message);
    return;
end

% If checks are OK, load the pre-saved prgram into the command line
h=findobj(0,'tag','txt_CommandLine');

message='Do you really want to load the current file, this will delete any commands that already exists in the command line';
y=dialog_confirmationDialog(message);
if(y==1)
    strArray=x.iiwa_gui_commandLine_Ascii_Program20180720_Mo_Saf;
    set(h,'String',strArray);
end
end