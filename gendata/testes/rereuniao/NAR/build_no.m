function P = build_no(model,u,y,e)
% function P = build_noise(model,u,y,e) builds the regressor matrix
%	for the noise terms
% 
% On entry
%	model 	- code for the model representation
%	u	- input signal
%	y	- output signal
%	e	- noise signal
%
% On return
%	P	- regressor matrix

% Eduardo Mendes - 11/08/94
% ACSE - Sheffield

if nargin ~= 4
	error('build_noise requires 4 input arguments.');
end;

[npr,nno,lag,ny,nu,ne]=get_info(model);

if (ne == 0)
	P=[];
	return;
end;

nte=npr+nno;	% Number of terms

[ans,degree]=size(model);


if isempty(e)
	error('noise signal is not an empty column-vector.');
end;

[n,a]=size(e);

if a ~= 1
	error('e is a column vector.');
end;

if isempty(u)
	if nu ~= 0
		error('u cannot be an empty matrix.');
	end;
	u=0*e;
else
	[b,c]=size(u);
	if c ~= 1
		error('u is a column vector.');
	end;
	if b ~= n
		error('Number of rows of e and u must be the same.');
	end;
end;

[ans,a]=size(u);	

if (a ~= 1)
	error('u is a column vector.');
end;

if isempty(y)
	if (ny ~= 0)
		error('y cannot be an empty matrix');
	end;
	y=0*e;
else
	[b,c]=size(y);
	if c ~= 1
		error('y is a column vector.');
	end;
	if b ~= n
		error('Number of rows of e and y must be the same.');
	end;
end;

% Calculations

P=ones(n,nno);

for i=npr+1:nte
	kk=floor(model(i,:)/1000); % Signal
	kk1=model(i,:)-kk*1000;	% lags
	j=find(kk == 1);
	if ~isempty(j)
		for k=1:length(j)
			P(:,i-npr)=P(:,i-npr).*(shift_co(y,kk1(j(k))));
		end;
	end;
	j=find(kk == 2);
	if ~isempty(j)
		for k=1:length(j)
			P(:,i-npr)=P(:,i-npr).*(shift_co(u,kk1(j(k))));
		end;
	end;
	j=find(kk == 3);
	if ~isempty(j)
		for k=1:length(j)
			P(:,i-npr)=P(:,i-npr).*(shift_co(e,kk1(j(k))));
		end;
	end;
end;
