clear all;close all;clc;

% zvis=293;
zstart=5;
zend=6;


fname = 'C:\Users\Administrator\Documents\REVORGDATA\data\nanoTags\s5-c05long-60slices-si.tif';
tiff_info = imfinfo(fname); % return tiff structure, one element per image
tiff_stack = imread(fname, 1) ; % read in first image
%concatenate each successive tiff to tiff_stack
for ii = 2 : size(tiff_info, 1)
    temp_tiff = imread(fname, ii);
    tiff_stack = cat(3 , tiff_stack, temp_tiff);
end

tsStack=tiff_stack;

outKer = nonIsotropicGaussianPSF([4 4 4],3,'single');
% outKer = nonIsotropicGaussianPSF([5 5 5],3,'single');


intv=20;
for i=zstart:zend
    zvis=5;
    
% imagesc(tsStack(:,:,zvis));colormap('gray');axis image
[rows, columns, numSlices] = size(tsStack);

outputImage = zeros(rows, columns); % Or whatever class you want.

for j= zvis : zvis+intv-1
    
    outputImage=imadd(outputImage,double(tsStack(:,:,j)));
        
end
%    figure;imagesc(outputImage);colormap('gray');axis image
 %outputImage = imnoise(outputImage,'salt & pepper', 0.002);

%  G = fspecial('gaussian',[2 2],1);
% outputImage = imfilter(double(outputImage),G,'same');
 
niteration=10;
Image1proc=deconvhybimg2(outputImage,niteration,outKer(:,:,20));

Image1procf = imcrop(Image1proc,[160 305 180 180]);

dim = zeros(181,181);

Image1procolor = zeros([size(Image1procf,1) size(Image1procf,2) 3]);

% Image1procolor(:,:,1)=dim;
% Image1procolor(:,:,2)=dim;
% Image1procolor(:,:,3)=Image1procf;
Image1procolor = cat(3, dim,dim,Image1procf);

%Image1procolorf=ind2rgb(Image1procolor,map);

i=zvis;
myFolder = 'C:\Users\Administrator\Documents\REVORGDATA\paper\extractionScripts';
%filename = ['nanotag-forfig1-fluo-deconv-whole' num2str(i) '.tif'];
filename = ['nanotag-forfig1-si-deconv-whole.tif'];
R3 = {filename};
charR = cell2mat(R3);
fullFileName = fullfile(myFolder, charR);
imwrite(uint16(Image1proc), fullFileName);


myFolder = 'C:\Users\Administrator\Documents\REVORGDATA\paper\extractionScripts';
filename = ['nanotag-fig1b-si-deconv-gray.tif'];
R3 = {filename};
charR = cell2mat(R3);
fullFileName = fullfile(myFolder, charR);
imwrite(uint16(Image1procf), fullFileName);

myFolder = 'C:\Users\Administrator\Documents\REVORGDATA\paper\extractionScripts';
filename = ['nanotag-fig1b-si-deconv-color.png'];
R3 = {filename};
charR = cell2mat(R3);
fullFileName = fullfile(myFolder, charR);
imwrite(uint16(Image1procolor), fullFileName);

myFolder = 'C:\Users\Administrator\Documents\REVORGDATA\paper\extractionScripts';
filename = ['nanotag-fig1b-si-deconv-color.tiff'];
R3 = {filename};
charR = cell2mat(R3);
fullFileName = fullfile(myFolder, charR);
imwrite(uint16(Image1procolor), fullFileName);
end