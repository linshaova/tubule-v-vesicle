[file, path] = uigetfile2({'*.tif'; '*.png'});
raw=imread([path file]);
[fid, errmsg] =fopen([path 'weka_' file]);
if ~isempty(errmsg)
    disp(['File "weka_' file '" does not exit; generate it first from FIJI'])
    return
end
fclose(fid);
weka=imread([path 'weka_' file]);

tubule_mask=weka;
tubule_mask(weka~=1) = 0;

se = strel('disk', 1);
tubule_mask = imclose(tubule_mask, se);

others_mask=zeros(size(weka), 'uint8'); 
others_mask(weka>1) = 1;

tubule_labels=bwlabel(tubule_mask);
%statsT = regionprops('table', tubule_labels, 'Area', 'Circularity', 'Extent');
statsT = regionprops('table', tubule_labels, 'Area', 'ConvexArea','MaxFeretProperties', 'MinFeretProperties');
tubule_newmask=zeros(size(tubule_mask), 'uint8');
areaThresh = 50;   %% threshold 1: number of pixels
convexAreaThresh = 500;  %% threshold 2: area
aspectThresh = 1.5;
for i=1:height(statsT)
    if statsT.Area(i) > areaThresh && statsT.MaxFeretDiameter(i) / statsT.MinFeretDiameter(i) > aspectThresh
        tubule_newmask(tubule_labels==i) = 1;
    elseif statsT.ConvexArea(i) > convexAreaThresh
        tubule_newmask(tubule_labels==i) = 1;
    elseif statsT.Area(i) > areaThresh/2 && statsT.MaxFeretDiameter(i) / statsT.MinFeretDiameter(i) > 2*aspectThresh
            tubule_newmask(tubule_labels==i) = 1;
    else
        others_mask(tubule_labels==i) = 1;  % convert rejected tubule mask to "others"
    end
end

tubule_area = sum(tubule_newmask(:));
area_ratio = tubule_area / (sum(others_mask(:)) + tubule_area);
intensity_tubules = tubule_newmask .* raw;
intensity_others = others_mask .* raw;
intT = sum(intensity_tubules(:));
intO = sum(intensity_others(:));
intensity_ratio = intT / (intT + intO);

% Generate figure with masks overlaying on the raw image (learned from Jingh
[h, w] = size(raw);
C1=zeros(h,w,3, 'uint8');
for i=1:3
    C1(:,:,i) = raw*0.5;
end

idx = find(tubule_newmask>0);
raw_modified = C1(:,:,3);  
raw_modified(idx) = 255;
C1(:,:,2) = raw_modified;  % make the tubule channel green

idxR = find(others_mask>0);
raw_modified = C1(:,:,3);
raw_modified(idxR) = 255;
C1(:,:,1) = raw_modified;  % make the vesicles red

figure, imshow(C1)
imwrite(C1, [path 'figure_' file])  % save the final figure in the same folder starting with 'figure...'

% Append ratio results into a text file named "results.csv":
textFileName = 'results.csv';
fid = fopen([path textFileName], 'a');
fprintf(fid, '%s, %f, %f\n', file, area_ratio, intensity_ratio);
fclose(fid);
