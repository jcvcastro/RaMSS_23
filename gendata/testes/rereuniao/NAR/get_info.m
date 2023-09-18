function [npr,nno,lag,ny,nu,ne,newmodel] = get_info(model)
% function [npr,nno,lag,ny,nu,ne,newmodel] = get_info(model) gets useful 
%       information from the model
%
% On entry      
%       model   - code used for representing a given model
%
% On return
%       npr     - number of process terms
%       nno     - number of noise terms
%       lag     - maximum lag
%       ny      - number of output terms
%       nu      - number of input terms
%       ne      - number of noise terms
%       newmodel - new model where the process terms come first.
%

% Eduardo Mendes - 11/08/94
% ACSE - Sheffield

if ( nargin ~= 1) 
	error('get_info requires 1 input arguments.');
end;

[nt,c]=size(model);

nsuby = 1;      % Needs further modication

[a,b]=size(nsuby);

if ((a*b) ~= 1) 
	error('nsuby is a scalar.');
end;

degree=floor(c/nsuby);

if (c ~= degree*nsuby)
	error('model is incompatible');
end;

npr=zeros(1,nsuby);nno=zeros(1,nsuby);lag=0;
ny=0;nu=0;ne=0;

i=find(model > 0);

model(i)=model(i)+100;

for k=1:nsuby
	kkk=(k-1)*degree+1:k*degree;
	pivp=[];
	pivn=[];
	for i=1:nt
		kk=floor(model(i,kkk)/1000); % Signal
		kk1=floor((model(i,kkk)-kk*1000)/100); % Subsystem
		kk2=model(i,kkk)-kk*1000-kk1*100;       % lags
		j=find(kk == 1);
		if ~isempty(j)
%                       ny=ny+1;
			ny=max([ny kk1(j)]);
		end;
		j=find(kk == 2);
		if ~isempty(j)
%                       nu=nu+1;
			nu=max([nu kk1(j)]);
		end;
		j=find(kk == 3);
		if ~isempty(j)
%                       ne=ne+1;
			ne=max([ne kk1(j)]);
			nno(k)=nno(k)+1;
			pivn=[pivn i];
		else
			npr(k)=npr(k)+1;
			pivp=[pivp i];
		end;
		lag=max([lag kk2]);
	end;
	model(1:length(pivp)+length(pivn),kkk)=[model(pivp,kkk)
		  model(pivn,kkk)];

end;

i=find(model > 0);

model(i)=model(i)-100;

newmodel=model;
