%function fid1=genmod(mod,x,arq)
% function genmod(mod,x,arq) generates the real expression of the 
% identified model in archive
%
% On entry
%       mod   - code for representing a model
%       x     - coeficients of model's terms
%       arq   - name of the output's archive

% Cristiano - Modified by Giovani Guimarães Rodrigues in 01/02/96

% Initializations

%if nargin~=3
%   error('genmod requires 3 input arguments');

[a,nsuby]=size(x);
if nsuby~=1
   error('Only SISO models');
end;

[nt,b]=size(mod);
degree=floor(b/nsuby);
if (b ~= degree*nsuby)
	error('model is incompatible (nsuby)');
end;

if a~=nt
   error('model and coefficients are incompatible (rows)');
end;

[npr,nno,lag,ny,nu,ne,model]=get_info(mod);

if (ny ~= nsuby)
	error('Nsuby and model are not compatible');
end;

nty=zeros(1,npr);
ntu=zeros(1,npr);
ntz=zeros(1,npr);

% Calculations
for k=1:npr,
  for m=1:3,
    if (model(k,m)>=1001)&(model(k,m)<=1099)
	nty(k) = nty(k)+1;
        p(k,m)=model(k,m)-1000;
    elseif ((model(k,m)>=2001)&(model(k,m)<=2099))
	ntu(k)=ntu(k)+1;
        p(k,m)=model(k,m)-2000;
    else
	ntz(k)=ntz(k)+1;
        p(k,m)=0;
    end;
  end;
end;

% Generating the model in an archive
[fid1,message]=fopen(arq,'w');

fprintf(fid1,'y(k)=');
for k=1:npr,
    if ((nty(k)==1)&(ntz(k)==2))
       fprintf(fid1,'%f*y(k-%i)',x(k),p(k,1));
    elseif ((ntu(k)==1)&(ntz(k)==2))
       fprintf(fid1,'%f*u(k-%i)',x(k),p(k,1));
    elseif ((nty(k)==2)&(ntz(k)==1))
       fprintf(fid1,'%f*y(k-%i)*y(k-%i)',x(k),p(k,1),p(k,2));
    elseif ((ntu(k)==2)&(ntz(k)==1))
       fprintf(fid1,'%f*u(k-%i)*u(k-%i)',x(k),p(k,1),p(k,2));
    elseif (nty(k)==3)
       fprintf(fid1,'%f*y(k-%i)*y(k-%i)*y(k-%i)',x(k),p(k,1),p(k,2),p(k,3));
    elseif (ntu(k)==3)
       fprintf(fid1,'%f*u(k-%i)*u(k-%i)*u(k-%i)',x(k),p(k,1),p(k,2),p(k,3));
    elseif ((ntu(k)==1)&(nty(k)==1))
       fprintf(fid1,'%f*u(k-%i)*y(k-%i)',x(k),p(k,1),p(k,2));
    elseif ((ntu(k)==2)&(nty(k)==1))
       fprintf(fid1,'%f*u(k-%i)*u(k-%i)*y(k-%i)',x(k),p(k,1),p(k,2),p(k,3));
    elseif ((ntu(k)==1)&(nty(k)==2))
       fprintf(fid1,'%f*u(k-%i)*y(k-%i)*y(k-%i)',x(k),p(k,1),p(k,2),p(k,3));
    end;
end;

fclose(fid1);
