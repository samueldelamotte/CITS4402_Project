function [X] = train_on_dataset(trainPath,imageSets, P)
%% Train on imageSets
fprintf('Started training --- %s\n',trainPath);
nrows = 112/2; %How much to downsample by
ncols = 92/2;
sNum = uint16(size(imageSets,1)); % number of sets
qNum = uint16((size(imageSets,2)-2)*P); % max numbers of individual images possible
X = zeros([nrows*ncols,qNum,sNum]);

for i = 1:sNum % iterate over each set
    Xfolder = fullfile(trainPath, imageSets{i,1});
    imgfiles = dir(Xfolder); % contents of set
    imagesInSet = length(imgfiles)-2; % amount of images in set

    for j = 1:imagesInSet % iterate over each image
        imgfile = imgfiles(j+2).name; %Access the imgfile name from imgfiles structure
        %disp(imgfile);
        h = fullfile(Xfolder,imgfile);
        u = imread(h);
        
        % Downsample and convert from integer to floating 
        % to normalise between 0-1 later
        u_ds = single(imresize(u,[nrows,ncols])); 
        
        w = u_ds(:)/255; %Turn into 1-D vector and normalise from 0-255 to 0-1
        
        X(:,j,i) = w; % Class specific model
    end
end
fprintf('Training finished --- %s\n',trainPath);
end
