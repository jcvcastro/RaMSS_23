function m = mspe(y,y_hat)
  % mspe1 = sum((y - y_hat).^2)/length(y);
  e = y - y_hat;
  m = e'*e;
  if (isnan(m)) 
    m = inf; 
  else
    m = m/length(y);
  end
end
