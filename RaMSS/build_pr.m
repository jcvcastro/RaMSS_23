function P = build_pr(model,u,y)
% function P = build_process(model,u,y) builds the regressor matrix
%	for the process terms
% 
% On entry
%	model 	- code for the model representation
%	u	- input signal
%	y	- output signal
%
% On return
%	P	- regressor matrix

% Eduardo Mendes - 11/08/94
% ACSE - Sheffield

if ((nargin < 2) || (nargin > 3))
	error('build_process requires 2 or 3 input arguments.');
elseif nargin == 2
	y=[];
end

[npr,nno,~,ny,nu]=get_info(model);

if isempty(u)
	if nu ~= 0
		error('u cannot be an empty matrix.');
	end
	u=0*y;
end

[n,a]=size(u);	

if (a ~= 1)
	error('u is a column vector.');
end

if isempty(y)
	if (ny ~= 0)
		error('y cannot be an empty matrix');
	end
	y=zeros(n,1);
else
	[b,c]=size(y);
	if c ~= 1
		error('y is a column vector.');
	end
	if b ~= n
		error('Number of rows of y and u must be the same.');
	end
end

% Calculations

P=ones(n,npr);

for i=1:npr
	kk=floor(model(i,:)/1000); % Signal
	kk1=model(i,:)-kk*1000;	% lags
	j=find(kk == 1);
	if ~isempty(j)
		for k=1:length(j)
			P(:,i)=P(:,i).*(shift_col(y,kk1(j(k))));
		end
	end
	j=find(kk == 2);
	if ~isempty(j)
		for k=1:length(j)
			P(:,i)=P(:,i).*(shift_col(u,kk1(j(k))));
		end
	end
end

end

