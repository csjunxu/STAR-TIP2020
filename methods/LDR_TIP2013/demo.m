
clc; clear all;
addpath('./CE');


%% user inputs
in_name = '135069';
in_ext = 'jpg';
in_file = sprintf('%s.%s', in_name, in_ext);



%% read an input file
in_RGB = imread(in_file);
[R,C,~] = size(in_RGB);

[in_Y, in_U, in_V] = rgb2yuv(in_RGB(:,:,1), in_RGB(:,:,2), in_RGB(:,:,3));
in_Y = double(in_Y);


% for the output performances
Results = struct('DE', {}, 'EME', {}, 'AB', {}, 'PixDist', {}, 'etime', {});


%% (1) Input
Results(1).DE = QM('DE', in_Y);
Results(1).EME = QM('EME', in_Y);
Results(1).AB = QM('AB', in_Y);
Results(1).PixDist = QM('PixDist', in_Y);


%% (2) HE
tic;
x.HE = HE(in_Y);
etime = toc;

% write an output image
HE_Y = zeros(R,C);
for j=1:R
    for i=1:C        
        HE_Y(j,i) = round( x.HE(in_Y(j,i)+1,1) );
    end
end
out_RGB = yuv2rgb(HE_Y, in_U, in_V);
imwrite(uint8(out_RGB), sprintf('%s_HE.%s', in_name, in_ext));

% evaluation
Results(2).DE = QM('DE', HE_Y);
Results(2).EME = QM('EME', HE_Y);
Results(2).AB = QM('AB', HE_Y);
Results(2).PixDist = QM('PixDist', HE_Y);
Results(2).etime = etime;


%% (3) WAHE
tic;
x.WAHE = WAHE(in_Y, 1.5);
etime = toc;

% write an output image
WAHE_Y = zeros(R,C);
for j=1:R
    for i=1:C        
        WAHE_Y(j,i) = round( x.WAHE(in_Y(j,i)+1,1) );
    end
end
out_RGB = yuv2rgb(WAHE_Y, in_U, in_V);
imwrite(uint8(out_RGB), sprintf('%s_WAHE.%s', in_name, in_ext));

% evaluation
Results(3).DE = QM('DE', WAHE_Y);
Results(3).EME = QM('EME', WAHE_Y);
Results(3).AB = QM('AB', WAHE_Y);
Results(3).PixDist = QM('PixDist', WAHE_Y);
Results(3).etime = etime;


%% (4) CVC
tic;
x.CVC = CVC(in_Y);
etime = toc;

% write an output image
CVC_Y = zeros(R,C);
for j=1:R
    for i=1:C        
        CVC_Y(j,i) = round( x.CVC(in_Y(j,i)+1,1) );
    end
end
out_RGB = yuv2rgb(CVC_Y, in_U, in_V);
imwrite(uint8(out_RGB), sprintf('%s_CVC.%s', in_name, in_ext));

% evaluation
Results(4).DE = QM('DE', CVC_Y);
Results(4).EME = QM('EME', CVC_Y);
Results(4).AB = QM('AB', CVC_Y);
Results(4).PixDist = QM('PixDist', CVC_Y);
Results(4).etime = etime;


%% (5) Proposed LDR
tic;
x.LDR = LDR(in_Y, 2.5);
etime = toc;

% write an output image
LDR_Y = zeros(R,C);
for j=1:R
    for i=1:C        
        LDR_Y(j,i) = round( x.LDR(in_Y(j,i)+1,1) );
    end
end
out_RGB = yuv2rgb(LDR_Y, in_U, in_V);
imwrite(uint8(out_RGB), sprintf('%s_LDR.%s', in_name, in_ext));

% evaluation
Results(5).DE = QM('DE', LDR_Y);
Results(5).EME = QM('EME', LDR_Y);
Results(5).AB = QM('AB', LDR_Y);
Results(5).PixDist = QM('PixDist', LDR_Y);
Results(5).etime = etime;



%% display results
fprintf('\n----------------------* Performance Evaluation *-----------------------\n');
fprintf('Input   %s.%s ] DE: %.2f, EME:% 6.2f, A B :% 7.2f, PixDist: % 5.2f\n',...
    in_name, in_ext, Results(1).DE, Results(1).EME, Results(1).AB, Results(1).PixDist);

for k=2:length(Results)
    switch k
        case 2
            fprintf('HE   ');
        case 3
            fprintf('WAHE ');
        case 4
            fprintf('CVC  ');
        case 5
            fprintf('LDR  ');
    end
    fprintf('in % 7.1f ms ] ', Results(k).etime * 1000);
    fprintf('DE: %.2f, ', Results(k).DE);
    fprintf('EME:% 6.2f, ', Results(k).EME);
    fprintf('AMBE:% 7.2f, ', abs(Results(k).AB-Results(1).AB));
    fprintf('PixDist: %.2f', Results(k).PixDist);
    
    fprintf('\n');
end

