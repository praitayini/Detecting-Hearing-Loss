L=0.005;
T= 0:L:10;
figure(1)
plot(T,val(:,1:2001));
title('input signal, ABR Physionet')
xlabel('ms')
ylabel('amplitude')
n=50;
wn=[0.05 100]/1000;
[B A]= fir1(n,wn,'bandpass',hann(51));
h=freqz(B,A);
figure(2)
y1=filter(B,A,val(:,1:2001));
plot(T,y1);
title('filtered signal');

lev = 11;   %level 10
wave='db4';  %Haar wavelet
[C,L] = wavedec(val(:,1:2001), lev, wave);%to decompose a signal into discrete wavelet coefficients
dwtcoeff=C;

a= dwtcoeff(:,1:1035)';
b= dwtcoeff(:,1036:2070)';
X = a;         % input data
Y = b;          % response data

rng(1); % For reproducibility
% kernel and its parameter can be changed in the template below
template = templateSVM('KernelFunction', 'linear', 'KernelScale', 'auto', 'BoxConstraint', 1, 'Standardize', 1);
Mdlsvm = fitcecoc(X,Y,'Learners',template,'FitPosterior',1,'ClassNames',{'1','2','3'},'Verbose',2);
  
% Perform cross-validation
Model = crossval(Mdlsvm, 'KFold', 5); 
% Compute validation accuracy
valAccuracy = 1 - kfoldLoss(Model, 'LossFun', 'ClassifError');
 % % Compute validation predictions and scores
[validationPredictions, validationScores] = kfoldPredict(Model);
% code for testing the network where test is the new data set which was not used in testing.
Y = predict(Mdlsvm,test)
