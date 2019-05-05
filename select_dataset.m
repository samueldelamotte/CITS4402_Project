function [selectedDir, imageSets] = select_dataset()
%% User selects dataset directory
selectedDir = uigetdir('..', 'Select Dataset Folder to Open');
contents = dir(selectedDir);  % save contents of the selected dir

%% Creates a cell, "imageSets" that indexes sets
    % col 1 = set name, 
    % col 2 = how many images in each set
    % col 3+ = image names
imageSets = {}; % empty cell array to store contents of the dataset

N1 = length(contents);
for i = 3:N1 % iterate over selectedDir contents and store set names
    imageSets{i-2, 1} = contents(i).name;
    
    %setContents = dir(strcat(selectedDir, '\', imageSets{i-2, 1}));
    setContents = dir(fullfile(selectedDir,imageSets{i-2,1}));
    N2 = length(setContents);
    imageSets{i-2, 2} = N2-2;
    for j = 3:N2 % iterate over setContents and store set's images 
        imageSets{i-2, j} = setContents(j).name;
    end
end
disp(selectedDir);
end