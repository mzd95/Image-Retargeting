clear;
clc;
close all;

% PATCH - SIZE : 7*7
%%% Declaring parameters for the retargeting
minImgSize = 30;                % lowest scale resolution size for min(w, h)
outSizeFactor = [1, 0.65];		% the ration of output image
numScales = 10;                 % number of scales (distributed logarithmically)

%% Preparing data for the retargeting
image = imread('SimakovFarmer.png');
[h, w, ~] = size(image);

targetSize = outSizeFactor .* [h, w];
%imageLab = rgb2lab(image); % Convert the source and target Images
%imageLab = double(imageLab)/255;
imageLab = double(image)/255;


% Gradual Scaling - iteratively icrease the relative resizing scale between the input and
% the output (working in the coarse level).
%% STEP 1 - do the retargeting at the coarsest level
S = imresize(imageLab,35/194);
res = S;
for i = 1:2:17
    res = imresize(res,[35 47-i]);
    [res, ~, ~] = search_vote_func(S , res, 6 ,1, i, 'C:\Users\User\Desktop\FinalProject', 'Patch');
end

%% STEP 2 - do resolution refinment 
% (upsample for numScales times to get the desired resolution)
for i =1 : numScales
    res = imresize(res,[35+15*i,30+13*i]);
    S = imresize(imageLab,[35+15*i,30+13*i]);
    [res, ~, ~] = search_vote_func(S, res, 4, 2, i, 'C:\Users\User\Desktop\FinalProject', 'Patch');
end

%% STEP 3 - do final scale iterations
% (refine the result at the last scale)
res = imresize(res,[194 169]);
[res, ann, bnn] = search_vote_func(imageLab, res, 4, 3, i, 'C:\Users\User\Desktop\FinalProject', 'Patch');
