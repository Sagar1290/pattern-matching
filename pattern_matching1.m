clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
format longg;
format compact;
fontSize = 20;

% Check that user has the Image Processing Toolbox installed.
hasIPT = license('test', 'image_toolbox');
if ~hasIPT
  % User does not have the toolbox installed.
  message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
  reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
  if strcmpi(reply, 'No')
    % User said No, so exit.
    return;
  end
end

% Read in a standard MATLAB color demo image.
folder = fullfile(matlabroot, '\toolbox\images\imdemos');
baseFileName = 'peppers.png';
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);
if ~exist(fullFileName, 'file')
  % Didn't find it there.  Check the search path for it.
  fullFileName = baseFileName; % No path this time.
  if ~exist(fullFileName, 'file')
    % Still didn't find it.  Alert user.
    errorMessage = sprintf('Error: %s does not exist.', fullFileName);
    uiwait(warndlg(errorMessage));
    return;
  end
end
rgbImage = imread(fullFileName);
% Get the dimensions of the image.  numberOfColorBands should be = 3.
[rows, columns, numberOfColorBands] = size(rgbImage);
% Display the original color image.
subplot(2, 2, 1);
imshow(rgbImage, []);
axis on;
title('Original Color Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

smallSubImage = imcrop(rgbImage, [192 82 60 52]);
%smallSubImage=imread('dollar.tif');
subplot(2, 2, 2);
imshow(smallSubImage, []);
axis on;
title('Template Image to Search For', 'FontSize', fontSize);

% Search the red channel for a match.
correlationOutput = normxcorr2(smallSubImage(:,:,1), rgbImage(:,:,1));
subplot(2, 2, 3);
imshow(correlationOutput,[]);
title('Correlation Output', 'FontSize', fontSize);

[maxCorrValue, maxIndex] = max(abs(correlationOutput(:)));
[ypeak, xpeak] = ind2sub(size(correlationOutput),maxIndex(1));
corr_offset = [(xpeak-size(smallSubImage,2)) (ypeak-size(smallSubImage,1))];

subplot(2, 2, 4);
imshow(rgbImage);
hold on;
rectangle('position',[corr_offset(1) corr_offset(2) 50 50],...
          'edgecolor','g','linewidth',2);
title('Template Image Found in Original Image', 'FontSize', fontSize);