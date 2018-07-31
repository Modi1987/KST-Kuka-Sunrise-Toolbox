function fcn_add_icons_to_buttons()
%% About:
% Method used to add icons to buttons in the interface

cd icons;
% Add icon to off-shelf hand guiding
h=findobj(0, 'tag', 'btn_handGuiding');
im=imread('icon_off_shelf_handguiding.png');
pos=get(h,'Position');
width=pos(3);
height=pos(4);
im = imresize(im,[width,height]);
set(h,'CData',im);

% Add icon to precise hand guiding
h=findobj(0, 'tag', 'btn_preciseHG');
im=imread('icon_precise_handguiding.png');
pos=get(h,'Position');
width=pos(3);
height=pos(4);
im = imresize(im,[width,height]);
im2 = imadjust(im,[.0 .0 0; .6 .6 .6],[]);
set(h,'CData',im2);

% Add icon to home
h=findobj(0, 'tag', 'btn_home');
im=imread('icon_home.png');
pos=get(h,'Position');
width=pos(3);
height=pos(4);
im = imresize(im,[width,height]);
im2 = imadjust(im,[.0 .0 0; .6 .6 .6],[]);
set(h,'CData',im2);
% Add icon to virtual teach pendant
h=findobj(0, 'tag', 'btn_virtualTeachPendant');
im=imread('icon_teachPendant.jpeg');
pos=get(h,'Position');
width=pos(3);
height=pos(4);
im = imresize(im,[width,height]);
im2 = imadjust(im,[.0 .0 0; .6 .6 .6],[]);
set(h,'CData',im2);

cd ..;
end

