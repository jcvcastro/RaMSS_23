function y=shift_col(u,n)
y = circshift(u,n);
y(1:n) = 0;
end
