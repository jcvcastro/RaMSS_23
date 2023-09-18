function [x,y] = desloc (X,Y,ind)
% function [x,y] = desloc(X,Y,ind)
% This functions performs the shift of
% the vectors x and y using the indice ind
%
% ind > 0 means up
% ind < 0 means down

% Eduardo Mendes - March 13, 1992

n=length(X);
if ind > 0
   x=X(1:n-ind,:);
   y=Y(ind+1:n,:);
else
   ind=-ind;
   x=X(ind+1:n,:);
   y=Y(1:n-ind,:);
end
end;


