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
  %
  % Modified by João Castro to optimize simulation time:
  % Basicale, 2 changes to original:
  % 1 - nsuby is set to 1 (along the code);
  % 2 - 'bpivp' and 'bpivn' is set as a fixed size boolean vector, that, at the and of
  %   loop, are transformed to 'pivn' and 'pivp' with 'find' function.

	if ( nargin ~= 1) 
		error('get_info requires 1 input arguments.');
	end

	[nt,c]=size(model);

  degree = c;

	npr=0;nno=0;lag=0;
	ny=0;nu=0;ne=0;

	i=find(model > 0);

  model(i)=model(i)+100;

  kkk=1:degree;
  bpivp=zeros(nt,1);
  bpivn=zeros(nt,1);

  for i=1:nt
    kk=floor(model(i,kkk)/1000); % Signal
    kk1=floor((model(i,kkk)-kk*1000)/100); % Subsystem
    kk2=model(i,kkk)-kk*1000-kk1*100;       % lags
    j=find(kk == 1);
    if ~isempty(j)
      %                       ny=ny+1;
      ny=max([ny kk1(j)]);
    end
    j=find(kk == 2);
    if ~isempty(j)
      %                       nu=nu+1;
      nu=max([nu kk1(j)]);
    end
    j=find(kk == 3);
    if ~isempty(j)
      %                       ne=ne+1;
      ne=max([ne kk1(j)]);
      nno(1)=nno(1)+1;
      bpivn(i)=true;
    else
      npr(1)=npr(1)+1;
      bpivp(i)=true; 
    end
    lag=max([lag kk2]);
  end
  pivn = find(bpivn);
  pivp = find(bpivp);
  model(1:length(pivp)+length(pivn),kkk)=[model(pivp,kkk)
  model(pivn,kkk)];

  i=find(model > 0);

  model(i)=model(i)-100;

  newmodel=model;

end



