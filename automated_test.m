function [Solutions,Answers,Match,SuccessRate] = automated_test(X,selectedDir,testPath,imageSets,P, handles)
%% Create Solution and Answers calculate cell arrays
fprintf('Auto Testing Dataset --- %s\n',testPath);
sNum = uint16(size(X,3)); % number of people in the testing set.
qNum = uint16((size(imageSets,2)-2)*(1-P)); % max numbers of individual images possible
Solutions = cell(sNum,qNum); % used to store actual solutions for testing
Answers = cell(sNum,qNum); % used to store answers calculated from algorithm

for i = 1:sNum % gets solutions from imageSets{}
    for j = 1:qNum
        Solutions{i,j} = imageSets{i,1}; 
    end
end

%% Run test() on each image in each testing set
for ii = 1:sNum % iterate over each set
    fprintf('-----\nTesting: %s\n',imageSets{ii,1});
    sFolder = fullfile(testPath, imageSets{ii,1}); %e.g. '../Dataset1/s1'
    fprintf('Path= %s\n',sFolder);
    sFiles = dir(sFolder); % get the contents of each set folder
    xNum = round(imageSets{ii,2}*(1-P)); % specific number of images in the set
    
    for q = 1:xNum % iterate over each image in each set
        sfile = sFiles(2+q).name; % e.g. '1.pgm'
        fprintf('%s\n',sfile);
        
        z = imread(fullfile(sFolder,sfile)); % e.g. z = imread('../Dataset1/s1/1.pgm')
        
        if nargin == 6 % if GUI calls this function then these things happen
            axes(handles.lookingAxis);
            set(handles.lookingForText,'visible','on');
            imshow(z);
            drawnow;
        end
        
        answer = test(X,z); % gets answer from algorithm
        
        if nargin == 6 % if GUI calls this function then these things happen
            axes(handles.foundAxis);
            set(handles.foundText,'visible','on');
            answerIm = fullfile(selectedDir,imageSets{answer,1},imageSets{answer,3});
            imshow(answerIm);
            drawnow;
            pause(0.5);
            cla(handles.lookingAxis);
            cla(handles.foundAxis);
            set(handles.lookingForText,'visible','off');
            set(handles.foundText,'visible','off');
            drawnow;
        end
        
        Answers{ii,q} = imageSets{answer,1}; % store into Answers{}
    end
    fprintf('Answers:');
    disp(Answers(ii,:)); 
end
disp('Answers: ');
disp(Answers);

%% Calculate the success rate of the algorithm
Match = cell(sNum,qNum); % used to store 1 or 0 if answers=solutions, correct or not

for i = 1:sNum % check if answer=solution
    for j = 1:qNum
        Match{i,j} = isequal(Answers{i,j}, Solutions{i,j});
    end
end
Match2 = cell2mat(Match);
SuccessRate = mean(Match2(:)); % average of Match is the success rate
diary resultsLog;
fprintf('SuccessRate: %f\n',SuccessRate);
diary off;
end

