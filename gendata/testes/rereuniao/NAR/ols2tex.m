function [t,s] = ols2tex(model,x,prec)
% function [t,s] = ols2tex(model,x,prec) returns a latex command which
%	can be directly used inside a latex file.
%
% On entry
%	model 
%	x	- coefficients
%	prec	- precision
%
% On return
%	t	- latex command
%	s	- model ->  No coefficients are listed

% Eduardo Mendes - 16/05/94
% ACSE - Sheffield

flag = 0;

if ((nargin < 2) | (nargin > 3))
	error('ols2tex requires 2 or 3 input arguments.');
elseif nargin ==2
	prec=5;
end;

[nt,n2n3]=size(model);

[a,nsuby]=size(x);

if (nsuby ~= 1)
	error('SISO models');
end;

n2=floor(n2n3/nsuby);

if (n2n3 ~= n2*nsuby)
	error('model is not SISO model.');
end;

if (a ~= nt)
	error('model and x must have the same number of columns.');
end;

%  This function supports MIMO but ....

i=find(model > 0);

model(i)=model(i)+100;  % To put the model in MIMO notation

% Calculations

[npr,nno]=get_info(model);

nte=npr+nno;

t='';

c='         &   & ';

s='';


t=str2mat(t,'\begin{small}');

t=str2mat(t,'\begin{equation}');

t=str2mat(t,'\label{eq:eqsys}');

t=str2mat(t,'\begin{array}{l}');

f=' \, ';

for j=1:nsuby
	t=str2mat(t,'\begin{array}{ccl}');
	if nsuby == 1
		a='y(k)     & = & ';
	else
		a=sprintf('y_{%g}(k) & = & ',j);
		d=sprintf('Subsystem (%g)',j);
		s=str2mat(s,d);
		s=str2mat(s,' ');
	end;
	for i=1:nte(j)
		b=model(i,(j-1)*n2+1:n2*j);
		kk=floor(b/1000);
		kk1=floor((b-kk*1000)/100);
		kk2=floor((b-kk*1000-kk1*100));
		b=f;
		e=f;
		for k=1:n2
			if kk(k) == 1
				if nsuby == 1
				b=[b sprintf('y(k-%g)',kk2(k))];
				e=[e sprintf('y(k-%g)',kk2(k))];
				else
				b=[b sprintf('y_{%g}(k-%g)',kk1(k),kk2(k))];
				e=[e sprintf('y_{%g}(k-%g)',kk1(k),kk2(k))];
				end;
			elseif kk(k) == 2
				if nsuby == 1
				b=[b sprintf('u(k-%g)',kk2(k))];
				e=[e sprintf('u(k-%g)',kk2(k))];
				else
				b=[b sprintf('u_{%g}(k-%g)',kk1(k),kk2(k))];
				e=[e sprintf('u_{%g}(k-%g)',kk1(k),kk2(k))];
				end;
			elseif kk(k) == 3
				if nsuby == 1
				b=[b sprintf('e(k-%g)',kk2(k))];
				e=[e sprintf('e(k-%g)',kk2(k))];
				else
				b=[b sprintf('e_{%g}(k-%g)',kk1(k),kk2(k))];
				e=[e sprintf('e_{%g}(k-%g)',kk1(k),kk2(k))];
				end;
			elseif kk(k) == 0	
				b=[b ''];
				e=[e ''];
				break;
			end;
		end;
		if i ~= nte(j)
			if i == 1
				if flag 
					b=[a b ' \\'];
				else
					b=[a paracor(x(i,j),prec) b ' \\'];
				end;
			else
				if flag
					b=[c b ' \\'];
				else
					b=[c paracor(x(i,j),prec) b ' \\'];
				end;
			end;
		else
			if i == 1
				if flag
					b=[a b];
				else
					b=[a paracor(x(i,j),prec) b];
				end;
			else
				if flag 
					b=[c b];
				else
					b=[c paracor(x(i,j),prec) b];
				end;
			end;
		end;
		t=str2mat(t,b);
		s=str2mat(s,e(4:length(e)));
	end;
	t=str2mat(t,'\end{array}');
	t=str2mat(t,'\\');
	if j ~= nsuby
		t=str2mat(t,'\\');
	end;
end;

t=str2mat(t,'\end{array}');
t=str2mat(t,'\end{equation}');
t=str2mat(t,'\end{small}');

[a,b]=size(s);

s=s(2:a,:);

end;

