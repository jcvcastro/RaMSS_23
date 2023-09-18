function s1 = reblank(s)
% function s1 = reblank(s) removes all blank from a given string

% Eduardo Mendes - 16/08/94
% ACSE - Sheffield

if nargin ~= 1
	error('reblank requires 1 input argument.');
end;

[a,n]=size(s);

if (a ~= 1)
	error('s is a row string.');
end;

s(s == ' ')=[];

s1=s;


end;

