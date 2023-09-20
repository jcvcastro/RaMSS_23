function [model,TotTerms] = genterms2(DG,lagy,lagu,lage)
% function [model,TotTerms] = GenTerms(DG,lagy,lagu,lage) returns the 
%	code for siso models
%
% On entry
%	DG 	- degree of nonlinearity
%	lagy	- maximum lag of the output signal
%	lagu	- maximum lag of the input signal
%	lage	- maximum lag of the noise signal
%
% On return
%	model    - code used to represent the model
%	TotTerms - number of tresm into the model
%

% Eduardo Mendes - 11/08/94 - Carlos Fonseca
% ACSE - Sheffield
%
% NOTE: This function was modified to generate the '0' terms.
%
% Modified by João Castro - jun - 2022

if ((nargin < 2) | (nargin > 4))
	error('GenTerms requires 2, 3 or 4 input arguments.');
elseif nargin == 2
	lagu=[];
	lage=[];
elseif nargin == 3
	lage=[];
end;

% Tests

[a,b]=size(DG);

if ((a*b) ~= 1)
	error('DG is a saclar');
end;

if (DG < 1)
	error('DG is greater than zero.');
end;

[a,b]=size(lagy);

if ((a*b) ~= 1)
	error('lagy is a scalar.');
end;

if (lagy < 0)
	error('lagy is positive.');
end;

if ~isempty(lagu)
	[a,b]=size(lagu);
	if ((a*b) ~= 1)
		error('lagu is a scalar.');
	end;
	if (lagu < 0)
		error('lagu is positive.');
	end;
end;

if ~isempty(lage)
	[a,b]=size(lage);
	if ((a*b) ~= 1)
		error('lage is a scalar.');
	end;
	if (lage < 0)
		error('lage is positive.');
	end
end;



% Preparing for the actual calculations

LAGS=[lagy lagu+1 lage];

% Number of signals
NS = max(size(LAGS));

ix = cumsum([2 LAGS]);
NFactors = ix(NS+1)-2;
TotTerms = prod(NFactors+1:NFactors+DG) / prod(1:DG);
model = zeros(TotTerms,DG);

% Do linear terms first
for i = 1:NS,
		model(ix(i):ix(i+1)-1,1) = i*1000 + [1:LAGS(i)]';
end
% for i = 1:NS,
    % model(ix(i):ix(i+1)-1,1) = i*1000 + [0:LAGS(i)]';
% end

a = NFactors*eye(1,DG);

for i = ix(NS+1):TotTerms,
    % Find term to be incremented next
    [ans,j]=max(a<NFactors);
    a(1:j) = (a(j)+1) * ones(1,j);
    model(i,:) = model(a+1,1)';
end

for i = 1:TotTerms*DG
  if(round(model(i),-3)==2000)
    model(i) = model(i)-1;
  end
end

[npr,nno,lag,ny,ny,ne,newmodel]=get_info(model);

model=newmodel;

end
