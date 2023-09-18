% NARMAX identification of the tank system

% dgree of nonlinearity
DG=3;
% number of (linear) noise terms
nnt=20;

[Cand,tot2]=genterms(DG,3,3);
Cand=[Cand;(3001:1:3000+nnt)' zeros(nnt,DG-1)];

for np=7:7

  [model,x,e,va]=orthreg(Cand,ui,yi,[np 20],3);
  
  ym=simodeld(model,x(:,1),u(31:200),y(31:50));
%  ym=simodeld(model,x(:,1),zz(131:2:353,2)/100,zz(131:2:170,3)/100);

  figure(np);plot([u(31:200) y(31:200) ym]);
%  plot([zz(131:2:353,2:3)/100 ym]);

%ym=simodeld(model,x(:,1),u(1:210),y(1:20));
%figure(np);plot([u(1:210) y(1:210) ym]);

end;
