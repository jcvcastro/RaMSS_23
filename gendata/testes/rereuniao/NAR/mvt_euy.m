function [corr,lag] = mvt_euy(e,u,y,lag,tfig,s)
% function [corr,lag] = mvt_euy(e,u,y,lag,tfig,s) plots validity tests
%
% Usage:
%       corr=mvt_euy(e);
%       corr=mvt_euy(e,lag, ...)
%       corr=mvt_euy(e,u,lag, ...)
%       corr=mvt_euy(e,u,y,lag, ...)
%
% On entry
%       e       - residual sequence
%       u       - input
%       y       - output
%       lag     - maximum lag considered
%       tfig    - number of figure wherein the graphics will be ploted
%       s - (0) no title , (1) otherwise

% Eduardo Mendes - 25/01/94
% ACSE - Sheffield

if ((nargin < 1) | (nargin > 6))
	error('mvt_euy requires 1, 2, 3, 4, 5 or 6 input arguments.');
elseif nargin == 1
	u=0*e;
	y=0*e;
	lag=20;
	tfig=1;
	s=0;
	flag=1;
elseif nargin == 2
	[a,b]=size(u);
	y=0*e;
	if ((a*b) == 1)
		lag=u;
		u=0*e;
		flag=1;
	else
		lag=20;
		flag=2;
	end;
	tfig=1;
	s=0;
elseif nargin == 3
	[a,b]=size(y);
	if ((a*b) == 1)
		lag=y;
		y=0*e;
		flag=2;
	else
		lag=20;
		if isempty(u)
			u=0*e;
			flag=1;
		else
			flag=3;
		end;
	end;
	tfig=1;
	s=0;
elseif nargin == 4
	[a,b]=size(u);
	if ((a*b) == 1)
		s=lag;
		tfig=y;
		lag=u;
		u=0*e;
		y=0*e;
		flag=1;
	else
		[a,b]=size(y);
		if ((a*b) == 1)
			s=0;
			tfig=lag;
			lag=y;
			y=0*e;
			flag=2;
		else
			s=0;
			if isempty(u)
				u=0*e;
				flag=1;
			else
				flag=3;
			end;
			tfig=1;
		end;
	end;
elseif nargin == 5
	[a,b]=size(y);
	if ((a*b) == 1)
		s=tfig;
		tfig=lag;
		lag=y;
		y=0*e;
		flag=2;
	else
		s=0;
		if isempty(u)
			u=0*e;
			flag=1;
		else
			flag=3;
		end;
	end;
end;

% Tests

[ny,a]=size(y);

if ((ny*a) > ny)
	error('y must be a vector');
end;

if (a > ny)
	y=y';  % Column vector.
	[ny,a]=size(y);
end;

[nu,a]=size(u);

if ((nu*a) > nu)
	error('u must be a vector');
end;

if (a > nu)
	u=u';  % Column vector.
	[nu,a]=size(u);
end;

[ne,a]=size(e);

if ((ne*a) > ne)
	error('e must be a vector');
end;

if (a > ne)
	e=e';  % Column vector.
	[ne,a]=size(e);
end;


if (ny ~= nu)
	error('y and u are incompatible.');
end;

if (ny ~= ne)
	error('y and e are incompatible.');
end;

n=ny;


[a,b]=size(lag);

if ((a*b) == 0)
	lag=50;
elseif ((a*b) ~= 1)
	error('lag is a scalar');
end;

[a,b]=size(tfig);

if ((a*b) == 0)
	tfig=1;
elseif ((a*b) ~= 1)
	error('tfig is a scalar');
end;

% calculations

isym=[1 1 0 0 0 1 0 1 1];

lag=floor(lag/2)*2+1;


b=[lag 1 1 n isym]';    % last Column of corr

if flag == 1
	%
	%  Time Series
	%
	if isempty(find(y ~= 0))
		corr=zeros(max([lag length(b)]),3+1);
		a=correl(e,e,lag);
		corr(1:length(a),1)=a;
		a=correl(e,e.^2,lag);
		corr(1:length(a),2)=a;
		a=correl(e.^2,e.^2,lag);
		corr(1:length(a),3)=a;
		corr(1:length(b),4)=b;
	else
		corr=zeros(max([lag length(b)]),4+1);
		a=correl(e,e,lag);
		corr(1:length(a),1)=a;
		a=correl(e,e.^2,lag);
		corr(1:length(a),2)=a;
		a=correl(e.^2,e.^2,lag);
		corr(1:length(a),3)=a;
		a=correl(y.*e,e.^2,lag,1);
		corr(1:length(a),4)=a;
		corr(1:length(b),5)=b;
	end;
elseif flag == 2
	%
	%  Eight Validation Tests - No output included
	%
	corr=zeros(max([lag length(b)]),8+1);
	a=correl(e,e,lag,0);
	corr(1:length(a),1)=a;
	a=correl(e,shift_co(u.*e,-1),lag,0);
	corr(1:length(a),2)=a;
	a=correl(e,u,lag,0);
	corr(1:length(a),3)=a;
	a=correl(e,u.*u,lag);
	corr(1:length(a),4)=a;
	a=correl(e.*e,u.*e,lag);
	corr(1:length(a),5)=a;
	a=correl(e,e,lag);
	corr(1:length(a),6)=a;
	a=correl(e,e.^2,lag);
	corr(1:length(a),7)=a;
	a=correl(e.^2,e.^2,lag);
	corr(1:length(a),8)=a;
	corr(1:length(b),9)=b;
else
	%
	%  Ten Validation Tests - Ouput
	%
	corr=zeros(max([lag length(b)]),10+1);
	a=correl(e,e,lag,0);
	corr(1:length(a),1)=a;
	a=correl(e,shift_co(u.*e,-1),lag,0);
	corr(1:length(a),2)=a;
	a=correl(e,u,lag,0);
	corr(1:length(a),3)=a;
	a=correl(e,u.*u,lag,1);
	corr(1:length(a),4)=a;
	a=correl(e.*e,u.*e,lag,1);
	corr(1:length(a),5)=a;
	a=correl(e,e,lag,1);
	corr(1:length(a),6)=a;
	a=correl(e,e.^2,lag,1);
	corr(1:length(a),7)=a;
	a=correl(e.^2,e.^2,lag,1);
	corr(1:length(a),8)=a;
	a=correl(y.*e,e.^2,lag,1);
	corr(1:length(a),9)=a;
	a=correl(y.*e,u.^2,lag,1);
	corr(1:length(a),10)=a;
	corr(1:length(b),11)=b;
end;
	
if nargout == 0
	plotcro(corr);
end;
