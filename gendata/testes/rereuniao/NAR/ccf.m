function r=ccf(c,lag,flag,tfig,s) 
% function r=ccf(c,lag,flag,s) calculates the correlation function
%       for the signals in the vector c.
% 
% On entry
%       c    - matrix which contains the signals, e.g, residuals.
%       lag  - maximum lag from which the ccf will be calculated
%       flag -  a scalar:
%               flag = 1 -> the ccf are calculated from -lag to lag
%               flag = 0 -> the ccf are calculated from 0 to lag
%       tfig - number of figure wherein the graphics will be ploted.
%       s    - title of the graphics
%
% On return
%       r - ccf
%
% Obs:. If no variable is to be returned the function will plot the ccf

 
% Luis Aguirre - Sheffield - may 91 
% Modified by E Mendes - 25/01/94

if ((nargin < 1) | (nargin > 5))
	error('ccf requires 1, 2, 3, 4 or 5 input arguments.');
elseif nargin == 1
	lag=50;  % This is considered the default value
	flag=0;   % This is considered the default value
	tfig =1;
	s=' ';
elseif nargin == 2
	flag=0;
	tfig=1;
	s=' ';
elseif nargin == 3
	tfig=1;
	s=' ';
elseif nargin == 4
	s=' ';
end;

if nargout > 1
	error('ccf requires one outpiut argument at most.');
end;

% Tests

[n,a]=size(c);

if a == 1
	c1=c(:,1);
	c2=c1;
else
	c1=c(:,1);
	c2=c(:,2);
end;

[a,b]=size(lag);

if ((a*b) == 0)
	lag=50;
elseif ((a*b) ~= 1)
	error('lag is a scalar');
end;

[a,b]=size(flag);

if ((a*b) == 0)
	flag=0;
elseif ((a*b) ~= 1)
	error('flag is a scalar');
end;

[a,b]=size(tfig);

if ((a*b) == 0)
	tfig=1;
elseif ((a*b) ~= 1)
	error('tfig is a scalar');
end;

% Calculations - Without the mean value
 
c1=c1-mean(c1); 
 
c2=c2-mean(c2);

flag1 = flag;

lag=floor(abs(lag));

 
cc1=cov(c1); 
cc2=cov(c2); 
m=floor(0.1*length(c1)); 
r12=covf([c1 c2],lag+1);
 
t=0:1:lag-1; 
l=ones(lag,1)*1.96/sqrt(length(c1)); 
 
% ccf 
 
% Mirror r12(3,:) in raux 

raux=zeros(1,lag+1);

for i=1:lag+1 
  raux(i)=r12(3,lag+2-i); 
end; 
 
r=[raux(1:length(raux)-1) r12(2,:)]/sqrt(cc1*cc2); 
 
% if plot 


if nargout == 0
 
% if -lag to lag 
  
  tfig=figure(tfig);
  c=sprintf('Correlation Function'); 
  set(tfig,'Name',c);

  if flag1 == 1, 
	t=-(lag):1:lag; 
	l=ones(2*lag+1,1)*1.96/sqrt(length(c1)); 
	plot(t,r,'k-',t,l,'k--',t,-l,'k--',0,1,'k.',0,-1,'k.'); 
 
    else 
	t=0:lag; 
	l=ones(lag+1,1)*1.96/sqrt(length(c1)); 
	plot(t,r12(2,1:lag+1)/sqrt(cc1*cc2),'k-',t,l,'k--',t,-l,'k--',0,1,'k.',0,-1,'k.');
 
  end; 

  title(s);
  xlabel('lag');
 
end; 

