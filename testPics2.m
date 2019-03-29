% Specify the folder where the files live.
myFolder = 'testData';
destDirectory = [myFolder '_out'];
mkdir(destDirectory);
% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end
% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, '*.JPG'); % Change to whatever pattern you need.
theFiles = dir(filePattern);
cellPics = cell([1 length(theFiles)]);
cellFinal = cell([1 1]);
count = 0;

%% save the images to a cell array
mask = makemask();
masksz = size(mask);

for i = 1:masksz(1)
    for j = 1:masksz(2)
    if mask(i,j) == 1
        ivalues(1) = i;
        jvalues(1) = j;
        break;
    end
    end
end

for i = masksz(1):(-1): 1
    for j = masksz(2):(-1): 1
    if mask(i,j) == 1
        ivalues(2) = i;
        jvalues(2) = j;
        break;
    end
    end
end

 for j = masksz(2):(-1): 1
    for i = masksz(1):(-1): 1
     if mask(i,j) == 1
        ivalues(3) = i;
        jvalues(3) = j;
        break;
    end
    end
 end
 
 for j = 1:masksz(2)
    for i = 1:masksz(1)
    if mask(i,j) == 1
        ivalues(4) = i;
        jvalues(4) = j;
        break;
    end
    end
 end

 maxi = max(ivalues);
 maxj = max(jvalues);
 mini = min(ivalues);
 minj = min(jvalues);
 
 deltai = maxi - mini;
 deltaj = maxj - minj;

for k = 1 : length(theFiles)
  baseFileName = theFiles(k).name;
  fullFileName = fullfile(myFolder, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);

  imageArray = imread(fullFileName);
%   imageArrayCrop = imcrop(imageArray, [minj mini deltaj deltai]); 
  cellPics{1,k} = imageArray;

end



%% gray scale
% grayImagesCell = cellPics;
% for k = 1 : length(theFiles)
%     RGB = cellPics{1,k};
%     I = rgb2gray(RGB);
%     I = I .* mask;
%     grayImagesCell{1,k} = I;
%     
% end

% pixelDiff = cell([1 length(theFiles)-1]);
sumPixel = zeros(size(rgb2gray(cellPics{1,1})));
for k = 1 : (length(theFiles) - 1)
    img1 = rgb2gray(cellPics{1,k}) .* mask;
    img2 = rgb2gray(cellPics{1,k+1}) .* mask;;
    alldiff = double(img1)-double(img2);
    alldiff(alldiff<0) = alldiff(alldiff<0).* (-1);
%     pixelDiff{1,k} = alldiff;
    sumPixel = sumPixel + alldiff;
end
avgPixelDiff = sumPixel ./ (length(theFiles)-1);
%    avgPixelDiffCrop = imcrop(avgPixelDiff, [minj mini deltaj deltai]);
   [Max, pos] = max(avgPixelDiff(:));
   avgPixelDiff = (avgPixelDiff ./ Max);
   avgPixelDiffCrop = imcrop(avgPixelDiff, [minj mini deltaj deltai]); 
     imshow(avgPixelDiffCrop);
 maskCrop = imcrop(mask, [minj mini deltaj deltai]); 
%% NOT seperate
 %  avg = sum(sum(avgPixelDiffCrop))/(sum(sum(maskCrop)));
 
 %add weight to pixel diff 4000*3000

 for k = 1 : (length(theFiles) - 1)
     img1 = rgb2gray(cellPics{1,k}) .* mask;
    img2 = rgb2gray(cellPics{1,k+1}) .* mask;
     diff = double(img1)-double(img2);
    diff(diff<0) = diff(diff<0).* (-1);
    
        for i = mini :1:maxi
          for j = minj:1:maxj
              if avgPixelDiff(i,j) ~= 0
            diff(i,j) = diff(i,j) ./ avgPixelDiff(i,j);
              else
                  diff(i,j) = 0;
              end
          end
         end
     [sumDiffBox, countBox] = calcBoxDiff( diff, mask, mini,maxi,minj,maxj);
%      threshold = setThreshold( sumDiffBox )
%      sumDiffBox(sumDiffBox<threshold) = 0;
    
threshold = setThreshold(sumDiffBox,countBox)
 sumDiffBox(sumDiffBox<threshold) = 0;
     
%% NOT seperating
     [M, I] = max(sumDiffBox(:));
    [cropRow,cropCol] = ind2sub(size(sumDiffBox), I);
    tempCol = cropCol;
    dis = deltaj;
    cropBoxWidth = findBoxLengthHeight(cropCol, minj,maxj);
    cropBoxHeight = cropBoxWidth;
    
    
    while(M > 0 && dis >= cropBoxWidth) %dis can be adjusted
        disp(M);
    count = count+1;
     disp(cropCol);
    if cropCol > maxj - cropBoxWidth -1
            cropCol = maxj - cropBoxWidth-1;
    end
        
    if cropRow >maxi - cropBoxHeight - 1
        cropRow = maxi - cropBoxHeight - 1;
    end
        cropFinal = imcrop(cellPics{1, k+1}, [cropCol cropRow cropBoxWidth cropBoxHeight]);
        cropFinal = imresize(cropFinal, [227 227]);
        cellFinal{1,count} = cropFinal;
        
        % save images to outputs folder
        
       fileName = [num2str(count) '.jpg'];
%         fileName = [num2str(M) '.jpg'];
        fileDest = fullfile(destDirectory,fileName);
        imwrite(cropFinal, fileDest);
        
        
      sumDiffBox(1:end,cropCol:(cropCol+cropBoxWidth)) = 0;%COULD BE ADJUSTED
      
      [M, I] = max(sumDiffBox(:));
    [cropRow,cropCol] = ind2sub(size(sumDiffBox), I);
    dis = abs(double(cropCol)- double(tempCol));
    tempCol = cropCol;
    cropBoxWidth = findBoxLengthHeight(cropCol, minj,maxj);
    cropBoxHeight = cropBoxWidth;
    end
 end
 
     
