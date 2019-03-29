%% Transfer Learning Using AlexNet
% Fine-tune a pretrained convolutional neural network to learn the features
% on a new collection of images.
%
% Transfer learning is commonly used in deep learning applications. You can
% take a pretrained network and use it as a starting point to learn a new
% task. Fine-tuning a network with transfer learning is much faster and
% easier than training from scratch. You can quickly transfer learning to a
% new task using a smaller number of training images.

%%
% Load the sample images as |ImageDatastore| objects.
[merchImagesTrain,merchImagesTest] = merchData;

%%
% In the sample data, there are 60 training images and 15 test images.
% Display 20 sample images.
% figure
% for i = 1:20
%     subplot(4,5,i)
%     
%     I = readimage(merchImagesTrain,i);
%     imshow(I)
%     drawnow
% end

%%
% Load a pretrained AlexNet network.
net = alexnet;

%%
% The last three layers of the pretrained network |net| are configured for
% 1000 classes. These three layers must be fine-tuned for the new
% classification problem. Extract all the layers except the last three from
% the pretrained network, |net|.
layersTransfer = net.Layers(1:end-3);
% disp(net.Layers(17));

%%
% Transfer the layers to the new task by replacing the last three layers
% with a fully connected layer, a softmax layer, and a classification
% output layer. Specify the options of the new fully connected layer
% according to the new data. Set the fully connected layer to be of the
% same size as the number of classes in the new data. To speed up training,
% also increase |'WeightLearnRateFactor'| and |'BiasLearnRateFactor'|
% values in the fully connected layer.

%%
% Determine the number of classes from the training data.
numClasses = numel(categories(merchImagesTrain.Labels))

%%
% Create the layer array by combining the transferred layers with the new
% layers.
layers = [...
    %imageInputLayer([101 431 3])
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];

%%
% If the training images differ in size from the image input layer, then
% you must resize or crop the image data. The images in |merchImages| are
% the same size as the input size of AlexNet, so you do not need to resize
% or crop the new image data.

%%
% Create the training options. For transfer learning, you want to keep the
% features from the early layers of the pretrained network (the transferred
% layer weights). Set |'InitialLearnRate'| to a low value. This low initial
% learn rate slows down learning on the transferred layers. In the previous
% step, you set the learn rate factors for the fully connected layer higher
% to speed up learning on the new final layers. This combination results in
% fast learning only on the new layers, while keeping the other layers
% fixed. When performing transfer learning, you do not need to train for as
% many epochs. To speed up training, you can reduce the value of the
% |'MaxEpochs'| name-value pair argument in the call to |trainingOptions|.
% To reduce memory usage, reduce |'MiniBatchSize'|.
options = trainingOptions('sgdm',...
    'MiniBatchSize',5,...
    'MaxEpochs',10,...
    'InitialLearnRate',0.0001);

%%
% Fine-tune the network using |trainNetwork| on the new layer array.
netTransfer = trainNetwork(merchImagesTrain,layers,options);
 save('trained.mat', 'netTransfer');


%%
% Classify the test images using |classify|.

[YPred,scores]  = classify(netTransfer,merchImagesTest);

%%counting the num of certain class object in all test dataset(counting)
% idx = randperm(numel(merchImagesTest.Files));
sz = numel(YPred);
s2 = "truck";
count = 0;
%figure
for i = 1:sz
    % maybe try a while loop instead to avoid having to know the number of
    % test dataset
    %subplot(2,2,i)
    %I = readimage(merchImagesTest,idx(i));
    %imshow(I)
    label = YPred(i);
    %title(string(label));
    if strcmp(string(label),s2)
        count = count+1;
    end
end
display(count);

%%
% Calculate the classification accuracy.
testLabels = merchImagesTest.Labels;

accuracy = sum(YPred==testLabels)/numel(YPred)

%%
% This example has high accuracy. If the accuracy is not high enough using
% transfer learning, try feature extraction instead.