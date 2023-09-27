clear

% cd('/home/joao/Documentos/GDRIVE/DOUTORADO/GIT/RaMSS_mat/plot_functions/')
figpath = './figures/set/IV/C1_1to4/';
mkdir(figpath);

% %
% %% C1_1b50_CL
% files = {
%   "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_1b50_CL/C1_1b50_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
%   "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_2b50_CL/C1_2b50_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
%   "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_3b50_CL/C1_3b50_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
%   "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_4b50_CL/C1_4b50_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
%   "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_1b50_CL/C1_1b50_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a050.mat"
%   "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_2b50_CL/C1_2b50_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a050.mat"
%   "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_3b50_CL/C1_3b50_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a050.mat"
%   "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_4b50_CL/C1_4b50_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a050.mat"
%   };
% figname = 'grtrRIPinit_smllrRIPmin_C1_1to4b50_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05.pdf';
% mkdir(figpath);
% figure(1); clf;
% plot_scores_C1_1to4(files, strcat(figpath, figname));
% system(['pdf-crop-margins -o ', figpath, ' -mo ', figpath, figname])
% system(['rm ', figpath, figname(1:end-4), '_uncropped.pdf'])

%% C1_1b10_CL
files = {
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_1b10_CL/C1_1b10_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_2b10_CL/C1_2b10_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_3b10_CL/C1_3b10_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_4b10_CL/C1_4b10_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_1b10_CL/C1_1b10_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a050.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_2b10_CL/C1_2b10_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a050.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_3b10_CL/C1_3b10_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a050.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_4b10_CL/C1_4b10_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a050.mat"
  };
figname = 'grtrRIPinit_smllrRIPmin_C1_1to4b10_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05.pdf';
mkdir(figpath);
figure(1); clf;
plot_scores_C1_1to4(files, strcat(figpath, figname));
system(['pdf-crop-margins -o ', figpath, ' -mo ', figpath, figname])
system(['rm ', figpath, figname(1:end-4), '_uncropped.pdf'])

%% C1_1b5_CL
files = {
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_1b5_CL/C1_1b5_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_2b5_CL/C1_2b5_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_3b5_CL/C1_3b5_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_4b5_CL/C1_4b5_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_1b5_CL/C1_1b5_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a050.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_2b5_CL/C1_2b5_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a050.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_3b5_CL/C1_3b5_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a050.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_4b5_CL/C1_4b5_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a050.mat"
  };
figname = 'grtrRIPinit_smllrRIPmin_C1_1to4b5_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05.pdf';
mkdir(figpath);
figure(1); clf;
plot_scores_C1_1to4(files, strcat(figpath, figname));
system(['pdf-crop-margins -o ', figpath, ' -mo ', figpath, figname])
system(['rm ', figpath, figname(1:end-4), '_uncropped.pdf'])

%% C1_1b2_CL
files = {
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_1b2_CL/C1_1b2_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_2b2_CL/C1_2b2_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_3b2_CL/C1_3b2_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_4b2_CL/C1_4b2_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_1b2_CL/C1_1b2_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a050.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_2b2_CL/C1_2b2_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a050.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_3b2_CL/C1_3b2_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a050.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_4b2_CL/C1_4b2_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a050.mat"
  };
figname = 'grtrRIPinit_smllrRIPmin_C1_1to4b2_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05.pdf';
mkdir(figpath);
figure(1); clf;
plot_scores_C1_1to4(files, strcat(figpath, figname));
system(['pdf-crop-margins -o ', figpath, ' -mo ', figpath, figname])
system(['rm ', figpath, figname(1:end-4), '_uncropped.pdf'])

%% C1_1b1_CL
files = {
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_1b1_CL/C1_1b1_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_2b1_CL/C1_2b1_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_3b1_CL/C1_3b1_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_4b1_CL/C1_4b1_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_1b1_CL/C1_1b1_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a050.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_2b1_CL/C1_2b1_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a050.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_3b1_CL/C1_3b1_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a050.mat"
  "../DATA23/RaMSS/230920/ripMin_0.05_ripInt_0.2/50iter/C1_4b1_CL/C1_4b1_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a050.mat"
  };
figname = 'grtrRIPinit_smllrRIPmin_C1_1to4b1_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05.pdf';
mkdir(figpath);
figure(1); clf;
plot_scores_C1_1to4(files, strcat(figpath, figname));
system(['pdf-crop-margins -o ', figpath, ' -mo ', figpath, figname])
system(['rm ', figpath, figname(1:end-4), '_uncropped.pdf'])

