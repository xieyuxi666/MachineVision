% 
% function [ threshold1, threshold2] = setThreshold( sumDiffBox, countBox )
% sz = size(sumDiffBox);
% Box1 = sumDiffBox(1:1:end, 1:1:2800);
% Box2 = sumDiffBox( 1:1:end, 2801:1:end);
% logicalBox1 = countBox(1:1:end, 1:1:2800);
% logicalBox2 = countBox( 1:1:end, 2801:1:end);
% count1 = sum(sum(logicalBox1));
% count2 = sum(sum(logicalBox2));
% num1 = nansum(nansum(Box1));
% num2 = nansum(nansum(Box2));
% 
% avg1 = num1/ count1;
% avg2 = num2 / count2;
% 
% % 
%  threshold1 = avg1*1;%adjust
%  threshold2 = avg2*1;%adjust
%  
% 
% 
% end

function [ threshold] = setThreshold( sumDiffBox,countBox )
logicalBox =  countBox(1:1:end, 1:1:end);
count = sum(sum(logicalBox));
num = nansum(nansum(sumDiffBox));

avg = num/ count;
 threshold = avg*2.5;%adjust
end





