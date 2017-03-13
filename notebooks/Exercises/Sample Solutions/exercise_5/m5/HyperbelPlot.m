
function handle = HyperbelPlot(a1,a0, speed, Dt, limits,cl)
% a function to plot an hyperbel
if nargin < 5
    c = 'b';
    l = '-';
else
    c = cl(1);
    l = cl(2:end);
end
f = ['(sqrt( (',num2str(a1(1)),'-ax).^2+(',num2str(a1(2)),...
      '-ay).^2)-sqrt((',num2str(a0(1)),'-ax).^2+(',...
     num2str(a0(2)),'-ay).^2))./',num2str(speed),'-', num2str(Dt)];
xmin = limits(1);
xmax = limits(2);
ymin = limits(3);
ymax = limits(4);
handle =ezplot(f,[xmin,xmax,ymin,ymax]);
set(findobj(handle ,'Type','line'),'Color',c, 'LineStyle',l);
title('');
