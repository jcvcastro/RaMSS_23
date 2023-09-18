function plot_scores_C1_1to4(files, pathfig)

if nargin < 1
end
switch nargin
   case 0
      error("the function needs a data file!")
   case 1
      pathfig = [];
   case 2
   otherwise
      error("Function must have 1 or 2 arguments!")
end

% % [nf, ~] = size(files)
nf = length(files);
for i = 1:nf
  load(files{i})

  % Taking datafile (only) from complete path (to save figs with same name):
  A = strread(files{i}, '%s', 'delimiter',strrep(filesep,char(filesep),filesep));
  filename = A{end}(1:end-4); % Removing file extension

  score = compute_score(files{i});
  % six = a*s{2}-(s{2}-1);
  % six = i*nsc-(nsc-1);
   subplot(ceil(nf/4), 4, i);
      plotscore(score);
      ylabel(['index (a = ' num2str(score.info.a) ')']);
      % title(filename,'Interpreter','none');
      % xlim([0.01 100]);
   % keepvars = {'files', 'pathfig', 'nf', 'i'};
   % clearvars('-except', keepvars{:});
end


if(~isempty(pathfig))
   f=gcf;
   f.PaperSize = [10 6];
   print(pathfig, '-dpdf', '-fillpage');
   % saveas(f,pathfig);
   % disp(pathfig)
end


