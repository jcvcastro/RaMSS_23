function y = simmodeld(model,x0,u,y0,e)
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
% teste

% Eduardo Mendes - 3/09/94
% ACSE - Sheffield
% modified line 53

if ((nargin < 3) || (nargin > 5))
	error('simodeld requires 3, 4 or 5 input arguments.');
elseif nargin == 3
	y0=[];
	e=[];
elseif nargin == 4
	e=[];
end

if nargout > 1
	error('simodeld requires 1 output argument at most.');
end

[a,nsuby]=size(x0);

if nsuby ~= 1
	error('Only SISO models');
end

[nt,b]=size(model);
degree=floor(b/nsuby);

if (b ~= degree*nsuby)
	error('model is incompatible (nsuby).');
end


if (a ~= nt)
	error('model and coefficients are incompatible (rows).');
end

[npr,nno,lag,ny,nu,ne]=get_info(model);

% ny - number of output terms. 
% if (ny ~= nsuby)
	% error('Nsuby and model are not compatible.');
% end

% Although MIMO are not allowed, this function can deal with them

i=find(model > 0);
model(i)=model(i)+100;

% Input Vector

[n,nuu]=size(u);

if ((n*nuu) == 1)
	if nu ~= 0
		error('No input vector.');
	end
	if u <= lag
		error(sprintf('Number of data points should be greater than %g',lag));
	end
	n=u;
else
	if nu ~= nuu
		error('Number of inputs is incompatible.');
	end
	if n <= lag
		error(sprintf('Number of data points should be greater than %g',lag));
	end
end

% Initial Conditions

if isempty(y0)
	y0=zeros(lag,nsuby);
end

[a,b]=size(y0);

if a ~= lag
	error(sprintf('y0 is a (%g X %g) matrix.',lag,nsuby));
end

if b ~= nsuby
	error(sprintf('y0 is a (%g X %g) matrix.',lag,nsuby));
end

% Noise

if isempty(e)
	e=zeros(n,nsuby);
else
	[a,b]=size(e);
	if (a ~= n)
		error('input and noise are incompatible.');
	end
	if (b < ne)
		error(sprintf('Number of columns of e should be %g',ne));
	end
end

% Calculations

y=zeros(n,nsuby);

y(1:lag,:)=y0;


for nn=lag+1:n
for k=1:nsuby
	for i=1:npr(k)
		sinter1=x0(i,k);
		for j=1:degree
			a=model(i,(k-1)*degree+j);
			if ((a == 0) || (a == (-1))), break; end
      %NOTE: comentar essa condicao acima para lidar com modelos sem atraso?
			kk=floor(a/1000);
			kk1=floor((a-1000*kk)/100);
			kk2=a-1000*kk-100*kk1;
			if kk == 1
				sinter1=sinter1*y(nn-kk2,kk1);
			elseif kk == 2
				sinter1=sinter1*u(nn-kk2,kk1);
			else
				sinter1=sinter1*e(nn-kk2,kk1);
			end
		end
		if (a == (-1)), break; end
    %NOTE: comentar essa condicao acima para lidar com modelos sem atraso?
		y(nn,k)=y(nn,k)+sinter1;
	end
end
end

end
