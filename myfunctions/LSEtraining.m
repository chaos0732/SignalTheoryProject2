function omega = LSEtraining(a, b, L)
%find vector x that when key convolve with omega, then the answer is close to b 
A = convmtx(a,L+1);
A = A(1:length(a),:);
omega = mldivide(A,b);
