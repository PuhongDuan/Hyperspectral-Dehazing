                               
clc,clear,close all;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
pic=imread( 'A10.tif');%A7
% load simu_india1.mat;
% pic = pic;
[no_lines no_rows no_bands]=size(pic);

pic=double(pic);
% fimg=Normalization(pic);
fimg=reshape(pic,[no_lines*no_rows no_bands]);
[fimg] = scale_new(fimg);
fimg=reshape(fimg,[no_lines no_rows no_bands]);
for i=1: size(fimg,3)
    fimg(:,:,i)=imadjust(fimg(:,:,i),stretchlim(fimg(:,:,i)));
end
figure;imshow(fimg(:,:,[29 19 12]));

tic;
band_haze=mat2gray(mean(fimg(:,:,1:30),3));
band_no=mat2gray(mean(fimg(:,:,180:210),3));
% band_no=mat2gray(mean(fimg(:,:,180:200),3));
haze_map=band_haze-band_no;
haze_map(haze_map<0)=0;
figure;
subplot(131);imshow(band_haze);
subplot(132);imshow(band_no);
subplot(133);imshow(haze_map);

%% for simulated data1
[A,B,C,D] = get_index(fimg(:,:,[29 19 12]),band_haze,band_no,haze_map);

no_haze=reshape(fimg(A,B,:),[1 no_bands]);
have_haze=reshape(fimg(C,D,:),[1 no_bands]);

haze=have_haze-no_haze;
haze=haze./(haze_map(C,D)-haze_map(A,B));

haze_zero=zeros([no_lines, no_rows, no_bands]);
for k=1:no_lines
   for g=1:no_rows
        haze_zero(k,g,:)=haze;
   end
end
tmp = haze_zero.*haze_map;
% figure;imshow(tmp(:,:,[29 19 12]));

dehazed=(fimg-haze_zero.*haze_map);
runtime=toc;

result1=imadjust(dehazed(:,:,[29 19 12]),stretchlim(dehazed(:,:,[29 19 12]),[0.01 0.99]),[]);
figure;
subplot(131);
imshow(fimg(:,:,[29 19 12]));
subplot(132);
imshow(dehazed(:,:,[29 19 12]));
subplot(133);
imshow(result1);