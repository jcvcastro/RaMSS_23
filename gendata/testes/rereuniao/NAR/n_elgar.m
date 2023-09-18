%load c:\alunos\bira\dados\dup10.dat;
%load c:\alunos\bira\dados\esp10.dat;
%y=dup10(2000:5:6000);
%y=esp10(2000:4:6000);

%load c:\alunos\bira\dados\dup50.dat;
%load c:\alunos\bira\dados\esp40.dat;
%y=dup50(1001:2000);
y=esp40(1001:1800);
DG=3;

%nf=0;
%for i=1:2

ny=5;

% number of (linear) noise terms
nnt=20;
[a b]=size(y);
if b>a,
  y=y';
end;
u=zeros(max([a b]),1);

%[as bs]=size(ys);
%if bs>as,
%  ys=ys';
%end;
%us=zeros(max([as bs]),1);

% Generate set of candidate terms with: degree of nonlinearity=3,
% maximum lag for output terms=3, and 
% maximum lag for input terms=3.
[Cand,tot2]=genterms(DG,ny);
%Cand=mcand(Cand,2,0);
%Cand=mcand(Cand,0,0);
% Add 20 linear noise terms, i.e. from e(k-1) to e(k-20), in
% order to avoid bias during parameter estimation.
%Cand=[Cand(2:tot2,:);(3001:1:3000+nnt)' zeros(nnt,DG-1)];
Cand=[Cand;(3001:1:3000+nnt)' zeros(nnt,DG-1)];
%Cands=[Cands;(3001:1:3000+nnt)' zeros(nnt,DG-1)];

for np=21:21

[a,b]=size(Cand);
%[as,bs]=size(Cands);
% Now we can proceed to the identification
[model,x,e,va]=orthreg(Cand(1:a,1:b),u,y,[np nnt],3);
%[models,xs,es,vas]=orthreg(Cands(1:as,1:bs),us,ys,[np nnt],3);


% Simulate the identified model
ym=simodeld(model,x(:,1),9000,y(1:nnt));
%ye=simodeld(models,xs(:,1),500,ys(1:nnt));
%nf=nf+1;
figure(np);
plot(ym(1:498),ym(3:500));
%nf=nf+1;
%figure(nf);
%plot(ye(1:498),ye(3:500));

% end loop number of terms
end;

% end loop order
%end;


