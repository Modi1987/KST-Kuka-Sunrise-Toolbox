% Buttons for loading/saving a prgram from commandLine
function interface_save_load_CommandLine_program_panel(h,xPos,yPos,loadSave_commandLine_Panel_width,...
    loadSave_commandLine_Panel_height)
%% About:
% Construct the interface-panel for load/save a program from commandLine
% interface

%% Areguments:
% h: handle of the main frame
% frame_width: width of the main frame (pixels)
% frame_height: height of the main frame (pixels)

% Copyright: Mohammad SAFEEA, 20th-July-2018

panel_Width=loadSave_commandLine_Panel_width;
panel_height=loadSave_commandLine_Panel_height;

x0=xPos;
y0=yPos;

pnl_h = uipanel(h,'Title','My Programs',...
                'Units','pixels');
            %     'FontSize',12,...
            %    'BackgroundColor','white',...
pnl_h.Position=[x0 y0 panel_Width panel_height];

% number of buttons
I=2;
J=1;
% separation ratio
rh=0.1;
rv=0.3;
btns_width=panel_Width/(J+(J+1)*rh);
btns_height=panel_height/(I+(I+1)*rv);

texts={'Load Program';
        'Save program'};

callback_functions={'fcnCallback_cmd_Load_coammnd_line_Program';
    'fcnCallback_cmd_save_coammnd_line_Program'};

icon_image={'icon_load.jpeg';
    'icon_save.jpeg'};
handles_Array=[];
for i=1:I
    for j=1:J
        labels_text=texts{i,j};
        btn_handle= uicontrol(pnl_h,'Style', 'pushbutton', 'String', labels_text,...
                'Units','pixels',...
                'Callback', callback_functions{i,j});
        x0=panel_Width-(btns_width*(1+rh))*(J+1-j);
        y0=panel_height-(btns_height*(1+rv))*(i)-0.5*rv*btns_height;
        btn_handle.HorizontalAlignment='center';
        btn_handle.Position=[x0 y0 btns_width btns_height];
        btn_handle.FontWeight='bold';
        % Add an icon to the button
        cd icons;
        d1=0;
        if btns_width<btns_height
            d1=btns_width;
        else
            d1=btns_height;
        end
        imageName=icon_image{i,j};
        addImageToButton(btn_handle,imageName,d1);
    end
end

end

function addImageToButton(btn_handle,imageName,d1)
        im=imread(imageName);
        scaleFactor=d1/max(max(max(size(im))));
        width=scaleFactor*size(im,2);
        width=floor(width);
        height=scaleFactor*size(im,1);
        height=floor(height);
        im2 = imresize(im,[width,height]);
        set(btn_handle,'CData',im2);
        cd ..;
end