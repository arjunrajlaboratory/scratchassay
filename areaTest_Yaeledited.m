addpath(genpath('~/Documents/GitHub/'));
input_dir ='/Users/lucianncuenca/Dropbox (RajLab)/luciann/AllData/Motility assays/20211104_Motility_Plate2/20211104_Raw images/';
output_dir ='/Users/lucianncuenca/Dropbox (RajLab)/luciann/AllData/Motility assays/20211104_Motility_Plate2/20211104_Areas/';
image_dir ='/Users/lucianncuenca/Dropbox (RajLab)/luciann/AllData/Motility assays/20211104_Motility_Plate2/20211104_Analyzed images/';
filePattern = fullfile(input_dir, '*.tif');
all_files = dir(filePattern);
%t = measure_area(image);
areas = cell(length(all_files),3);

for k = 1: length(all_files)
    baseFileName = all_files(k).name;
    fullFileName = fullfile(all_files(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    splits = strsplit(baseFileName, '_');
    area = measure_area(fullFileName,baseFileName, image_dir);
    time= splits{6};
    position= splits{7};
    
    %areas{k,1} = position;
    %areas{k,2} = time;
    %areas{k,3} = area;
    
    areas{k,1} = splits;
    areas{k,2} = area;

end

export_table = cell2table(areas);

writetable(export_table, strcat(output_dir, 'areas.csv'));

function maxArea = measure_area(imagefile, imageName, image_dir)
    im = imread(imagefile);

    h = fspecial('log',30,5);
    imshow(imfilter(im,h),[]);

    im2 = edge(im,'Canny');

    SE = strel('disk',5);
    im3 = imdilate(im2,SE);
    imshow(im3,[])
    im4 = imerode(im3,SE);
    imshow(im4,[])

    im5 = ~im4;
    imshow(im5);

    bw = bwconncomp(im5);
    rp = regionprops(bw);


    areas = [rp.Area];

    [maxArea,idx] = max(areas);

    pixels = bw.PixelIdxList{idx};
    maskIm = zeros(size(im));
    maskIm(pixels) = 1;
    imshow(maskIm);

    im5 = scale(im);
    RGB = cat(3, im5 + 0.2*maskIm, im5, im5);

    imshow(RGB);
    imwrite(RGB,[ image_dir ,'/', imageName(1:end-4),'RGB.jpg'])
    %imsave(RGB, ['RGB' imagefile]);
    
    maxArea;
end


