
function [maxArea,outputImage] = measureArea(inputImage)
    %im = imread(imagefile);
    im = inputImage;

    im2 = edge(im,'Canny',[0.001,0.1]);

    im3 = imdilate(im2,strel('disk',5));
    %imshow(im3,[])
    im4 = imerode(im3,strel('disk',10));
    %imshow(im4,[])

    im5 = ~im4;
    
    topbottom = false(size(im5));
    topbottom(1,:) = true;
    topbottom(end,:) = true;
    edgeStuff = imreconstruct(topbottom,im5);
    im5 = im5 & ~edgeStuff;
    
    %imshow(im5);

    bw = bwconncomp(im5);
    rp = regionprops(bw);


    areas = [rp.Area];

    [maxArea,idx] = max(areas);

    pixels = bw.PixelIdxList{idx};
    maskIm = zeros(size(im));
    maskIm(pixels) = 1;
    %imshow(maskIm);

    im5 = scale(im);
    RGB = cat(3, im5 + 0.2*maskIm, im5, im5);
    imshow(RGB);
    
    outputImage = RGB;

%     imshow(RGB);
%     imwrite(RGB,[ image_dir ,'/', imageName(1:end-4),'RGB.jpg'])
%     
%     maxArea;
end


