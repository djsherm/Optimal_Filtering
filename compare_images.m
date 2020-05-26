function compare_images(frequencyD, spatialD11, spatialD21, noise, window, name)

%% DOCUMENTATION

% FUNCTION ACCEPTS 3 IMAGES: 1 FILTERED IN THE FREQUENCY DOMAIN,
% AND 2 FILTERED IN THE SPATIAL DOMAIN.  ALSO ACCEPTS VARIANCE OF NOISE, 
% FILTERING WINDOW (IN VECTOR) AND THE IMAGE NAME.
% FUNCTION DOES A SUBTRACTION OF FREQUENCY DOMAIN IMAGE 
% AND THE SPATIAL DOMAIN AND PLOTS THE RESULTS NICELY
%
% MADE BY: DANIEL SHERMAN
% FEBRUARY 10, 2020

%% START OF CODE

%perform image subtraction: frequency domain - spatial domain
comp100_11 = frequencyD - spatialD11;
comp100_21 = frequencyD - spatialD21;

%plot results
figure()
subplot(1,2,1)
imshow(uint8(comp100_11), [])
xlabel(strcat(['(Frequency Domain) - (', num2str(window(1)),'x', num2str(window(1)), ' Weiner)']))
ylabel(strcat(['\sigma^2 = ' num2str(noise)]))
colorbar
subplot(1,2,2)
imshow(uint8(comp100_21), [])
xlabel(strcat(['(Frequency Filter) - (', num2str(window(2)),'x', num2str(window(2)), ' Filter)']))
colorbar
sgtitle(strcat(['Noisy ' name ' Comparison']))



