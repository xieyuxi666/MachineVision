function [ mask ] = makemask(  )
mask = imread('mask1.png');
mask = rgb2gray(mask);
mask(mask~=0) = 1;
end
