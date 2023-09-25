function mape = mape(yv,ym)
  mape=(sum(abs(yv-ym))/(std(yv)*length(yv)))*100;
end
