%% How to run code from Main.m
% type "[Solutions,Answers,Match,SuccessRate] = Main(0.5, 1);" 
%   into the MATLAB console, P = 0.5, I = 1 ... 
%   50% train
%   50% test 
%   1 dataset permutation
%
% P = 0.3, I = 2 ... 
% 30% train
% 70% test
% 2 dataset permutations

%% Main.m
function [Solutions,Answers,Match,SuccessRate] = Main(P, I)
%% User selects the FaceDataset, then perform train,test for 1+ datasets
[selectedDir, imageSets] = select_dataset();

iterations = I; % how many datasets do we want to make
for datasetNum = 1:iterations
%% Partition the dataset images based on the value of P
% P = 0.5 means: 50% training, 50% testing
% P = 0.3 means: 30% training, 70% testing
    [trainPath, testPath] = dataset_partition(datasetNum,selectedDir,imageSets, P);
    
%% Train on each image partitioned into each training set
    [X] = train_on_dataset(trainPath,imageSets, P);
    
%% Automatically test each image partitioned into each testing set
    [Solutions,Answers,Match,SuccessRate] = automated_test(X,selectedDir,testPath,imageSets, P);

end
end