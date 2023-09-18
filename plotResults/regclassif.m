function [srtd] = regclassif(rip)

   [nreg ni] = size(rip);     % number of RaMSS iterations
   srtd.lrip = zeros(nreg, 1); % sorted last rips
   srtd.rips = zeros(nreg, ni); % sorted rips (complete)

   % Separating rips iterations in selected an not selected:

   % Separing NOT SELECTED RIPs iterations:
   nsel_rip_ix = find(rip(:,ni)<1);   % not selected rips index
   nsel_rip = rip(nsel_rip_ix,:);     % not selected rips
   [nreg_nsel ni] = size(nsel_rip);   % nreg_sel: # of not selected regs (rip>=1)

   % Sorting the not selected RIPs:
   lnsel_rip = nsel_rip(:,ni);  % last iteration not sel. rips;
   [lnsel_rip_srtd, lnsel_rip_srtd_ix] = sort(lnsel_rip, 'descend');
   nsel_rip_ix_srtd = nsel_rip_ix(lnsel_rip_srtd_ix);
   nsel_rip_srtd = nsel_rip(lnsel_rip_srtd_ix,:);
   

   if (nreg_nsel ~= nreg)     % In case of one or more RIP is selected:
      % Separing SELECTED RIPs iterations:
      sel_rip_ix = find(rip(:,ni)==1);    % selected rips index
      sel_rip = rip(sel_rip_ix,:);        % selected rips
      [nreg_sel ni] = size(sel_rip);      % nreg_sel: # of selected regs (rip>=1)
      sel_iter = zeros(nreg_sel,1);

      % Finding the selection iteration fo selected RIPs:
      for i = 1:nreg_sel
         sel_iter(i) = min(find(sel_rip(i,:)==1)); % iterarion where i-st rip was selected.
      end
      [sel_iter_srtd, sel_iter_srtd_ix] = sort(sel_iter);
      lsel_rip_srtd = ni+1 - sel_iter_srtd;       % (new) last selected rips sorted
      sel_rip_ix_srtd = sel_rip_ix(sel_iter_srtd_ix);   % selected rip index sorted
      sel_rip_srtd = sel_rip(sel_iter_srtd_ix, :); % complete selected rips sorted
      % sel_rip_srtd = sel_rip(sel_rip_ix_srtd,:);

      % Creating a new modified RIPs matrix:
      srtd.ix = [sel_rip_ix_srtd; nsel_rip_ix_srtd];
      srtd.lrip(1:nreg_sel) = lsel_rip_srtd;   % Final sel. RIPs modified (greater than 1)
      srtd.lrip(nreg_sel+1:end) = lnsel_rip_srtd;
      srtd.rips = [sel_rip_srtd; nsel_rip_srtd];

      % srtd.rip(nreg_sel+1:end) = nsel_rip_srtd;
   else
      % Creating a new modified RIPs matrix:
      srtd.ix = nsel_rip_ix_srtd;
      srtd.lrip = nsel_rip_srtd(:,end);
      srtd.rips = nsel_rip_srtd;

      % srtd.rip = nsel_rip_srtd;
   end

end



