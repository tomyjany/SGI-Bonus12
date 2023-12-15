clear all;
close all;
clc

load spoken_test;
% N...po�et testovac�ch obr�zk� = 1000
% y_test...indexy t��d testovac�ch dat, rozm�r: 1000x1 = Nx1
y_test = test_trida;
%MATLAB indexuje od �isla 1 =>
%Pokud spo��t�me sk�re pro ��slovky od 0 do 9, budou tato sk�re v poli, kde
%sk�re pro ��slovku 0 bude na pozici 1 a sk�re pro ��slovku 9 na pozici 10.
%Pokud pak bude m�t nap�. ��slovka 0 maxim�ln� sk�re, bude index nejlep�� t��dy 1 nikoli 0.
%V referencich m� ale ��slovka 0 index t��dy 0 a ��slovka 9 index t��dy 9 =>
%Pokud k t�mto referen�n�m index�m p�i�teme ��slo jedna, budou indexy
%sed�t s MATLABEM a usnadn�me si vyhodnocov�n� �sp�nosti rozpozn�v�n�!
N = size(y_test,2);
y_test = y_test + ones(1,N);

load spoken_tren;
% Testovac� data je nutn� nejprve p�edzpracovat:
    % Je nutn� je normalizovat = ode��st st�edn� hodnotu tr�novac�ch dat
        % P��padn� je mo�n� je i vycentrovat
    % D�le jsou v r�mci p�edzpracov�n� testovac� data p�evedena z matice
    % Nx32x32 do matice Nx(32*32+1)
%X_test = data_preprocessing(test_data,tren_data);
X_test = data_preprocessing_fast(test_data,tren_data);

% na�ten� matic vah
load Spoken_DNN_128_128_10.mat;
% W1 je matice vah prvn� vrstvy, kter� m� 128 neuron�
    %rozm�ry jsou 1025x128
% W2 je matice vah druh� vrstvy, kter� m� tak� 128 neuron�
    %rozm�ry jsou 129x128
% W3 je matice vah t�et� vrstvy, kter� m� 10 neuron�
    %rozm�ry jsou 129x10    
    
%Nyn� jsou k dispozici p�ipraven� testovac� data v matici X_test a
%parametry klasifik�toru v matic�ch W1, W2 a W3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% KLASIFIKACE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% V�po�et bez pou�it� cykl� !!!!%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
N = size(X_test,1);
% ========================== V�� K�D ZDE ======================
%PRVN� VRSTVA:
%Nejprve sk�re:
scores1 = X_test*W1;

%N�sleduje aplikace aktiva�n� funkce ReLU (nam�sto sigmoidy)
%Tu lze zapsat bez pou�it� cyklu FOR pomoc� funkce FIND a toho, �e MATLAB
%umo��uje "logick�" indexov�n� viz nap�.: https://www.mathworks.com/help/matlab/math/matrix-indexing.html?refresh=true

scores1(scores1<0) = 0;
%Roz���en� vypo�ten� matice o vektor jedni�ek:
scores1(:,end+1) = 1;
% Kontrola: scores1(666,111) = 7.2073

%DRUH� VRSTVA:
%Nejprve sk�re:
scores2 = scores1 * W2;
%Aplikace aktiva�n� funkce ReLU (nam�sto sigmoidy)

scores2(scores2<0) = 0;
%Roz���en� vypo�ten� matice o vektor jedni�ek:

scores2(:,end+1) = 1;
% Kontrola: scores2(666,111) = 6.5808

%T�ET� VRSTVA:
%Sk�re:
scores3 = scores2 * W3;
%Neaplikujte ji� funkci ReLU, pro hled�n� maxima nen� pot�eba, po jej�
%aplikaci naopak dostanete sk�re jen 74.6 % procent, proto�e pokud je v�ce
%maxim < 0, v�echna tato maxima se stanou nulov�mi hodnotami a nebude
%vybr�no skute�n� spr�vn� maximum

%Funkce max pak zjist� pozice maxim�ln� hodnoty v ka�d�m ��dku p�edchoz�
%matice, v�sledkem je tedy vektor nejlep��ch sk�re o rozm�rech 1*N
[maxes, predicts] = max(scores3');
%V�po�et p�esnosti lze pak zapsat na jeden ��dek elegantn� jako:
accuracy = mean(double(predicts' == y_test')) * 100;
% =============================================================
% Kontrola: accuracy = 75.9 %
fprintf('P�esnost maticov�: %f\n', accuracy);
toc
