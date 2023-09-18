function corr = correl(u1,u2,lag,type)
% function corr = correl(u1,u2,lag,type) calculates the correlation between
%       u1 and u2 up to the specified lag
%
% on entry
%       u1 - signal
%       u2 - signal
%       lag
%       type - (0) without mean, (1) with mean
%
% on return
%       corre 

% Eduardo Mendes - 1/07/93
% ACSE - Sheffield

if ( (nargin < 3) | (nargin > 4) )
	error('correl requires 3 or 4 input arguments.');
elseif nargin == 3
	type=1;
end;

N=length(u1);

if (N ~= length(u2))
	error('u1 and u2 must be of the same length');
end;

lag = floor(lag/2)*2 + 1;

corr=zeros(lag,1);

if type == 1

	u1mean=mean(u1);
	u2mean=mean(u2);

	x=u1-u1mean;
	y=u2-u2mean;
else
	x=u1;
	y=u2;
end;

d1=sum(x.^2);
d2=sum(y.^2);

for i=1:lag
	corr(i,1)=(x'*y)/sqrt(d1*d2);
	[x,y]=desloc(x,y,1);
end;

end;
