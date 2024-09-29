clear;
load('spydata.mat'); % This loads cPic and received
load('training.mat'); % This loads the training sequence

% Known parameters
L = 8; % Filter order (can be tuned)
N_training = length(training); % Number of known training symbols

% Build convolution matrix for the received training signal
R = convmtx(received(1:N_training), L + 1);

% Ensure R has the same number of rows as the length of the training sequence
R = R(1:N_training, :); 

% Solve for the equalizer coefficients using the training sequence
w = R \ training(:); % Now the dimensions should match

% Filter the entire received signal using the estimated equalizer
z = filter(w, 1, received);

% Plot the equalizer performance (optional)
figure; plot(training, 'b'); hold on; plot(z(1:N_training), 'r--');
legend('Original training sequence', 'Equalized output');

% Detect the transmitted symbols
b_hat = sign(z); % Threshold at zero

% Reconstruct the key
key_reconstructed = b_hat;

% Use the reconstructed key to decode the image
dPic = decoder(key_reconstructed, cPic);

% Display the decoded image
figure; image(dPic); axis square;
title('Decoded Image');

% Introduce random bit errors in the reconstructed key
error_rate = 0.05; % 5% of the bits will be flipped
n_errors = round(error_rate * length(key_reconstructed));
error_indices = randperm(length(key_reconstructed), n_errors);

% Flip the bits at the error indices
key_with_errors = key_reconstructed;
key_with_errors(error_indices) = -key_with_errors(error_indices);

% Decode the image with the erroneous key
dPic_err = decoder(key_with_errors, cPic);

% Display the corrupted image
figure; image(dPic_err); axis square;
title(['Decoded Image with ', num2str(error_rate * 100), '% Bit Errors']);