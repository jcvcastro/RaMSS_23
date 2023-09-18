function t = paracor(x,prec)

%
% OBS.  Special function -> A LATEX format is returned

s=' \! \times \! 10^{';

if isstr(x)
	t = x;
else
	if ~isreal(x)
		error('This function is not valid for complex numbers');
	end;

	if (nargin == 1)
		num_format = '%s%.4g%s%s%g}';
	else
		num_format = ['%s%.' num2str(prec) 'g' '%s%s%g}'];
	end

	exponent = floor(log10(abs(x)));

	exponent = exponent + 1;

	if exponent >= 0
		s1='+';
	else
		s1='';
	end;

	if x >= 0
		s2='+';
	else
		s2='';
	end;

	mantissa = x/10^(exponent);


	t = sprintf(num_format, s2, mantissa, s,s1, exponent);
end
