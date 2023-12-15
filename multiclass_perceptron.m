clear all;
close all;
clc

load digits_test;
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

load digits_tren;
% Testovac� data je nutn� nejprve p�edzpracovat:
    % Je nutn� je normalizovat = ode��st st�edn� hodnotu tr�novac�ch dat
        % P��padn� je mo�n� je i vycentrovat
    % D�le jsou v r�mci p�edzpracov�n� testovac� data p�evedena z matice
    % Nx32x32 do matice Nx(32*32+1)

%Je nutn� implementovat funkci data_preprocessing p��padn� i jej� v�po�etn�
%efektivn� variantu data_preprocessing_fast
%X_test = data_preprocessing(test_data,tren_data);
X_test = data_preprocessing_fast(test_data,tren_data);

% na�ten� matice vah
% D...dimenze = a*b+1, kde a je v��ka a b je ���ka obr�zku = 1025
% C...po�et t��d = 10
% W...matice vah klasifik�toru, rozm�r: DxC 1025x10 = 
load multiclass_perceptron_params.mat;
D = size(W,1);
C = size(W,2);

%Nyn� jsou k dispozici p�ipraven� testovac� data v matici X_test a
%parametry klasifik�toru v matici W

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% KLASIFIKACE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I. V�po�et �sp�nosti (p�esnosti) = accuracy pomoc� dvou cykl�%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
accuracy = 0;
%size(W)
% ========================== V�� K�D ZDE ======================
%Nejprve vn�j�� cyklus pro testovac� data:
for i=1:N        
    maxscore = realmin('single'); %score nejlep�� t��dy   
    predict = -1; %Index nejlep�� t��dy
    %Pot� vnit�n� cyklus pro jednotliv� t��dy:
    for c=1:C    
        %size(X_test(c,:))
        score = sigmoid_scalar(X_test(i,:)*W(:,c));
        if score>maxscore
            maxscore = score;
            predict = c;
        end
    end
    if (predict == y_test(i)) %Lze zapsat takto d�ky posunut� index�, jinak by muselo b�t predict == y_test(i) + 1
        accuracy = accuracy+1;
    end
end
% Kontrola: prvn� vypo�ten� hodnota score = 0.7729
% Kontrola: accuracy = 49%
% =============================================================
fprintf('P�esnost pomoc� dvou vno�en�ch cykl�: %f\n', 100*accuracy/N);
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%II. V�po�et p�esnosti pomoc� jednoho cyklu%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Pouze vn�j�� cyklus pro testovac� data
tic
accuracy1 = 0;
% ========================== V�� K�D ZDE ======================
for i=1:N    
    scores = sigmoid_cycles(X_test(i,:)*W);
    %Funkce max pak zjist� pozici maxim�ln� hodnoty:
    [maxscore, predict] = max(scores);
    if (predict == y_test(i))
        accuracy1 = accuracy1+1;
    end
end
% =============================================================
fprintf('P�esnost pomoc� jednoho cyklu: %f\n', 100*accuracy1/N);
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%III. V�po�et p�esnosti bez pou�it� cykl� !!!!%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
% ========================== V�� K�D ZDE ======================
%Nejprve v�po�et matice obsahuj�c� sk�re pro v�echna testovac� data a t��dy, jej� rozm�r mus� b�t N*C:
scores = sigmoid_fast(X_test * W);
[maxscores, predicts] = max(scores');
%Funkce max pak zjist� pozice maxim�ln� hodnoty v ka�d�m ��dku p�edchoz�
%matice, v�sledkem je tedy vektor nejlep��ch sk�re o rozm�rech 1*N
predicts = predicts';
%V�po�et p�esnosti lze pak zapsat na jeden ��dek elegantn� jako:
accuracy2 = mean(double(predicts == y_test')) * 100;
% =============================================================
fprintf('P�esnost maticov�: %f\n', accuracy2);
toc