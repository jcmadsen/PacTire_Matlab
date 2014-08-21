function [tireData] = readTIRE(fileID)

%=========================================================================%
% This function parses a .tire input file to obtain the necessary parameters
%=========================================================================%
fileID      = '205_60_R15_91V_2-2bar.tire';

fid    = fopen(fileID);
tline  = fgetl(fid);

lineNr = 0;

while ischar(tline)
    
    lineNr       = lineNr + 1;
    
    tline        = fgetl(fid);
    
    % clear comments from line
    commentIndex = strfind(tline,'%');
    
    if isempty(commentIndex) == 0
        if commentIndex  == 1
            % comment line - ignore this
            continue
        else        
            % remove comment within data string and clear blanks
            tline  = tline(1:commentIndex - 1);
            tline  = strtrim(tline);
        end;
        
    end;
    
    % tline string is now ready to be parsed for data
    
    if strcmp(tline,'end')
        break;        
    end;
    
    if isempty(tline) == 0
        coeff  = sscanf(tline,'%s %*s %*s');
        value  = sscanf(tline,'%*s %*s %f');

        tireData.(coeff) = value;
    end;
    
    
end;

fclose(fid);

%=========================================================================%
end