clear
cd '/home/joao/RaMSS_23/';
pastas = dir('./DATA23/RaMSS/230922_ufop/');
p.name = extractfield(pastas, 'name');

for j=3:length(pastas)
  filepath = [pastas(j).folder, '/' pastas(j).name];
  % filename = 'C2_5b5_CL_IV-M100I050K1u6e6l3ni3nx1p975_R04N05_a000.mat';
  files = dir(filepath);
  temp = extractfield(files,'name');
  validfiles.name = temp(contains(temp,'.mat')&~contains(temp,'tssdmdls'));
  clear temp;
  validfiles.folder = files.folder;

  renomeia_simdata_models(validfiles);
end

f = 2;
%
% filepath = [pastas(3).folder, '/' pastas(3).name];
% files = dir(filepath);
% temp = extractfield(files,'name');
% validfiles.name = temp(contains(temp,'.mat')&~contains(temp,'tssdmdls'));
% clear temp;
% validfiles.folder = files.folder;

load([validfiles.folder '/' validfiles.name{f}]);
simdata.model.name

function renomeia_simdata_models(files)
  for i=1:length(files.name)
    renomeia_simdata_model(files.folder, files.name{i});
  end
end

function renomeia_simdata_model(filepath, filename)
  % m = matfile([filepath '/' filename], 'simdata')
  % m.simdata.model.name = filename(1:9);
  load([filepath '/' filename]);
  simdata.model.name = filename(1:9);
  save([filepath '/' filename],'ramssdata','simdata');
end
