clear all;
close all;
clc

load digits_test;
y_test = test_trida;
N = size(y_test,2);
y_test = y_test + ones(1,N);
load digits_tren;
X_test = data_preprocessing_fast(test_data,tren_data);

load Image_DNN_128_128_10.mat;
tic
N = size(X_test,1);
scores1 = X_test*W1;
scores1(scores1<0) = 0;
scores1(:,end+1) = 1;
scores1(666,111)
scores2 = scores1 * W2;
scores2(scores2<0) = 0;
scores2(:,end+1) = 1;
scores3 = scores2 * W3;
[maxes, predicts] = max(scores3');
accuracy = mean(double(predicts' == y_test')) * 100;
fprintf('Pøesnost maticovì: %f\n', accuracy);
toc
