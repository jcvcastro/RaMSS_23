function score = compute_score(datafile, tregs)
% Compute noise levels score NLxMC

if (nargin < 1)
   error('You need to specify de data file!');
end

% datafile = '/home/joao/DADOS/GDRIVE/DOUTORADO/GIT/RaMSS_mat/DATA/C1a_if/C1a_if-M100I100K1a0.5u6e6l3ni-4nx0tt1.96_R20N10.mat';
load(datafile);

if ( nargin < 2 )
   tregs = simdata.model.true_regs;
elseif ( nargin > 2)
   error('Number of arguments exceeded the maximum = 5!');
end


% Taking datafile (only) from complete path (to save figs with same name):
% A = strread(datafile, '%s', 'delimiter',strrep(filesep,char(filesep),filesep));
% datafilename = A{end}(1:end-4);


[ntregs, dg] = size(tregs);
tregs = [tregs zeros(ntregs, ramssdata.parameters.dg-dg)];
tregs = sort(tregs, 2, 'descend');
a = ramssdata.parameters.alpha;

% tregs_conc = concat_model(tregs);


[Nnl, Nmc] = size(ramssdata.rip);

score.values = zeros(Nnl,Nmc);
nota = zeros(Nnl,Nmc);
score.mean = zeros(Nnl,1);
score.std = zeros(Nnl,1);

nprmd = 20;
minripscore = 0.2;

for inl = 1:Nnl
   for imc = 1:Nmc

      rip.orig = ramssdata.rip{inl,imc};
      rc.orig = ramssdata.reg_comb{inl,imc};
      % [nregs, ni] = size(rip.orig);
      rip.srtd = regclassif(rip.orig);  % Reg/RIP classification
      rc.srtd = rc.orig(rip.srtd.ix,:);

      model = rc.srtd(1:nprmd,:);

      %% Generic regressor ranking (same methodolgy as Aguirre)
      for i = 1:nprmd
         % compare if regressor i bolongs to true regressors  (tregs)
         if(sum(prod(model(i,:) == tregs, 2)))
%             if (i <= ntregs) && (rip.srtd.rips(i,end) >= minripscore) % if regressor equality is lower than the nunber or true regs
            if (i <= ntregs) && (rip.srtd.lrip(i) >= minripscore) % if regressor equality is lower than the nunber or true regs
               nota(inl,imc) = nota(inl,imc) + 1/ntregs;
            elseif (rip.srtd.lrip(i) >= minripscore)
               nota(inl,imc) = nota(inl,imc) + 0.8^(i-ntregs)/ntregs;
            end
         end 
      end

   end % end of noise level iterations
end % end of MC iterations

score.values = nota;
score.mean = mean(score.values,2);
score.std = std(score.values,0,2);
score.noise_levels = simdata.noise.levels;
score.info.a = a;
