function mvt_ts(e,lag,tfig,s)
% function mvt_ts(e,lag,tfig,s) plots model validity tests for time series
%
% On entry
%       e   - residual sequence
%       lag - maximum lag considered
%       tfig - number of figure wherein the graphics will be ploted
%       s - (0) no title , (1) otherwise

% Eduardo Mendes - 25/01/94
% ACSE - Sheffield

if ((nargin < 1) | (nargin > 4))
	error('mvt_ts requires 1, 2, 3 or 4 input arguments.');
elseif nargin == 1
	lag=50; % This is considered the default value
	tfig=1;
	s=0;
elseif nargin == 2
	tfig=1;
	s=0;
elseif nargin == 3
	s=0;
end;

% Tests

[n,a]=size(e);

if ((n*a) > n)
	error('e must be a vector');
end;

if (a > n)
	e=e';  % Column vector.
	[n,a]=size(e);
end;

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

lag=floor(abs(lag));

l=ones(lag,1)*1.96/sqrt(n);

%for i=1:length(e)
%  e2(i)=(e(i)-me)^2;
%  es(i)=e(i)^2;
%end;

e2=(e-mean(e)).^2;
es=e.^2;

e2p=es-mean(es);

tfig=figure(tfig);clf;

if s == 0
	subplot(2,2,1); ccf([e e],lag,0,tfig,'(a)'); grid;
	subplot(2,2,2); ccf([e e2],lag,1,tfig,'(b)'); grid;
	subplot(2,2,3); ccf([e2p e2p],lag,0,tfig,'(c)'); grid;
else
	subplot(2,2,1); ccf([e e],lag,0,tfig,'e(t) X e(t)'); grid;
	subplot(2,2,2); ccf([e e2],lag,1,tfig,'e(t) X [e(t)-mean(e(t))]^2');
	grid;
	subplot(2,2,3); ccf([e2p e2p],lag,0,tfig,'[e(t)^2-mean(e(t)^2)] X [e(t)^2-mean(e(t)^2)]'); grid;
end;
