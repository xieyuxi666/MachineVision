function [ length, height ] = findBoxLengthHeight( posx, minj,maxj  )
deltaj = maxj - minj;
 incre = (700.0-230.0)/deltaj;
 length = 700 - (posx-minj)*incre;
% height = 120 - (4.0/167.0) * posx;
height = 120;
end

