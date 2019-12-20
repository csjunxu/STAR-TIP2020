clc;clear;
%%% choose test dataset
datasets = {'LowLight', 'NASA', 'LDR', 'NPE', 'VV'};
ext         =  {'*.jpg','*.jpeg','*.JPG','*.png','*.bmp'};
for d = 1:length(datasets)
    Testset = datasets{d}; % select test dataset
    Test_dir  = fullfile('/home/csjunxu/Paper/Enhancement/Dataset', ['Images_' Testset]);
    %%% read images
    im_dir   =  [];
    for i = 1 : length(ext)
        im_dir = cat(1,im_dir, dir(fullfile(Test_dir,ext{i})));
    end
    im_num = length(im_dir);
    %%% methods
    addpath(genpath('methods'));
    methods = {'LIMEBM3D_TIP2017', 'LIME_TIP2017', 'JieP_ICCV2017', 'WVM_CVPR2016', 'MF_SP2016', ...
        'NPE_TIP2013', 'SRIE_TIP2015', 'LDR_TIP2013', 'CVC_TIP2011', ...
        'WAHE_TIP2009', 'BPDHE_TCE2010', 'MSRCR', 'SSR_TIP1997', 'HE', ...
        'Dong_ICME2011', 'BIMEF_2019', 'Li_TIP2018'};
    % 'Li_TIP2018': would run out of memory or SVD include NaN or Inf
    
    %%% begin comparisons
    write_mat_dir = ['/home/csjunxu/Paper/Enhancement/Results_' Testset '/'];
    % write_mat_dir = '/home/csjunxu/Paper/Enhancement/Results_NASA/';
    for m = 1:length(methods)
        method = methods{m};
        write_img_dir = [write_mat_dir method '/'];
        if ~isdir(write_img_dir)
            mkdir(write_img_dir);
        end
        for i = 1:im_num
            name = regexp(im_dir(i).name, '\.', 'split');
            if strcmp(method, 'LIME_TIP2017') == 1
                addpath(genpath('./methods/BM3D/'));
                Im = imresize(im2double(imread(fullfile(Test_dir, im_dir(i).name))),1);
                %--------------------------------------------------------------
                post = false; % true
                para.lambda = .15; % Trade-off coefficient
                % Although this parameter can perform well in a relatively large range,
                % it should be tuned for different solvers and weighting strategies due to
                % their difference in value scale.
                % Typically, lambda for exact solver < for sped-up solver
                % and using Strategy III < II < I
                % ---> lambda = 0.15 is fine for SPED-UP SOLVER + STRATEGY III
                % ......
                para.sigma = 2; % Sigma for Strategy III
                para.gamma = 0.7; %  Gamma Transformation on Illumination Map
                para.solver = 1; % 1: Sped-up Solver; 2: Exact Solver
                para.strategy = 3;% 1: Strategy I; 2: II; 3: III
                %---------------------------------------------------------------
                [eIm, T_ini,T_ref] = LIME_TIP2017(Im,para);
                % convert Im and eIm to uint8
                Im = uint8(Im*255);
                eIm = uint8(eIm*255);
            elseif strcmp(method, 'Dong_ICME2011') == 1
                Im=imread(fullfile(Test_dir, im_dir(i).name));
                eIm = Dong_ICME2011(Im);
                % convert Im and eIm to uint8
                Im = uint8(Im*255);
                eIm = uint8(eIm*255);
            elseif strcmp(method, 'JieP_ICCV2017') == 1
                Im=im2double( imread(fullfile(Test_dir, im_dir(i).name)) );
                gamma=2.2;
                [I, R] = jiep(Im);
                hsv = rgb2hsv(Im);
                I_gamma = I.^(1/gamma);
                S_gamma = R .* I_gamma;
                hsv(:,:,3) = S_gamma;
                eIm = hsv2rgb(hsv);
                % convert Im and eIm to uint8
                Im = uint8(Im*255);
                eIm = uint8(eIm*255);
            elseif strcmp(method, 'WVM_CVPR2016') == 1
                Im=double( imread(fullfile(Test_dir, im_dir(i).name)) );
                if size(Im,3)>1
                    HSV = rgb2hsv(Im);   % RGB space to HSV  space
                    S = HSV(:,:,3);       % V layer
                else
                    S = Im;              % gray image
                end
                c_1 = 0.01; c_2 = 0.1; lambda = 1;     % set parameters
                epsilon_stop = 1e-3;  % stopping criteria
                [ R, L, epsilon_R, epsilon_L ] = WVM_CVPR2016( S, c_1, c_2, lambda, epsilon_stop );
                %%% Gamma correction
                gamma = 2.2;
                L_gamma = 255*((L/255).^(1/gamma));
                enhanced_V = R .* L_gamma;
                HSV(:,:,3) = enhanced_V;
                eIm = hsv2rgb(HSV);
                % convert Im and eIm to uint8
                Im = uint8(Im);
                eIm = uint8(eIm);
            elseif strcmp(method, 'MF_SP2016') == 1
                Im=double( imread(fullfile(Test_dir, im_dir(i).name)) );
                eIm = MF_SP2016(Im);
                % convert Im and eIm to uint8
                Im = uint8(Im);
                eIm = uint8(eIm);
            elseif strcmp(method, 'SRIE_TIP2015') == 1
                Im = imread(fullfile(Test_dir, im_dir(i).name));
                alpha = 1000; beta= 0.01; gamma = 0.1; lambda = 10; % set parameters
                error_R = 10; error_I = 10; % initial stopping criteria error_R and error_I
                stop = 0.1;  % stopping criteria
                HSV = rgb2hsv( double(Im) );   % RGB space to HSV  space
                S = HSV(:,:,3);       % V layer
                [ R, I, error_R, error_I ] = SRIE_TIP2015( S, alpha, beta, gamma, lambda, ...
                    error_R, error_I, stop);
                % Gamma correction
                gamma1 = 2.2;
                I_gamma = 255 * ( (I/255).^(1/gamma1) );
                enhanced_V = R .* I_gamma;
                HSV(:,:,3) = enhanced_V;
                eIm = hsv2rgb(HSV);  %  HSV space to RGB space
                % convert Im and eIm to uint8
                eIm = uint8(eIm);
            elseif strcmp(method, 'NPE_TIP2013') == 1
                addpath('methods/NPE_TIP2013/');
                Im = imread(fullfile(Test_dir, im_dir(i).name));
                eIm=NPEA(fullfile(Test_dir, im_dir(i).name));
            elseif strcmp(method, 'BPDHE_TCE2010') == 1
                Im = imread(fullfile(Test_dir, im_dir(i).name));
                eIm = BPDHE_TCE2010(Im);
            elseif   strcmp(method, 'MSRCR') == 1
                addpath('methods/multiscaleRetinex/');
                Im = imread(fullfile(Test_dir, im_dir(i).name));
                eIm = multiscaleRetinex(Im, 'MSRCR');
                % convert Im and eIm to uint8
                eIm = uint8(eIm*255);
            elseif strcmp(method, 'SSR_TIP1997') == 1
                Im = imread(fullfile(Test_dir, im_dir(i).name));
                if size(Im,3)>1
                    HSV = rgb2hsv(Im);   % RGB space to HSV  space
                    X = HSV(:,:,3);       % V layer
                else
                    X = Im;              % gray image
                end
                [R,L] = SSR_TIP1997(X, [], 1);
                %%% Gamma correction
                gamma = 2.2;
                L_gamma = ((L/255).^(1/gamma));
                enhanced_V = R .* L_gamma;
                HSV(:,:,3) = enhanced_V;
                eIm = hsv2rgb(HSV);
                % convert Im and eIm to uint8
                eIm = uint8(eIm);
                % eIm = multiscaleRetinex(Im, 'SSR');
                % eIm = SSR_TIP1997(Im, 10000); % will fail on NPE dataset
            elseif strcmp(method, 'HE') == 1
                Im=im2double( imread(fullfile(Test_dir, im_dir(i).name)) );
                [eIm, ~] = histeq(Im);
                % convert Im and eIm to uint8
                Im = uint8(Im*255);
                eIm = uint8(eIm*255);
            elseif strcmp(method, 'BIMEF_2019') == 1
                addpath('methods/BIMEFutil/');
                Im=imread(fullfile(Test_dir, im_dir(i).name));
                eIm = BIMEF_2019(Im);
                % convert Im and eIm to uint8
                eIm = uint8(eIm);
            elseif strcmp(method, 'LDR_TIP2013') == 1
                addpath('methods/LDR_TIP2013/');
                Im=imread(fullfile(Test_dir, im_dir(i).name));
                eIm = LDR_TIP2013(Im, 2.5);
            elseif strcmp(method, 'CVC_TIP2011') == 1
                Im=imread(fullfile(Test_dir, im_dir(i).name));
                eIm = CVC_TIP2011(Im);
            elseif strcmp(method, 'WAHE_TIP2009') == 1
                Im=imread(fullfile(Test_dir, im_dir(i).name));
                eIm = WAHE_TIP2009(Im,1.5);
            elseif strcmp(method, 'Li_TIP2018') == 1
                Im = double(imread(fullfile(Test_dir, im_dir(i).name)));
                para.epsilon_stop_L = 1e-3;
                para.epsilon_stop_R = 1e-3;
                para.epsilon = 10/255;
                para.u = 1;
                para.ro = 1.5;
                para.lambda = 5;
                para.beta = 0.01;
                para.omega = 0.01;
                para.delta = 10;
                gamma = 2.2;
                [R, L, N] = Li_TIP2018(Im, para); % N is the noise map
                % imshow((N-min(min(N)))./(max(max(N))-min(min(N))))
                eIm = R.*L.^(1/gamma);
                % convert Im and eIm to uint8
                Im = uint8(Im);
                eIm = uint8(eIm);
            end
            %%% image level metrics
            fprintf([Testset ', ' method ', ' name{1} ' is done\n']);
            imwrite(eIm, [write_img_dir method '_' name{1} '.jpg']);
        end
    end
end
