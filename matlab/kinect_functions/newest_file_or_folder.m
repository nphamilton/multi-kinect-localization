function [ filename ] = newest_file_or_folder( directory ) 
% This function identifies the newest file or folder in a given directory 
  
% Collect the file identifications 
fis = dir(directory); 
  
% convert the struct into a cell matrix 
fic = struct2cell(fis); 
  
% Single out just the date numbers 
datenums = fic(6,:); 
  
% Turn all but the first two (. and ..) into a matrix 
l = length(datenums); 
datematrix = cell2mat(datenums(3:l)); 
  
% Find the max/newest thing 
[max_val, max_id] = max(datematrix); 
  
% Add back the offset from removing . and .. 
max_id = max_id + 2; 
  
% Return the result 
if fis(max_id).isdir == 1 
    filename = strcat(fis(max_id).folder, '/', fis(max_id).name); 
else 
    filename = fis(max_id).name; 
end 
end 