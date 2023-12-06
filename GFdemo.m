                               
clc,clear,close all;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
pic=imread( 'GF10.tif');

[no_lines no_rows no_bands]=size(pic);
pic=double(pic);
% fimg=Normalization(pic);
fimg=reshape(pic,[no_lines*no_rows no_bands]);
[fimg] = scale_new(fimg);
fimg=reshape(fimg,[no_lines no_rows no_bands]);
fimg(:,:,193:200)=[];
fimg(:,:,238:254)=[];
[no_lines no_rows no_bands]=size(fimg);
for i=1: size(fimg,3)
    fimg(:,:,i)=imadjust(fimg(:,:,i),stretchlim(fimg(:,:,i)));
end
figure;imshow(fimg(:,:,[58 38 20]));

tic;
band_haze=mat2gray(mean(fimg(:,:,1:61),3));
band_no=mat2gray(mean(fimg(:,:,251:287),3));
haze_map=band_haze-band_no;
haze_map(haze_map<0)=0;
figure;
subplot(131);imshow(band_haze);
subplot(132);imshow(band_no);
subplot(133);imshow(haze_map);
% haze_map=medfilt2(fimg(:,:,3),[3 3], 'symmetric');

%% for simulated data1
[A,B,C,D] = get_index(fimg(:,:,[58 38 20]),band_haze,band_no,haze_map);

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
% figure;imshow(tmp(:,:,[58 38 20]));

dehazed=(fimg-haze_zero.*haze_map);
runtime=toc;

result1=imadjust(dehazed(:,:,[58 38 20]),stretchlim(dehazed(:,:,[58 38 20]),[0.01 0.99]),[]);
figure;
subplot(131);
imshow(fimg(:,:,[58 38 20]));
subplot(132);
imshow(dehazed(:,:,[58 38 20]));
subplot(133);
imshow(result1);