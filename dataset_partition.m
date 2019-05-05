function [trainPath, testPath, datasetDir] = dataset_partition(datasetNum,selectedDir,imageSets, P)
%% Change directory and create dataset#, train and test folders
if datasetNum == 1
    disp('Started Partitioning Datasets...');
end
I = num2str(datasetNum); % how many datasets to make
sNum = uint16(size(imageSets,1)); % how many sets in the selectedDir
originalDir = pwd; % save current directory for later
cd ../.;
if datasetNum == 1
    mkdir Datasets;
end
cd Datasets;
datasetDir = pwd; 
mkdir(sprintf('dataset%s',I));
cd(sprintf('dataset%s',I));
mkdir train;
mkdir test;
trainPath = fullfile(pwd,'train'); % training dataset path
testPath = fullfile(pwd,'test'); % testing dataset path

%% Create individual set folders and copy image files into set folders
for i = 1:sNum
    % In the Training and Testing folders, make a directory for each set
    mkdir(sprintf('%s/%s',trainPath,imageSets{i,1}));
    mkdir(sprintf('%s/%s',testPath,imageSets{i,1}));
    
    % For each person i, partition the n amount of images randomly  
    % P = 0.30 means that 30% of the gallery is used for training sets, 
    % 70% for testing sets
    n = imageSets{i,2}; % how many images in each individual set
    imgnums = randperm(n); % Randomly rearrange numbers from 1-n
    
    trainingnums = imgnums(1:round(P*n)); % specific images for training set
    testingnums = imgnums(round(P*n)+1:end); % specific images for testing set
    

    % Make copies of the training images selected
    for itrain = trainingnums % copy images based on position in imageSets, into train sets
        imgfile = fullfile(selectedDir,imageSets{i,1}, imageSets{i, itrain+2});
        destfile = fullfile(trainPath,imageSets{i,1}, imageSets{i, itrain+2});
        copyfile(imgfile,destfile);
    end
    
    % Make copies of the testing images selected
    for itest = testingnums % copy images based on position in imageSets, into test sets
        imgfile = fullfile(selectedDir,imageSets{i,1}, imageSets{i, itest+2});
        destfile = fullfile(testPath,imageSets{i,1}, imageSets{i, itest+2});
        copyfile(imgfile,destfile);
    end
    
end

%% Change back into the original code directory
cd(originalDir);
fprintf('Partitioned Dataset --- %s\n',strcat(datasetDir,I));
end
