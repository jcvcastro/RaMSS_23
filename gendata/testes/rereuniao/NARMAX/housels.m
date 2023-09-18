function [xls,piv,var,B,y,a,b,c,A] = housels(A,y,Nterms,sqy,ERR,piv,a,b,c)
% function [xls,piv,var,B,y,a,b,c,A] = housels(A,y,Nterms,sqy,ERR,piv,a,b,c) 
%- Householder QR with Column
%   Pivoting -   Matrix Computations - page 235

% Eduardo Mendes - 11/1/93
% ACSE - Sheffield

if ((nargin ~= 4) & (nargin ~= 9))
	error('housels requires 4 or 9 input arguments.');
elseif nargin == 4
	ERR=[];piv=[];a=[];b=[];c=[];
	[a,b]=size(Nterms);
	if ((a*b) ~= 1)
		error('In this case Nterms is a scalar');
	end;
	Nterms=[0 Nterms];
end;

if nargout > 9
	error('housels requires 9 output arguments at most.');
end;

% Tests

[m,n]=size(A);

[a1,b1]=size(y);

if (b1 ~= 1)
	error('y is a column vector.');
end;

if (a1 ~= m)
	error('y and A must be of the same length.');
end;

[a1,b1]=size(Nterms);

if ((a1*b1) ~= 2)
	error('Nterms is a 2-length vector.');
end;

%   Calculations

if sum(Nterms) > n
   Nterms(2) = n-NTerms(1);
end;

r=Nterms(1);

%  Changing the size of some variables if necessary

if isempty(piv)
	piv=(1:1:n);
else
	piv=[piv (Nterms(1)+1:n)];
end;

if isempty(ERR)
	ERR=zeros(n,1);
else
	ERR=[ERR;(Nterms(1)+1:n)'];
end;

if isempty(a)
	a=zeros(n,1);
else
	a=[a(1:r,1);zeros(n-r,1)];
end;

if isempty(b)
	b=zeros(n,1);
else
	b=[b(1:r,1);zeros(n-r,1)];
end;

if isempty(c)
	c=zeros(n,1);
else
	c=[c(1:r,1);zeros(n-r,1)];
end;


% First Iteration

for j=r+1:n
	a(j)=A(r+1:m,j)'*A(r+1:m,j);
	b(j)=A(r+1:m,j)'*y(r+1:m);
	c(j)=(b(j)^2)/(a(j)*sqy);
end;

[ans,k]=max(c(r+1:n));
k=r+k;

%  Vector

v=zeros(m,1);

% Calculations

Nt=Nterms(1);

while Nt < sum(Nterms)
	r=r+1;
	temp=A(1:m,r);
	A(1:m,r)=A(1:m,k);
	A(1:m,k)=temp;
	temp=piv(r);
	piv(r)=piv(k);
	piv(k)=temp;
	temp=a(r);
	a(r)=a(k);
	a(k)=temp;
	temp=b(r);
	b(r)=b(k);
	b(k)=temp;
	temp=c(r);
	c(r)=c(k);
	c(k)=temp;
	v(r:m)=house(A(r:m,r));
	A(r:m,r:n)=rowhouse(A(r:m,r:n),v(r:m));
	A(r+1:m,r)=v(r+1:m);
	y(r:m)=rowhouse(y(r:m),v(r:m));
	for i=r+1:n
		a(i)=a(i)-A(r,i)^2;
		b(i)=b(i)-A(r,i)*y(r);
		c(i)=(b(i)^2)/(a(i)*sqy);
	end;
	if r < n
		[ans,k]=max(c(r+1:n));
		k=r+k;
	end;
	ERR(r)=c(r);
	Nt=Nt+1;
end;

% Variance

var = y(Nt+1:m)'*y(Nt+1:m)/(m-Nt); 

% Matrix R

R=zeros(Nt,Nt);

for i=1:Nt
	R(i,i:Nt)=A(i,i:Nt);
end;    

% Coefficients

xls1 = R(1:Nt,1:Nt)\y(1:Nt);


% Pivot

piv=piv(1:Nt);


% Standard Deviation

r=inv(R'*R);

stdev=sqrt(var*diag(r(1:Nt,1:Nt)));


% Final results

xls=[xls1(1:Nt,1) ERR(1:Nt,1) stdev(1:Nt,1)];

if nargin == 4
	B=A(:,1:Nt);
else
	B=[];
end;



end;
