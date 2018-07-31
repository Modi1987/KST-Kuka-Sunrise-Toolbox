function [Flag,outputCommand]=dialog_setOutput_To_CommandLine()
% Dialog box used by the user to change the logical state of the output of
% robot's touch-pneumatic flange

% Copyright: Mohammad SAFEEA, 2018-July-20

global daHandleof_dialog_set_output_to_command_line;
global dialog_set_output_to_command_line_button_hit;
global dialog_set_output_to_command_line_flag;
global dialog_set_output_to_command_line_outputStateWrite;
global dialog_set_output_to_command_line_outputChekcboxHandles;

dialog_set_output_to_command_line_button_hit=0;
dialog_set_output_to_command_line_flag=false;
dialog_set_output_to_command_line_outputStateWrite={};
dialog_set_output_to_command_line_outputChekcboxHandles=[];

%% Interface container
dialog_width=400;
dialog_height=300;
dialog_x0=10;
dialog_y0=100;
daCaption='Set outputs val';
jointAnglesDialogHandle=figure('Name',daCaption,'rend','painters','pos',[dialog_x0 dialog_y0 dialog_width dialog_height]);
daHandleof_dialog_set_output_to_command_line=jointAnglesDialogHandle;
pause(0.5);
%% Button dimension
enter_buttons_separator=40;
button_width=100;
button_height=50;
%% Add ok button
fcn=@callback_dialog_set_output_to_command_line_okBtn;
btn_ok_h= uicontrol(jointAnglesDialogHandle,'Style', 'pushbutton', 'String', 'OK',...
                'Units','pixels',...
                'Callback', fcn);
x0=round((dialog_width-enter_buttons_separator-button_width*2)/2);
xtemp=x0;
y0=enter_buttons_separator;
ytemp=y0;
btn_ok_h.HorizontalAlignment='center';
btn_ok_h.Position=[x0 y0 button_width button_height];  
%% Add cancel button
fcn=@callback_dialog_set_output_to_command_line_cancelBtn;
btn_cancel_h= uicontrol(jointAnglesDialogHandle,'Style', 'pushbutton', 'String', 'Cancel',...
                'Units','pixels',...
                'Callback', fcn);
x0=xtemp+enter_buttons_separator+button_width;
y0=ytemp;
btn_cancel_h.HorizontalAlignment='center';
btn_cancel_h.Position=[x0 y0 button_width button_height];  
%% Dimensions of lables and sliders,
labelsNum=4;
enter_controls_horizontal_margin=10;
x0=enter_controls_horizontal_margin;
y0=ytemp+button_height;

labels_width=170;
enter_labels_vertical_margin=20;
labels_height=(dialog_height-enter_labels_vertical_margin*(labelsNum+1)-y0)/labelsNum;

x0=(dialog_width-labels_width/2)/2;
%% Add lables and sliders,
h=daHandleof_dialog_set_output_to_command_line;
labels_text_array={'OuputPin_11','OuputPin_12','OuputPin_1','OuputPin_2'};

for i=1:4
    labels_text=labels_text_array{i};
    lbl_handle= uicontrol('Style','checkbox','String',labels_text, ...
                       'Value',0, 'Units','pixels');
    x_labels_0=x0;
    y_labels_0=y0+(enter_labels_vertical_margin)*i+(labels_height)*(i-1);
    lbl_handle.HorizontalAlignment='center';
    lbl_handle.Position=[x_labels_0 y_labels_0 labels_width labels_height];
    dialog_set_output_to_command_line_outputChekcboxHandles{i}=lbl_handle;
end

while(dialog_set_output_to_command_line_button_hit==0)
    figure(daHandleof_dialog_set_output_to_command_line)
    pause(0.1);
end
outputCommand=dialog_set_output_to_command_line_outputStateWrite;
Flag=dialog_set_output_to_command_line_flag;

clear daHandleof_dialog_set_output_to_command_line;
clear dialog_set_output_to_command_line_button_hit;
clear dialog_set_output_to_command_line_flag;
clear dialog_set_output_to_command_line_outputStateWrite;
end

function callback_dialog_set_output_to_command_line_okBtn(PushButton, EventData)
    global daHandleof_dialog_set_output_to_command_line;
    global dialog_set_output_to_command_line_button_hit;
    global dialog_set_output_to_command_line_flag;
    global dialog_set_output_to_command_line_outputStateWrite;
    global dialog_set_output_to_command_line_outputChekcboxHandles;
    
    
    y=[];
    labels_text_array={'OuputPin_11','OuputPin_12','OuputPin_1','OuputPin_2'};
    for i=1:4    
        h=dialog_set_output_to_command_line_outputChekcboxHandles{i};
        v=get(h,'Value');
        if v==1
            val='ON';
        else
            val='OFF';
        end
        y{i}=[labels_text_array{i},'_',val];
    end
    close(daHandleof_dialog_set_output_to_command_line);
    dialog_set_output_to_command_line_flag=true;
    dialog_set_output_to_command_line_outputStateWrite=y;
    dialog_set_output_to_command_line_button_hit=1;
end

function callback_dialog_set_output_to_command_line_cancelBtn(PushButton, EventData)
    global daHandleof_dialog_set_output_to_command_line;
    global dialog_set_output_to_command_line_button_hit;
    global dialog_set_output_to_command_line_flag;
    global dialog_set_output_to_command_line_outputStateWrite;
    
    close(daHandleof_dialog_set_output_to_command_line);
    dialog_set_output_to_command_line_flag=false;
    dialog_set_output_to_command_line_outputStateWrite=[];
    dialog_set_output_to_command_line_button_hit=1;
end