
function [maxArea,outputImage] = measureArea(inputImage)
    %im = imread(imagefile);
    im = inputImage;

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
    
    outputImage = RGB;

%     imshow(RGB);
%     imwrite(RGB,[ image_dir ,'/', imageName(1:end-4),'RGB.jpg'])
%     
%     maxArea;
end


