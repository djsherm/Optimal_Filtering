function filtered_image = least_squares_spat(image, noise, n_window, name)
%% DOCUMENTATION

% FUNCTION ACCEPTS AN IMAGE, VARIANCE OF NOISE, WINDOW SIZE, AND IMAGE
% NAME. FUNCTION DEFINES AND APPLIES CUSTOM LOW-PASS FILTER, THEN ADDS
% NOISE TO THE IMAGE.  FUNCTION APPLIES A SPATIAL DOMAIN APPROACH
% LEAST-SQUARES OPTIMAL FILTER TO FILTER NOISY FILTERED IMAGE.  FUNCTION
% RETURNS THE OPTIMALLY FILTERED IMAGE

%MADE BY: DANIEL SHERMAN
% FEBRUARY 11, 2020


%% APPLY DECONVOLUTION IN SPATIAL DOMAIN WITH A FILTERED IMAGE

[row, col] = size(image); %find image size

% define custom low pass filter size for the image
h0 = 0.8.^(abs(-row/2:row/2 - 1));
k = 1/sum(h0);
h = k.*h0;
H = fftshift(fft2((h.')*h));

%apply filter and add noise
clow_nimage = imfilter(imfilter(double(image), h, 'replicate'), h.', 'replicate') + sqrt(noise)*randn(size(image));

n = fix(n_window/2); %define half window size, ensure is an integer

R_xx = zeros(n_window.^2, n_window.^2); %initialize autocorrelation function
r_sx = zeros(n_window.^2, 1); %initialize crosscorrelation function

for i = n + 1: row - n %iterate through the image, stopping where the window hits the image edge
    for j = n + 1: col - n
        x = double(clow_nimage(i - n:i + n, j - n:j + n)); %take subsample of noisy image
        x_reshape = reshape(x, n_window.^2, 1); %reshape to an n_window^2 x 1 vector for easy processing
        R_xx = R_xx + x_reshape*(x_reshape.'); %find and update autocorrelation of the noisy subsample
        r_sx = r_sx + x_reshape*double(image(i,j)); %find and update crosscorrelation of the noisy subsample with the clean image
    end
end

filter = reshape(inv(R_xx)*r_sx, n_window, n_window); %define the optimal Least-Squares filter

filtered_image = imfilter(clow_nimage, filter); %apply the filter

%plot appropriately
figure()
subplot(1,2,1)
imshow(uint8(clow_nimage))
title(strcat(['Filtered ' name, ' with added noise']))
ylabel(strcat('\sigma^2 = ', num2str(noise)))
subplot(1,2,2)
imshow(uint8(filtered_image))
ylabel(strcat(['Window Size ', num2str(n_window), 'x', num2str(n_window)]))
xlabel('Spatial Domain Approach')
title('Optimally Filtered Image')