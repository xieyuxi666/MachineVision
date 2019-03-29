TestingData = imageDatastore('test_out',...
    'IncludeSubfolders',true,...
    'LabelSource','foldernames');

load trained.mat;

% Classify the test images using |classify|.

[YPred,scores]  = classify(netTransfer,TestingData);

classes = categories(TestingData.Labels);
numClasses = numel(categories(TestingData.Labels));
sz = numel(YPred);
counts = zeros(numClasses,1);

fid = fopen('counts.txt', 'w');

for i = 1:sz
    label = YPred(i);
    for n = 1:numClasses
    if strcmp(string(label),classes{n,1})
        counts(n,1) = counts(n,1)+1;
    end
    end
end

for n = 1:numClasses
    txt = [classes{n,1} ': ' num2str(counts(n,1)) double(sprintf('\n'))];
    fwrite(fid, txt);
end

%%
% Calculate the classification accuracy.

 testLabels = TestingData.Labels;
 accuracy = sum(YPred==testLabels)/numel(YPred)
 txt2 = ['Accuracy: ' num2str(accuracy)];
 fwrite(fid, txt2);
 fclose(fid);