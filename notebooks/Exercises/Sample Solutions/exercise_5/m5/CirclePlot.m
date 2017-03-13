function handle = CirclePlot(p,radius, cl)
% function CirclePlot(x,radius,cl)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function plot of cicle/ellips defined by
% p,radius:
% (p(1)-x)^2 + (p(2)-y)^2 = radius^2
% color and linestyle can be specified, too
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 2
    c = 'b';
    l = '-';
else
    c = cl(1);
    l = cl(2:end);
end
f = ['(',num2str(p(1)),'-x).^2 + (',...
         num2str(p(2)),'-y).^2 - (',num2str(radius),').^2'];
xmin = p(1) - radius - 2;
xmax = p(1) + radius + 2;
ymin = p(2) - radius - 2;
ymax = p(2) + radius + 2;
handle =ezplot(f,[xmin,xmax,ymin,ymax]);
set(findobj(handle ,'Type','line'),'Color',c, 'LineStyle',l);
title('');