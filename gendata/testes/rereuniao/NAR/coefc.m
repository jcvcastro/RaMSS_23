function [yconst,y,yc]=coefc(model,x0)
% function [yconst,y,yc]=coefc(model,x0) return the coefficients of the
%            model's clusters  
%
% On entry
%       model
%	x0     -  Coefficients
%
% On return
%
%       yconst -  Coefficient of constant term, in the model
%       y      -  Coefficients of clusters in y and u, respectively   
%       yc     -  Coefficients in cross-clusters 
%                 (matrix, where the first index indicate the number of
%                  y's terms and the second one the number of terms in u.)
%
% Observation: It's implicit that all process terms came before the noise
%              model !!!   

% 06/05/95

if nargin ~= 2
	error('pred1 requires 2 input arguments.');
end;

if nargout ~= 3
	error('pred1 requires 3 output arguments.');
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

% Calculations

yconst=0;
yy=zeros(degree,1);
yu=zeros(degree,1);
yyu=zeros(degree,degree);

for i=1:npr,
      auxy=0;
      auxu=0;
      for j=1:degree,
            a=model(i,j);
 	    kk=floor(a/1000);
	    if kk == 1
               auxy=auxy+1;   
            elseif kk == 2
	       auxu=auxu+1;
            end;
      end;
      if ((auxy) & (~auxu)) 
         yy(auxy)=yy(auxy)+x0(i); 
      elseif ((~auxy) & (auxu))
         yu(auxu)=yu(auxu)+x0(i);
      elseif ((auxy) & (auxu))
         yyu(auxy,auxu)=yyu(auxy,auxu)+x0(i);
      else 
         yconst=yconst+x0(i); 
      end;

      y=[yy (1:degree)'; yu (1:degree)'];
      yc=yyu;

end;
