
net = googlenet;

imds = imageDatastore('images', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

[imdsTrain, imdsValidation] = splitEachLabel(imds, 0.7);

out_name = net.Layers(length(net.Layers)).Name
learn_name = net.Layers(length(net.Layers) - 2).Name
num_categories = numel(categories(imds.Labels))

input_size = net.Layers(1).InputSize;

lgraph = layerGraph(net);

fc_layer = fullyConnectedLayer(num_categories, 'Name','new_fc', 'WeightLearnRateFactor', 10, 'BiasLearnRateFactor', 10);
new_output = classificationLayer('Name', 'new_output');

lgraph = replaceLayer(lgraph, learn_name, fc_layer);
lgraph = replaceLayer(lgraph, out_name, new_output);

layers = lgraph.Layers;
connections = lgraph.Connections;

layers(1:10) = freezeWeights(layers(1:10));
lgraph = createLgraphUsingConnections(layers, connections);

pixelRange = [-30 30];
scaleRange = [0.9 1.1];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange, ...
    'RandXScale',scaleRange, ...
    'RandYScale',scaleRange);
augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain, ...
    'DataAugmentation',imageAugmenter);

augimdsValidation = augmentedImageDatastore(inputSize(1:2),imdsValidation);

miniBatchSize = 10;
valFrequency = floor(numel(augimdsTrain.Files)/miniBatchSize);
options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',6, ...
    'InitialLearnRate',3e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',valFrequency, ...
    'Verbose',false, ...
    'Plots','training-progress');

net = trainNetwork(augimdsTrain, lgraph, options);

trained_net = net;
save trained_net