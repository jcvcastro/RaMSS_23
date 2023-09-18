function x = plotcro(corr,ngp,y)
% function plotcro(corr,ngp,y) plots correlation tests   
%
% On entry
%       Corr is a matrix with all correlation tests. (crocor41) 
%       ngp - number of graphics per page
%       y - print option. In order to print the graphics make y = 'y'
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
			na=n2;
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

