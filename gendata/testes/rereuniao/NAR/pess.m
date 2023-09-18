function [ps,ess,I]=pess(model,x,u,y,nic,kmin,kmax,inc,mode);
% [ps ess I]=pess(model,x,u,y,nic,kmin,kmax,inc,mode);
%
% determines que prediction error sum of squares
% for a given model as a function of the prediction
% step
% model- model structure (enter only np terms)
% x    - model parameters (enter only np parameters)
% u    - input data or number of simulation steps
% y    - output data
% nic  - number of initial conditions 
% kmin - minimum number of prediction steps
% kmax - maximum number of prediction steps
% inc  - step to move from kmin to kmax
% mode - mode of k-step-ahead simulation 
%
% ps   - prediction step
% ess  - error sum of squares per observation (the total sum of
%        squared errors is divided by the number of observations)
% I    - If the model goes unstable at prediction time k
%        I will indicate k, otherwise will indicate 0

% LA Aguirre, BH 8/10/96

i=1;
for k=kmin:inc:kmax
  ym=simodelk(model,x,u,y,nic,k,mode);
  lm=length(ym);
  e=y(1:lm)-ym(1:lm);
  aux=find(e>2); 
  Aux=find((e-e)~=0);
  if isempty(aux),
    if isempty(Aux),
      I(i)=0;
      ess(i)=sum(e.^2)/lm;
    else
      I(i)=Aux(1);
      ess(i)=sum(e(1:I(i)-1).^2)/(I(i)-1);
    end;
  else
    if isempty(Aux),
      I(i)=aux(1);
      ess(i)=sum(e(1:I(i)-1).^2)/(I(i)-1);
    else
      I(i)=min([Aux(1) aux(1)]);
      ess(i)=sum(e(1:I(i)-1).^2)/(I(i)-1); 
    end;
  end
  ps(i)=k;
  i=i+1;
end;
