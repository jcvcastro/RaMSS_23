function y=zoh(x,T);
% y=zoh(x,T);
% segurador de ordem 0
% cada valor em x sera segurado T (inteiro) intervalos
% para compor o vetor y. Portanto dim(y)=din(x)*T.

% Luis Antonio Aguirre
% Ouro Branco 27/12/2004

y=[];
for k=1:length(x)
 y=[y;ones(T,1)*x(k)];
end;
