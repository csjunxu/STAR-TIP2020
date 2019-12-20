close all;
method='star';%'jiep';
Hats=im2double(imread('../img/juice_gt.png'));
for scale=1.4
    for alpha=0.001
        for beta=0.0001
            for pI=2
                for pR=1.3
                    Hatsc=im2double(imread(['/home/csjunxu/Paper/Enhancement/Results_Color/juice_' method '_' num2str(scale) '_' num2str(alpha) '_' num2str(beta) '_' num2str(pI) '_' num2str(pR) '.png']));
                    rHats=Hats(:,:,1);
                    gHats=Hats(:,:,2);
                    bHats=Hats(:,:,3);
                    rHatsc=Hatsc(:,:,1);
                    gHatsc=Hatsc(:,:,2);
                    bHatsc=Hatsc(:,:,3);
                    % 2.  Load the calibration information
                    %
                    sampPerDeg = 23;
                    load displaySPD;
                    load SmithPokornyCones;
                    rgb2lms = cones'* displaySPD;
                    load displayGamma;
                    rgbWhite = [1 1 1];
                    whitepoint = rgbWhite * rgb2lms';
                    
                    % 3.1  -- Convert the RGB data to LMS (or XYZ if you like).
                    %
                    img = [ rHats gHats bHats];
                    imgRGB = dac2rgb(img,gammaTable);
                    img1LMS = changeColorSpace(imgRGB,rgb2lms);
                    img = [ rHatsc gHatsc bHatsc];
                    imgRGB = dac2rgb(img,gammaTable);
                    img2LMS = changeColorSpace(imgRGB,rgb2lms);
                    imageformat = 'lms';
                    
                    % 4. --  Run the scielab function.
                    errorImage = scielab(sampPerDeg, img1LMS, img2LMS, whitepoint, imageformat);
                    
                    % 5. --  Examining and interpreting the results.
                    %
                    % max(img1LMS(:)), min(img1LMS(:))
                    % max(img2LMS(:)), min(img2LMS(:))
                    figure;
                    hist(errorImage(:),[1:2:100])
                    sum(errorImage(:) > 20)   % We think this is 173
                    
                    % Look at the spatial distribution of the errors.
                    %
                    errorTruncated = min(128*(errorImage/15),128*ones(size(errorImage)));
                    
                    % If you have the image processing toolbox, you can find out where the
                    % edges are and overlay the edges with the locations of the scielab
                    % errors
                    
                    %% For Matlab version 5, use the following command:
                    edgeImage = 129 * double(edge(rHats,'prewitt'));
                    %% For Matlab version 4 or 3, use the following command:
                    %edgeImage = 129 * double(edge(rHats,'prewitt'));
                    
                    comparison = max(edgeImage,errorTruncated);
                    mp = [gray(127); [0 1 0]; [1 0 0] ];
                    ht=figure;
                    colormap(mp)
                    image(comparison);
                    axis off
                    saveas_center(ht, ['../../juice_error_' method '_' num2str(scale) '_' num2str(alpha) '_' num2str(beta) '_' num2str(pI) '_' num2str(pR) '.png'], size(Hats,2), size(Hats,1));
                end
            end
        end
    end
end