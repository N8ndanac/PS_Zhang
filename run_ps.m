% Photometric stereo
%
%Author: Xiuming Zhang (GitHub: xiumingzhang), National Univ. of Singapore
%

clear;
close all;
clc;

addpath(genpath('./psmImages/'));

IMAGE = 'ring';

% Scale images later to save time
scale = 0.3;

% Read in mask
mask = imread([IMAGE '.mask2.png']);
mask = imresize(mask, scale);
mask = rgb2gray(mask);

%------------------------ Get light directions, L

fileID = fopen('lights.txt', 'r');
s = textscan(fileID, '%f %f %f', 'HeaderLines', 1, 'Delimiter', ' ');
fclose(fileID);
L = [s{1} s{2} s{3}];

%------------------------ Get images, I (same order as L)

I = cell(8, 1);
for idx = 1:size(I, 1)
    im = imread([IMAGE '.' num2str(idx) '.png']);
    im = imresize(im, scale);
    I{idx} = im;
end

%========================= SURFACE NORMALS =========================%

N = compute_surfNorm(I, L, mask);
% Visualization
imwrite(N, sprintf('./results/%s_norm1.png', IMAGE));
h = show_surfNorm(N, 4);
%saveas(h, sprintf('./results/%s_norm2.png', IMAGE));

%========================= HEIGHT MAP =========================%

Z = compute_heightMap(N, mask);
% Visualization
figure;
imshow(uint8(Z));
imwrite(uint8(Z), sprintf('./results/%s_height.png', IMAGE));
plot_depthMap('./results/', Z)
