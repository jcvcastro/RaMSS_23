From aguirre@uirapuru.cpdee.ufmg.br Thu Mar 23 15:53 SAT 1995
Received: by uirapuru.cpdee.ufmg.br
	(16.7/16.2) id AA14558; Thu, 23 Mar 95 15:53:50 -0300
From: Luis Aguirre <aguirre@uirapuru.cpdee.ufmg.br>
Return-Path: <aguirre@uirapuru.cpdee.ufmg.br>
Message-Id: <9503231853.AA14558@uirapuru.cpdee.ufmg.br>
Subject: validacao
To: giovani@uirapuru.cpdee.ufmg.br
Date: Thu, 23 Mar 95 15:53:50 SAT
Mailer: Elm [revision: 66.33]
Status: RO

Giovani,  

O Eduardo mandou mais um tanto de rotinas para fazer a
validacao. Estao todas juntas logo a seguir. Salve este
arquivo, separe as rotinas e lembre-se de "deletar" 
os cabecalhos. Eh importante salvar cada rotina com
o mesmo nome encontrado na primeira linha (i.e., definicao
de function) e com extensao ".m" assim sera possivel
utiliza-las diretamente.

Um abraco,

Luis


----------
X-Sun-Data-Type: default-app
X-Sun-Data-Name: mvt_euy.m
X-Sun-Content-Lines: 261

function [corr,lag] = mvt_euy(e,u,y,lag,tfig,s)
% function [corr,lag] = mvt_euy(e,u,y,lag,tfig,s) plots validity tests
%
% Usage:
%	corr=mvt_euy(e);
%	corr=mvt_euy(e,lag, ...)
%	corr=mvt_euy(e,u,lag, ...)
%	corr=mvt_euy(e,u,y,lag, ...)
%
% On entry
%	e   	- residual sequence
%	u	- input
%	y	- output
%	lag 	- maximum lag considered
%	tfig 	- number of figure wherein the graphics will be ploted
%	s - (0) no title , (1) otherwise

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


b=[lag 1 1 n isym]';	% last Column of corr

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


end;
----------
X-Sun-Data-Type: default-app
X-Sun-Data-Name: mvt_ts.m
X-Sun-Content-Lines: 84

function mvt_ts(e,lag,tfig,s)
% function mvt_ts(e,lag,tfig,s) plots model validity tests for time series
%
% On entry
%	e   - residual sequence
%	lag - maximum lag considered
%	tfig - number of figure wherein the graphics will be ploted
%	s - (0) no title , (1) otherwise

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
	subplot(2,2,1); ccf([e e],lag,0,tfig); grid;
	subplot(2,2,2); ccf([e e2],lag,1,tfig); grid;
	subplot(2,2,3); ccf([e2p e2p],lag,0,tfig); grid;
else
	subplot(2,2,1); ccf([e e],lag,0,tfig,'e(t) X e(t)'); grid;
	subplot(2,2,2); ccf([e e2],lag,1,tfig,'e(t) X [e(t)-mean(e(t))]^2');
        grid;
	subplot(2,2,3); ccf([e2p e2p],lag,0,tfig,'[e(t)^2-mean(e(t)^2)] X [e(t)^2-mean(e(t)^2)]'); grid;
end;

end;
----------
X-Sun-Data-Type: default-app
X-Sun-Data-Name: plotcro.m
X-Sun-Content-Lines: 107

function x = plotcro(corr,ngp,y)
% function plotcro(corr,ngp,y) plots correlation tests   
%
% On entry
%	Corr is a matrix with all correlation tests. (crocor41) 
%	ngp - number of graphics per page
%	y - print option. In order to print the graphics make y = 'y'
%


% Eduardo Mendes - 8/12/92
% Sheffield - ACSE

if nargin == 2
	y='n';
elseif (nargin == 1)
	y='n';
	ngp = 6;
elseif ((nargin < 1) | (nargin > 3))
	error('plotcro requires 1, 2 or 3 input arguments.');
end;

if ngp > 1
	ngpa = floor(ngp/2)*2;
else
	ngpa = 1;
end;

[Npc,nn]=size(corr);

Npc=corr(1,nn);

N=corr(4,nn);

n1=(-floor(Npc/2):1:floor(Npc/2));n2=0:1:2*floor(Npc/2);
n3=(1.96/sqrt(N))*ones(length(n1),1);
n4=-n3;

ntfig = floor((nn-1)/ngpa) + 1;
tfig = 1:1:ntfig;

nsuby = corr(2,nn);
nsubu = corr(3,nn);

% To build up the strings

S=[];

s=sprintf('    (e)X(e)     ');
S=str2mat(S,s);
s=sprintf('    (u)X(e)     ');
S=str2mat(S,s);
s=sprintf('   (e)X(eu)    ');
S=str2mat(S,s);
s=sprintf(' (u^2-mean)X(e) ');
S=str2mat(S,s);
s=sprintf('(u^2-mean)X(e^2)');
S=str2mat(S,s);
s=sprintf('    (e-mean)X(e-mean)     ');
S=str2mat(S,s);
s=sprintf('    (e-mean)X(e^2-mean)     ');
S=str2mat(S,s);
s=sprintf('    (e^2-mean)X(e^2-mean)     ');
S=str2mat(S,s);
s=sprintf('(ye-mean)X(e^2-mean)');
S=str2mat(S,s);
s=sprintf('(ye-mean)X(u^2-mean)');
S=str2mat(S,s);

[a,b]=size(S);S=S(2:a,:);



k=1;

for j=1:ntfig
	tfig(j)=figure(tfig(j));clf;
	c=sprintf('Correlation Tests - MIMO Models - (%g)',j); 
	set(tfig(j),'Name',c);
	for i=1:ngpa
		if (corr(k+4,nn) == 1)
			na=n2;
		else
			na=n1;
		end;
		if ngpa == 1
			subplot(1,1,1);
		else
			subplot(ngpa/2,2,i);
		end;
		plot(na,corr(1:Npc,k),'-',na,n3,'--',na,n4,'--');
		title(reblank(S(k,:)));
		k=k+1;
		if (k == nn)
			break;
		end;
	end;
	if (y=='y') 
  		print -deps corr_graf
	end;
	if (k == nn)
		break;
	end;
end;


end;
----------
X-Sun-Data-Type: default-app
X-Sun-Data-Name: reblank.m
X-Sun-Content-Lines: 24

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


----------
X-Sun-Data-Type: default-app
X-Sun-Data-Name: ccf.m
X-Sun-Content-Lines: 139

function r=ccf(c,lag,flag,tfig,s) 
% function r=ccf(c,lag,flag,s) calculates the correlation function
%	for the signals in the vector c.
% 
% On entry
%	c    - matrix which contains the signals, e.g, residuals.
%	lag  - maximum lag from which the ccf will be calculated
%	flag -  a scalar:
%		flag = 1 -> the ccf are calculated from -lag to lag
%		flag = 0 -> the ccf are calculated from 0 to lag
%	tfig - number of figure wherein the graphics will be ploted.
%	s    - title of the graphics
%
% On return
%	r - ccf
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
    	plot(t,r,t,l,'--',t,-l,'--',0,1,'.',0,-1,'.'); 
 
    else 
    	t=0:lag; 
    	l=ones(lag+1,1)*1.96/sqrt(length(c1)); 
    	plot(t,r12(2,1:lag+1)/sqrt(cc1*cc2),t,l,'--',t,-l,'--',0,1,'.',0,-1,'.');
 
  end; 

  title(s);
  xlabel('lag');
 
end; 
 
----------
X-Sun-Data-Type: default-app
X-Sun-Data-Name: correl.m
X-Sun-Content-Lines: 53

function corr = correl(u1,u2,lag,type)
% function corr = correl(u1,u2,lag,type) calculates the correlation between
%	u1 and u2 up to the specified lag
%
% on entry
%	u1 - signal
%	u2 - signal
%	lag
%	type - (0) without mean, (1) with mean
%
% on return
%	corre 

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
----------
X-Sun-Data-Type: default
X-Sun-Data-Name: desloc.m
X-Sun-Content-Lines: 20

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
end


