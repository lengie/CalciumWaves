function convertExp(fname)
%% Converts a tif video to a series of medium filtered PNGs
% Code initially by Jakub Tomek and edited by Liana Engie
% Last updated: sept 1 2017
%
% Keep this in the /data folder with the file, CaImaging goes in root
    fnameOut = strcat(fname,'_medfilt');
    mkdir(fnameOut);

    filterDimension = [5 5];

    info = imfinfo(fname);
    nFiles = numel(info);
    images = cell(nFiles, 1);
    imDiff = cell(nFiles-1, 1);
    % as an inset is processed only, the number of rows and columns is smaller
    % than the size of image.
    imRows = info.Height;
    imColumns = info.Width;
    tic
    maxIntensity = -1;
    for k = 1:(nFiles)
        im = imread(fname, k, 'Info', info);
        images{k} = im; % Uncomment for full-frame processing; comment the line above.
        if (k>=2)
            imDiff{k-1} = images{k}-images{k-1};
            m = max(imDiff{k-1}(:));
            if (m>maxIntensity)
                maxIntensity = m;
            end
        end
    end
    toc

    % scaling images to 
    for k = 1:length(imDiff)
       imScaled = round(imDiff{k} * (2^16/double(maxIntensity))); 

       %% Spatial filtering
       imScaledDenoised = medfilt2(imScaled, filterDimension, 'symmetric');
       %%
       imwrite(imScaledDenoised, [fnameOut '/' num2str(k) '.png']);
    end
end