
function [ sumDiffBox, countBox ] = calcBoxDiff( pixelDiff, mask,mini,maxi,minj,maxj )
sz = size(pixelDiff);
sumDiffBox = zeros(sz);
countBox = zeros(sz);
 
for startRow = mini:5:maxi 
    for startCol = minj:10:(maxj-230)
        [boxWidth, boxHeight] = findBoxLengthHeight( startCol, minj,maxj );
    diff = imcrop(pixelDiff, [startCol startRow boxWidth boxHeight]);
    maskCrop = imcrop(mask, [startCol startRow boxWidth boxHeight]);
    count = sum(sum(maskCrop));
  
  if count == 0 
      sumDiffBox(startRow, startCol) = 0;
  end
  
  sumDiffBox(startRow, startCol) = sum(sum(diff)) / count;
    countBox(startRow, startCol) = 1;
    end
end

end
