function [dataTrain,dataTest] = merchData()

dataTrain = imageDatastore('test_out',...
    'IncludeSubfolders',true,...
    'LabelSource','foldernames');

dataTest = imageDatastore('test_out',...
    'IncludeSubfolders',true,...
    'LabelSource','foldernames');

dataTrain = shuffle(dataTrain);

end