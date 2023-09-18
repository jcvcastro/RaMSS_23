function y = simodeld(model,x0,u,y0,e)
% funciton y = simodeld(model,x0,u,y0,e) returns model predicted
%       output for the system (model,x0)
%
% On entry
%       model
%       x0      - coefficients
%       u       - input signal
%       y0      - initial conditions
%       e       - noise (same length as input's)
%
% On return
%       y       - output signal

% Eduardo Mendes - 3/09/94
% ACSE - Sheffield

if ((nargin < 3) | (nargin > 5))
	error('simodeld requires 3, 4 or 5 input arguments.');
elseif nargin == 3
	y0=[];
	e=[];
elseif nargin == 4
	e=[];
end;

if nargout > 1
	error('simodeld requires 1 output argument at most.');
end;

[a,nsuby]=size(x0);

if nsuby ~= 1
	error('Only SISO models');
end;

[nt,b]=size(model);
degree=floor(b/nsuby);

if (b ~= degree*nsuby)
	error('model is incompatible (nsuby).');
end;


if (a ~= nt)
	error('model and coefficients are incompatible (rows).');
end;

[npr,nno,lag,ny,nu,ne]=get_info(model);

if (ny ~= nsuby)
	error('Nsuby and model are not compatible.');
end;

% Although MIMO are not allowed, this function can deal with them


% Input Vector

[n,nuu]=size(u);

if ((n*nuu) == 1)
	if nu ~= 0
		error('No input vector.');
	end;
	if u <= lag
		error(sprintf('Number of data points should be greater than %g',lag));
	end;
	n=u;
%else
%	if nu ~= nuu
%		error('Number of inputs is incompatible.');
%	end;
%	if n <= lag
%		error(sprintf('Number of data points should be greater than %g',lag));
%	end;
end;

% Initial Conditions

if isempty(y0)
	y0=zeros(lag,nsuby);
end;

[a,b]=size(y0);

if a ~= lag
	error(sprintf('y0 is a (%g X %g) matrix.',lag,nsuby));
end;

if b ~= nsuby
	error(sprintf('y0 is a (%g X %g) matrix.',lag,nsuby));
end;

% Noise

if isempty(e)
	e=zeros(n,nsuby);
else
	[a,b]=size(e)
	if (a ~= n)
		error('input and noise are incompatible.');
	end;
	if (b < ne)
		error(sprintf('Number of columns of e should be %g',ne));
	end;
end;

% Calculations

arq=fopen('s_temp.m','wt');
fprintf(arq,'function y= s_temp(y0,x0,n)\n\n');
fprintf(arq,'y=zeros(n,1);\n');
fprintf(arq,'y(1:length(y0))=y0;\n');
fprintf(arq,'for i=(length(y0)+1):n\n');
fprintf(arq,'  y(i)= 0 ');

for i=1:npr
  fprintf(arq,'+x0(%d)',i);
  for d=1:degree
    if (model(i,d))
      fprintf(arq,'*y(i-%d)',model(i,d)-1000);
    end,
  end,
end;
fprintf(arq,';\n');
fprintf(arq,'end;\n');
fclose(arq);
y=eval('s_temp(y0,x0,n)');
