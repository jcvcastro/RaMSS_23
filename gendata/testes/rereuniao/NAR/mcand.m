function y = mcand(Cand,cy,cu)
% function y = mcand(Cand,cy,cu) returns the modified set of candidate 
%       terms (after exclude those terms that belong a pre-selected cluster)
% 
% On entry
%       Cand
%       cy,cu  - indicates the cluster that will be excluded
% 
% On return
%       y      - the new set of candidate terms

% 06/27/95

if nargin ~= 3
	error('mcand requires 3 input arguments.');
end;

if nargout ~= 1
	error('mcand requires at most 1 output argument.');
end;

[toterms,degree]=size(Cand);  

% Calculations

index=1;
for i=1:toterms,
    auxy=0;
    auxu=0;
    auxe=0; 
    for j=1:degree,
        a=Cand(i,j);
        kk=floor(a/1000);
	if kk == 1
           auxy=auxy+1;   
        elseif kk == 2
	   auxu=auxu+1;
        elseif kk == 3
           auxe=auxe+1;   
        end;
    end;
    if auxe
       y(index,:)=Cand(i,:);
       index=index+1;
    end;
    if ((auxe==0) & ((auxy ~= cy) | (auxu ~= cu)))
       y(index,:)=Cand(i,:);
       index=index+1;
    end;
end;

[toterms1,degree1]=size(y);

if toterms1==toterms
   error('The indicated cluster does not exist in the model.');     
end;
