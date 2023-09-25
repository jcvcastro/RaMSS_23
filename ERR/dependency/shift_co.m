function newcol = shift_co(oldcol,lag)
% function newcol = shift_col(oldcol,lag) shifts oldcol by lag.
%
% Obs.:   Function used in build_process and build_noise

% Eduardo Mendes - 11/08/94
% ACSE - Sheffield

if nargin ~= 2
	error('shift_col requires two input arguments.');
end;

[n,a]=size(oldcol);

if a ~= 1
	error('oldcol is a column vector.');
end;

[a,b]=size(lag);

if ((a*b) ~= 1)
	error('lag is a scalar.');
end;

if lag < 0
	error('lag is positive.');
end;

newcol=zeros(n,1);

newcol(lag+1:n,1)=oldcol(1:n-lag,1);
