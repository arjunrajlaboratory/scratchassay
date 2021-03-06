
function analyzeScratchAssayFolder(varargin)

% if nargin == 1
%     inputDirectory = varargin{1};
% end


allFiles = dir('*.tif'); % find all the files in the directory

areas = [];
times = [];
positions = [];
fileNames = [];

mkdir('analyzedImages');
mkdir('savedData');

for i = 1:length(allFiles)
    fileName = string(allFiles(i).name);
    fprintf('Now reading file %d of %d, %s\n',i,length(allFiles),fileName);
    
    splits = strsplit(fileName,'_');
    
    time = str2double(splits{6}(2:end));
    position = str2double(splits{7}(3:end));
    
    im = imread(fileName);
    [area,outputImage] = measureArea(im);
    
    fileNameChar = char(fileName);
    imwrite(outputImage,['analyzedImages/' fileNameChar(1:end-3) 'RGB.jpg']);
    
    areas = [areas; area];
    times = [times; time];
    positions = [positions; position];
    fileNames = [fileNames; fileName];
    

end



T = table(fileNames, times, positions, areas);
writetable(T,'savedData/data.csv');

