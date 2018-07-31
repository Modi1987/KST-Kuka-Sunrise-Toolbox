global iiwa;
global isConnected;
global read_state_var;
iiwa=[];
isConnected=false;
read_state_var=false;
%% Feedback values
global feedback_eef_pos;
global feedback_jpos;
feedback_eef_pos=[];
feedback_jpos=[];
%% Interface container
main_frame_width=1200;
main_frame_height=600;
main_frame_x0=10;
main_frame_y0=100;
daCaption='LBR_GUI_interface';
main_frame_h=figure('Name',daCaption,'rend','painters','pos',[main_frame_x0 main_frame_y0 main_frame_width main_frame_height]);
fcn=@closeMainScript;
set(main_frame_h,'CloseRequestFcn',fcn);  % add confirmation dialog to closing the GUI
pause(1);
%% Hand guiding home interface
interface_handguiding_home(main_frame_h)
%% Connection interface
connection_panel_width=400;
connection_panel_height=250;
connection_panel_margin=20;
interface_connection(main_frame_h,main_frame_width,main_frame_height,connection_panel_width,...
    connection_panel_height,connection_panel_margin);
%% Feedback interface
feedback_panel_width=500;
feedback_panel_height=350;
feedback_panel_margin=20;
interface_feedback_panel(main_frame_h, main_frame_width,main_frame_height,feedback_panel_width,...
    feedback_panel_height,feedback_panel_margin);
%% Buttons for adding points to command line
motionCommand_panel_width=220;
motionCommand_panel_height=230;

xPos=main_frame_width-motionCommand_panel_width-feedback_panel_width-2*feedback_panel_margin;
yPos=main_frame_height-motionCommand_panel_height-feedback_panel_margin;

interface_motionCommand_panel(main_frame_h, main_frame_width,main_frame_height,...
    xPos,yPos,motionCommand_panel_width,...
    motionCommand_panel_height);
%% Command line interface
commandLine_width=500;
commandLine_height=200;
commandLine_margin=20;
interface_instructions_commandLine(main_frame_h, main_frame_width,main_frame_height,commandLine_width,...
    commandLine_height,commandLine_margin );
%% Buttons to execute commandLine program
h=main_frame_h;
executeCommandLine_panel_width=motionCommand_panel_width;
executeCommandLine_panel_height=commandLine_height;
xPos=main_frame_width-commandLine_margin-commandLine_width-commandLine_margin-executeCommandLine_panel_width;
yPos=commandLine_margin;
interface_executeCommandLine_panel(h,xPos,yPos,executeCommandLine_panel_width,...
    executeCommandLine_panel_height)
%% Buttons to save/load a program from commandLine
h=main_frame_h;
loadSave_commandLine_Panel_width=motionCommand_panel_width/2;
loadSave_commandLine_Panel_height=commandLine_height;
xPos=main_frame_width...
    -commandLine_margin-commandLine_width...
    -commandLine_margin-executeCommandLine_panel_width...
    -loadSave_commandLine_Panel_width-commandLine_margin;
yPos=commandLine_margin;
interface_save_load_CommandLine_program_panel(h,xPos,yPos,loadSave_commandLine_Panel_width,...
    loadSave_commandLine_Panel_height)