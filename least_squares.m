function filtered_image = least_squares(image, name,  noise, n_window)
%% DOCUMENTATION

% FUNCTION ACCEPTS AN IMAGE, THE IMAGE NAME, THE VARIANCE OF NOISE, AND A
% FILTER WINDOW.  FUCNTION ADDS NOISE TO THE IMAGE, AND APPLIES THE
% LEAST-SQUARES METHOD TO FILTERING THE IMAGE IN THE SPATIAL DOMAIN USING
% THE CROSS AND AUTOCORRELATION FUNCTIONS.  FUNCTION RETURNS THE OPTIMALLY
% FILTERED IMAGE AND PLOTS APPROPRIATELY

% MADE BY: DANIEL SHERMAN
% FEBRUARY 5, 2020


%% APPLY LEAST-SQUARES FILTERING

[row, col] = size(image);

noisy_image = double(image) + sqrt(noise)*randn(size(image)); %add noise to the image

n = fix(n_window/2); %define half window size, ensure is an integer

R_xx = zeros(n_window.^2, n_window.^2); %initialize autocorrelation function
r_sx = zeros(n_window.^2, 1); %initialize crosscorrelation function

for i = n + 1: row - n %iterate through the image, stopping where the window hits the image edge
    for j = n + 1: col - n
        x = double(noisy_image(i - n:i + n, j - n:j + n)); %take subsample of noisy image
        x_reshape = reshape(x, n_window.^2, 1); %reshape to an n_window^2 x 1 vector for easy processing
        R_xx = R_xx + x_reshape*(x_reshape.'); %find and update autocorrelation of the noisy subsample
        r_sx = r_sx + x_reshape*image(i,j); %find and update crosscorrelation of the noisy subsample with the clean image
    end
end

filter = reshape(inv(R_xx)*r_sx, n_window, n_window); %define the optimal Least-Squares filter

filtered_image = imfilter(noisy_image, filter); %apply the filter

%plot appropriately
figure()
subplot(1,2,1)
imshow(uint8(noisy_image))
title(strcat([name, ' with added noise']))
ylabel(strcat('\sigma^2 = ', num2str(noise)))
subplot(1,2,2)
imshow(uint8(filtered_image))
title('Optimally Filtered Image')
xlabel('Spatial Domain Approach')
ylabel(strcat([num2str(n_window), 'x', num2str(n_window), ' Window']))
