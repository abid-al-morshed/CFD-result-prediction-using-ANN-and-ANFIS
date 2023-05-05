function [p_ax,ch_ax]=ZoomPlot(p_ax)
% Interactive Zoom plot
% [p_ax,ch_ax]= ZoomPlot()
% [p_ax,ch_ax]= ZoomPlot(p_ax)
%
% This function allow you draw zoomed/magnified axes on a existing axes.
% The funciton gets its axes handle from gca() when called with no input
% arguments. This function should work for all 2D linear axes plots like
% plot(), scatter(), quiver().
%
% INPUTS:
%   p_ax - parent axes handle
%
%OUTPUTS:
%   p_ax: handle of the parent axes
%   ch_ax: handle of the child/Zoom axes
%
% Example 1: simple
% x = linspace(0,3*pi,200);
% y = [cos(x) + rand(1,200);cos(x+1) + rand(1,200)]; 
% figure,plot(x,y),title('Noisy cosines'),xlabel('x'),ylabel(y)
% ZoomPlot();
% %Follow the instructions on the title of the plot
%
% Example 2: create multiple zoomed axes and playing with handles
% x = linspace(0,3*pi,200);
% y = [cos(x) + rand(1,200);cos(x+1) + rand(1,200)]; 
% figure,plot(x,y),title('Noisy cosines'),xlabel('x'),ylabel(y)
% p_ax=gca;
% [p_ax,ch_ax1]=ZoomPlot(p_ax);
% %follow the instruction on the title of the plot
% [p_ax,ch_ax2]=ZoomPlot(p_ax);
% % set title and other properties with handle
% legend(p_ax,{'Cos','Shifted cos'})
% title(ch_ax1,'1st zoom plot')
% set(ch_ax1,'LineWidth',1.5,'XColor',lines(1),'YColor',lines(1))
% title(ch_ax2,'2nd zoom plot')
% 
% praveen.ivp@gmail.com
%

%customize the box around the zoom area and lines connecting the zoom axes
figH=gcf;
hold on
lines_cmap=lines(length(figH.Children));
zoomArea_para={'FaceAlpha',0,'Color',lines_cmap(end,:),'LineWidth',1.5};
line_para={'Color',lines_cmap(end,:),'LineWidth',1.5};

%gap on the top and right edges of zoom axes ROI for moving it
scf=[1 1 0.99 0.99];

switch nargin
    case 0
        p_ax=gca;
    case 1
        if(~isa(p_ax,'matlab.graphics.axis.Axes'))
            error('Input argument should be an Axis handle');
        end
    otherwise
        error('ZoomPlot accepts no argument or axes handle!')
end


%draw two ROI: first around the area to be zoomed and the second for the
%axes for the zoom plot
orig_title=p_ax.Title.String;
%turn off legend auto update
set(p_ax.Legend,'AutoUpdate','off');


title(p_ax,'Draw the first ROI around the area to be zoomed')
rect_zoom=drawrectangle(p_ax,zoomArea_para{:},'Selected',1,'Label','ZoomPlot_zoomarea','LabelVisible','off'); % select
title(p_ax,'Now draw the second ROI for the size and position ZOOM axes')
rect_axis=drawrectangle(p_ax,'FaceAlpha',0,'Color','red','Selected',1,'LineWidth',2,'Label','ZoomPlot_zoomaxis','LabelVisible','off');

% wait for resizinig/respositiong and update the plot
toggle_selected=@(~,~) toggleSelected(rect_zoom,rect_axis);
title(p_ax,'Great! adjust size/position and Click anywhere on the parent axes to confirm')
set(p_ax,'ButtonDownFcn',toggle_selected,'HitTest','on')

r1pos_old=zeros(1,4);
r2pos_old=zeros(1,4);
while(rect_axis.Selected )
    pause(0.1)
    if((~isequal(r2pos_old,rect_axis.Position) || ~isequal(r1pos_old,rect_zoom.Position)))
        if(exist('line1','var')), delete(line1),end
        if(exist('line2','var')), delete(line2),end
        if(exist('line3','var')), delete(line3),end
        if(exist('line4','var')), delete(line4),end
        if(exist('ch_ax','var')), delete(ch_ax),end
        
        
        %Caculate the position and size of zoom axis from the second ROI
        posax=scf.*[((rect_axis.Position(1)-p_ax.XLim(1))/diff(p_ax.XLim))*p_ax.Position(3)+p_ax.Position(1),...
            ((rect_axis.Position(2)-p_ax.YLim(1))/diff(p_ax.YLim))*p_ax.Position(4)+p_ax.Position(2),...
            rect_axis.Position(3)/(diff(p_ax.XLim)) *p_ax.Position(3),  ...
            rect_axis.Position(4)/(diff(p_ax.YLim)) *p_ax.Position(4)];
        
        %plot lines connecting two boxes
        %The following lines decide which vertices to be connected.
        vertices=[rect_zoom.Position(1:2);  rect_axis.Position(1:2);...
            rect_zoom.Position(1:2)+rect_zoom.Position(3:4) ;rect_axis.Position(1:2)+rect_axis.Position(3:4);...
            rect_zoom.Position(1:2)+[rect_zoom.Position(3),0] ;rect_axis.Position(1:2)+[rect_axis.Position(3),0];...
            rect_zoom.Position(1:2)+[0,rect_zoom.Position(4)] ;rect_axis.Position(1:2)+[0,rect_axis.Position(4)]; ]';
        if((vertices(1,5)<vertices(1,6) && vertices(2,5)<vertices(2,6)) || (vertices(1,5)>vertices(1,6) &&vertices(2,5)>vertices(2,6)) )
            line1= plot(p_ax,vertices(1,5:6),vertices(2,5:6),line_para{:},'DisplayName','ZoomPlot_line3');%l3
        end
        if((vertices(1,7)<vertices(1,8) &&vertices(2,7)<vertices(2,8)) || (vertices(1,7)>vertices(1,8) &&vertices(2,7)>vertices(2,8)))
            line2=plot(p_ax,vertices(1,7:8),vertices(2,7:8),line_para{:},'DisplayName','ZoomPlot_line2');%l2
        end
        if((vertices(1,1)>vertices(1,2) && vertices(2,1)<vertices(2,2)) || (vertices(1,1)<vertices(1,2) && vertices(2,1)>vertices(2,2)))
            line3=plot(p_ax,vertices(1,1:2),vertices(2,1:2),line_para{:},'DisplayName','ZoomPlot_line1');%l1
        end
        if((vertices(1,3)<vertices(1,4) &&vertices(2,3)> vertices(2,4)) || (vertices(1,3)>vertices(1,4) &&vertices(2,3)< vertices(2,4)))
            line4=plot(p_ax,vertices(1,3:4),vertices(2,3:4),line_para{:},'DisplayName','ZoomPlot_line4');%l4
        end
        
        ch_ax = axes('position',posax,'Selected','off','Layer','top','Box','on');
        
        %copy all children of parent axes except the ROIs and lines we created.
        Pax_children=copy(p_ax.Children);
        for i=1:length(Pax_children)
            if(isa(Pax_children(i),'images.roi.Rectangle'))
                if(~contains(Pax_children(i).Label,'ZoomPlot'))
                    copyobj(Pax_children(i),ch_ax)
                end
            elseif(isa(Pax_children(i),'matlab.graphics.chart.primitive.Line'))
                if(~contains(Pax_children(i).DisplayName,'ZoomPlot'))
                    copyobj(Pax_children(i),ch_ax)
                end
            else
                copyobj(Pax_children(i),ch_ax)
            end
        end
        %update the child axis
        xlim(ch_ax,[rect_zoom.Position(1) rect_zoom.Position(1)+rect_zoom.Position(3) ]);
        ylim(ch_ax,[rect_zoom.Position(2) rect_zoom.Position(2)+rect_zoom.Position(4) ]);
        r1pos_old=rect_zoom.Position;
        r2pos_old=rect_axis.Position;
    end
end

% remove second ROI
set(rect_axis,'Visible','off')
%restore the original title
title(p_ax,orig_title)
%restore the size of child axis
set(ch_ax,'position',posax./scf)

% remove label and interaction handles from the ROIs
set(rect_zoom,'InteractionsAllowed','none')
%set(rect_zoom,'Label','')
set(rect_axis,'InteractionsAllowed','none')
%set(rect_axis,'Label','')
end


function toggleSelected(roi1,roi2)
set(roi1,'Selected',0)
set(roi2,'Selected',0)
disp('finished')
end