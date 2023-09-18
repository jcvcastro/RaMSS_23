function [m,x,e,va] = orthreg(model,u,y,values,N)
% function [m,x,e,va] = orthreg(model,u,y,values,N) returns  model and its
%	coefficients
%
% On entry
%	model 	- code for representing a model
%	u	- input signal
%	y	- output signal
%	values  - [(Number of Process Terms) (Number of Noise terms)]
%	N	- number of noise iterations
%
% On return
%	m	- identified model
%	x	- [(coeff.) (err) (std)]
%	e	- residuals
%	va	- variance
%

% Eduardo Mendes - 11/08/94
% ACSE - Sheffield

if ((nargin < 4) | (nargin > 5))
	error('orthreg requires 4 or 5 input arguments.');
elseif nargin == 4
	N=0;
end;

[a,b]=size(values);

if ((a*b) > 2)
	error('values is a 2-length vector.');
elseif ((a*b) == 1)
	values=[values 0];
	N=0;
end;

[n,ans]=size(y);

% Process Terms

[npr,nno,lag,ny,nu,ne,model]=get_info(model);

if values(1) > npr
	values(1)=npr;
end;

if values(2) > nno
	values(2)=nno;
end;

if values(2) == 0
	N=0;
end;

Pp=build_process(model,u,y);

sqy=y(lag+1:n)'*y(lag+1:n);

[xls,piv,var,B,Y,aa,bb,cc]=housels(Pp(lag+1:n,:),y(lag+1:n),values(1),sqy);

% Noise Terms

pivp=piv;

Pp=Pp(:,piv);

e=y-Pp*xls(:,1);

if values(2) ~= 0
	for i=1:N
		e=[zeros(lag,1);e(lag+1:n)];
		disp(sprintf('(%g)-th iteration for the noise model',i));
		Pn=build_noise(model,u,y,e);
		Pn1=apply_qr(Pn(lag+1:n,:),B);
		[xls,piv,var]=housels([B Pn1],Y,values,sqy,xls(:,2),piv,aa,bb,cc);
		pivn=piv(values(1)+1:values(1)+values(2))-values(1);
		e=y-[Pp Pn(:,pivn)]*xls(:,1);
	end;
end;

if N ~= 0
	piv=[pivp pivn+npr];
end;

m=model(piv,:);

va=var;

x=xls;

e=[zeros(lag,1);e(lag+1:n)];

end;


		
