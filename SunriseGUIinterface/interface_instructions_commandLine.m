% Command Line interface
function interface_instructions_commandLine(main_frame_h,frame_width,frame_height,instruction_text_width,...
    instruction_text_height,instruction_text_margin )
%% About:
% This function is used to show the instructions implemented by the user to
% control the robot.


%% ABout listbox:
% https://www.mathworks.com/help/matlab/creating_guis/interactive-list-box-in-a-guide-gui.html

MyBox = uicontrol(main_frame_h,'style','listbox');
set(MyBox,'Max',1000);
set(MyBox, 'Units','pixels');
set(MyBox, 'tag','txt_CommandLine');
set(MyBox, 'HorizontalAlignment','left');
xpos=frame_width-instruction_text_width-instruction_text_margin;
ypos=instruction_text_margin;
xsize=instruction_text_width;
ysize=instruction_text_height;
set(MyBox,'Position',[xpos,ypos,xsize,ysize]);

end

