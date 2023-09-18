% histograma/boi

load boigor2.dat;
ny=90;nnt=5;DG=1;np=10;
[Cand,tot2]=genterms(DG,ny);
Cand=[Cand;(3001:1:3000+nnt)' zeros(nnt,DG-1)];

M=[];
np=10;

for i=1:41
  y=boigor2(i*5-3:i*5+297);
  [model,x,e,va]=orthreg(Cand,y,y,[np 5],1);
  X=diag(x(1:np,3:np+2));
  ind=find(abs(x(1:np,1))<X(1:np));

  % statistically insignificant terms will have code 999
  model(ind)=999*ones(length(ind),1);
  M=[M;model(1:10)-1000];
end;

% produce clean M
% remove terms of lags 0, -1, -2 and statistically insignificant
ind=find(M>0);
MM=M(ind);

hist(MM,90);

