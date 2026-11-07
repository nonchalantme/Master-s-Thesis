function [codevec,labelvec,datemat,datamat] = read_transposed_xlsx(xlsname,sheet,freq)
% READ_TRANSPOSED_XLSX  Read a "transposed" Eurostat/HICP sheet
%                       (periods in rows, series in columns).
%
%   NEW (German adaptation). Replaces readxls for the HICP workbooks, whose
%   layout differs from the layout readxls expects.
%
%   Assumed sheet layout (as in HICP_2020100.xlsx / 'HICP Transposed' and
%   HICP_Weights.xlsx / 'HICP Weights Transposed'):
%     - A header row whose first cell is 'Year'. From column 4 on, this row
%       holds the series codes (e.g. 'TOTAL','CP01',...).
%     - A row whose first cell is 'Series Name' holds the series labels.
%     - Data rows below the header row:
%         col 1 = year (number)
%         col 2 = month as 'JAN'...'DEC' (freq = 12) or anything (freq = 1)
%         col 3 = period string (ignored)
%         col 4:end = values; ':' or empty = not available -> NaN
%
%   Input:   xlsname = file name, sheet = sheet name,
%            freq    = 12 (monthly) or 1 (annual)
%   Output:  codevec  = ns x 1 cell of codes (upper case, trimmed)
%            labelvec = ns x 1 cell of labels
%            datemat  = T x 2 [year period] (period = month, or 1 if annual)
%            datamat  = T x ns numeric, NaN for missing

  % --- Read all cells (readcell in MATLAB R2019a+, xlsread otherwise/Octave)
  if exist('readcell','file') == 2 || exist('readcell','builtin') == 5
      raw = readcell(xlsname,'Sheet',sheet);
  else
      [~,~,raw] = xlsread(xlsname,sheet);
  end

  firstcol = cellfun(@cellstr1,raw(:,1),'UniformOutput',false);
  ihead = find(strcmpi(firstcol,'Year'),1);
  if isempty(ihead)
      error('read_transposed_xlsx: no header row starting with ''Year'' in sheet %s',sheet);
  end
  ilab = find(strcmpi(firstcol,'Series Name'),1);

  % --- Series codes and labels (columns 4:end with a non-empty code)
  codes = cellfun(@cellstr1,raw(ihead,4:end),'UniformOutput',false);
  jkeep = find(~cellfun(@isempty,codes));
  codevec = upper(strtrim(codes(jkeep)))';
  if ~isempty(ilab)
      labelvec = strtrim(cellfun(@cellstr1,raw(ilab,3+jkeep),'UniformOutput',false))';
  else
      labelvec = codevec;
  end

  % --- Data rows: those with a numeric year in column 1
  monthstr = {'JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'};
  nr = size(raw,1);
  datemat = NaN(nr,2);
  datamat = NaN(nr,numel(jkeep));
  irow = 0;
  for i = ihead+1:nr
      yr = cellnum(raw{i,1});
      if isnan(yr); continue; end
      if freq == 12
          m = find(strcmpi(strtrim(cellstr1(raw{i,2})),monthstr),1);
          if isempty(m)
              error('read_transposed_xlsx: unreadable month in row %d of sheet %s',i,sheet);
          end
      else
          m = 1;
      end
      irow = irow + 1;
      datemat(irow,:) = [yr m];
      for j = 1:numel(jkeep)
          datamat(irow,j) = cellnum(raw{i,3+jkeep(j)});
      end
  end
  datemat = datemat(1:irow,:);
  datamat = datamat(1:irow,:);
end

function s = cellstr1(c)
% Convert a cell entry to a string ('' for empty/missing/numeric NaN)
  if ischar(c)
      s = c;
  elseif isstring(c)
      s = char(c);
  elseif isnumeric(c) && ~isempty(c) && ~isnan(c(1))
      s = num2str(c(1));
  else
      s = '';
  end
end

function x = cellnum(c)
% Convert a cell entry to a number (NaN for ':', text, empty, missing)
  if isnumeric(c) && ~isempty(c)
      x = double(c(1));
  elseif ischar(c) || isstring(c)
      x = str2double(c);
  else
      x = NaN;
  end
end
