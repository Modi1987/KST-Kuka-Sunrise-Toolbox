function [Flag,EEF_Pose_Coordiantes]=dialog_EEFPoseInput()
% Dialog box used by the user to enter the values of the joint angles of the robot.

% Copyright: Mohammad SAFEEA, 2018-July-20

global daHandleof_dialog_EEFPoseInput;
global dialog_EEFPoseInput_button_hit;
global dialog_EEFPoseInput_flag;

dialog_EEFPoseInput_button_hit=0;
dialog_EEFPoseInput_flag=false;
dialog_EEFPoseInput_Coordinates={};
%% Interface container
dialog_width=540;
dialog_height=500;
dialog_x0=10;
dialog_y0=100;
daCaption='EEF Position (mm)/Orientation (degree)';
jointAnglesDialogHandle=figure('Name',daCaption,'rend','painters','pos',[dialog_x0 dialog_y0 dialog_width dialog_height]);
daHandleof_dialog_EEFPoseInput=jointAnglesDialogHandle;
%% Button dimension
enter_buttons_separator=40;
button_width=100;
button_height=50;
%% Add ok button
fcn=@callback_dialog_jointAnlgesInput_okBtn;
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
fcn=@callback_dialog_jointAnlgesInput_cancelBtn;
btn_cancel_h= uicontrol(jointAnglesDialogHandle,'Style', 'pushbutton', 'String', 'Cancel',...
                'Units','pixels',...
                'Callback', fcn);
x0=xtemp+enter_buttons_separator+button_width;
y0=ytemp;
btn_cancel_h.HorizontalAlignment='center';
btn_cancel_h.Position=[x0 y0 button_width button_height];  
%% Dimensions of lables and sliders,
labelsNum=6;
enter_controls_horizontal_margin=10;
x0=enter_controls_horizontal_margin;
y0=ytemp+button_height;

labels_width=100;
enter_labels_vertical_margin=30;
labels_height=(dialog_height-enter_labels_vertical_margin*(labelsNum+1)-y0)/labelsNum;

grandSliderWidth=280;
smallSliderWidth=220;
sliderHeight=labels_height;
slider_mid_coordinate=275;
%% Sliders handles
sliders_handles=[];
angle_value_texts_handles=[];
%% Add lables and sliders,
h=daHandleof_dialog_EEFPoseInput;
labels_text_array={'X','Y','Z','alfa','beta','gama'};
for i=1:6
    labels_text=labels_text_array{6-i+1};
    lbl_handle= uicontrol(h,'Style', 'text', 'String', labels_text,...
            'Units','pixels');
    x_labels_0=x0;
    y_labels_0=y0+(enter_labels_vertical_margin)*i+(labels_height)*(i-1);
    lbl_handle.HorizontalAlignment='center';
    lbl_handle.Position=[x_labels_0 y_labels_0 labels_width labels_height];
    lbl_handle.Enable='inactive';
    
    %% Add slider and its labels
    minString='';
    maxString='';
    if i>3
        slider_width=grandSliderWidth;
        min=-800;
        max=800;
        minString=[num2str(min)];
        maxString=[num2str(max)];
    else
        slider_width=smallSliderWidth;
        min=-180;
        max=180;
        minString=[num2str(min),char(176)];
        maxString=[num2str(max),char(176)];
    end
    x_Slider=getXCoordiantesFromMidWidth(slider_mid_coordinate,slider_width);
    y_Slider=y_labels_0;
    silder_handle = uicontrol('Parent',h,'Style','slider',...
         'Units','pixels', ...
        'Position',[x_Slider,y_Slider,slider_width,sliderHeight],...
              'min',min, 'max',max);
    sliders_handles{i}=silder_handle;
          %% Min labels
    minmaxLablesWidth=50;
    minmaxLabelHeight=sliderHeight;
    min_labels_x=x_Slider - minmaxLablesWidth;
    tempPos=[min_labels_x,y_Slider,minmaxLablesWidth,minmaxLabelHeight];
    bl1 = uicontrol(h,'Style','text',...
        'Units','pixels', ...
        'Position',tempPos,...
        'String',minString);
    
          %% Max labels
    max_labels_x=x_Slider +slider_width ;
    tempPos=[max_labels_x,y_Slider,minmaxLablesWidth,minmaxLabelHeight];
    bl1 = uicontrol(h,'Style','text',...
        'Units','pixels', ...
        'Position',tempPos,...
        'String',maxString);

    %% Angle value text
    labelsWidth=80;
    angle_val_label_x=dialog_width-labelsWidth ;
    tempPos=[angle_val_label_x,...
        y_Slider,...
        labelsWidth,minmaxLabelHeight];
    angle_value_text_handle = uicontrol(h,'Style','text',...
        'Units','pixels', ...
        'Position',tempPos,...
        'String',num2str(0.0));
           angle_value_texts_handles{i} =angle_value_text_handle;
end

%% Initiate the sliders positions
global iiwa;
pos=iiwa.getEEFPos();
for i=1:6
    if i>3
        pos{i}=pos{i}*180/pi;
    end
    temp_handle=sliders_handles{6-i+1};
    set(temp_handle,'Value',pos{i});
end

%% control loop
tempJointAngles={1,2,3,4,5,6};
while(dialog_EEFPoseInput_button_hit==0)
    figure(daHandleof_dialog_EEFPoseInput)
    pause(0.1);
    try
    for i=1:6
        % get value of the slider
        temp_handle=sliders_handles{i};
        val=get(temp_handle,'Value');
        tempJointAngles{6-i+1}=val;
        % through the value into the textbox
        temp_handle=angle_value_texts_handles{i} ;
%         numString=num2str(val)
        numString=sprintf('%0.2f',val);
        set(temp_handle,'String',numString);
        dialog_EEFPoseInput_Coordinates=tempJointAngles;
    end
    catch
        break;
    end
end

for i=4:6
    dialog_EEFPoseInput_Coordinates{i}=dialog_EEFPoseInput_Coordinates{i}*pi/180;
end

EEF_Pose_Coordiantes=dialog_EEFPoseInput_Coordinates;
Flag=dialog_EEFPoseInput_flag;

clear daHandleof_dialog_EEFPoseInput;
clear dialog_EEFPoseInput_button_hit;
clear dialog_EEFPoseInput_flag;
clear dialog_EEFPoseInput_Coordinates;
end

function callback_dialog_jointAnlgesInput_okBtn(PushButton, EventData)
    global daHandleof_dialog_EEFPoseInput;
    global dialog_EEFPoseInput_button_hit;
    global dialog_EEFPoseInput_flag;
    
    close(daHandleof_dialog_EEFPoseInput);
    dialog_EEFPoseInput_flag=true;
    dialog_EEFPoseInput_button_hit=1;
end

function callback_dialog_jointAnlgesInput_cancelBtn(PushButton, EventData)
    global daHandleof_dialog_EEFPoseInput;
    global dialog_EEFPoseInput_button_hit;
    global dialog_EEFPoseInput_flag;
    
    close(daHandleof_dialog_EEFPoseInput);
    dialog_EEFPoseInput_flag=false;
    dialog_EEFPoseInput_button_hit=1;
end

function x=getXCoordiantesFromMidWidth(mid,width)
x=mid-width/2;
end