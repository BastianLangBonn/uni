%% Load Training Data
clear;
images = importdata('train.csv', ',', 1);
for iImage = 1:length(images.data)
    imageOne = images.data(iImage,:);
    for i = 1:28
       I{iImage}(i,:) = imageOne((i-1)*28+2:i*28+1);
       Label{iImage} = imageOne(1);
    end
    %image(images(100:120,100:120))
%     image(I{iImage});
%     title(Label{iImage});
%     pause(0.1);
end

image(I{1});
sift('image1.bmp');