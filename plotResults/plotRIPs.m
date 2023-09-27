function plotRIPs(df, n, m)
  n=1; m=1; df="/home/joao/Documentos/GDRIVE/DOUTORADO/GIT/RaMSS_23/DATA23/RaMSS/2309/C1_1b1_CL/C1_1b1_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
  dt=load(df);
  rips=dt.ramssdata.rip{n,m};
  plot(rips')

end

