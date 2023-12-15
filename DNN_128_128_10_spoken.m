clear all;
close all;
clc

load spoken_test;
% N...poèet testovacích obrázkù = 1000
% y_test...indexy tøíd testovacích dat, rozmìr: 1000x1 = Nx1
y_test = test_trida;
%MATLAB indexuje od èisla 1 =>
%Pokud spoèítáme skóre pro èíslovky od 0 do 9, budou tato skóre v poli, kde
%skóre pro èíslovku 0 bude na pozici 1 a skóre pro èíslovku 9 na pozici 10.
%Pokud pak bude mít napø. èíslovka 0 maximální skóre, bude index nejlepší tøídy 1 nikoli 0.
%V referencich má ale èíslovka 0 index tøídy 0 a èíslovka 9 index tøídy 9 =>
%Pokud k tìmto referenèním indexùm pøièteme èíslo jedna, budou indexy
%sedìt s MATLABEM a usnadníme si vyhodnocování úspìšnosti rozpoznávání!
N = size(y_test,2);
y_test = y_test + ones(1,N);

load spoken_tren;
% Testovací data je nutné nejprve pøedzpracovat:
    % Je nutné je normalizovat = odeèíst støední hodnotu trénovacích dat
        % Pøípadnì je možné je i vycentrovat
    % Dále jsou v rámci pøedzpracování testovací data pøevedena z matice
    % Nx32x32 do matice Nx(32*32+1)
%X_test = data_preprocessing(test_data,tren_data);
X_test = data_preprocessing_fast(test_data,tren_data);

% naètení matic vah
load Spoken_DNN_128_128_10.mat;
% W1 je matice vah první vrstvy, která má 128 neuronù
    %rozmìry jsou 1025x128
% W2 je matice vah druhé vrstvy, která má také 128 neuronù
    %rozmìry jsou 129x128
% W3 je matice vah tøetí vrstvy, která má 10 neuronù
    %rozmìry jsou 129x10    
    
%Nyní jsou k dispozici pøipravená testovací data v matici X_test a
%parametry klasifikátoru v maticích W1, W2 a W3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% KLASIFIKACE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Výpoèet bez použití cyklù !!!!%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
N = size(X_test,1);
% ========================== VÁŠ KÓD ZDE ======================
%PRVNÍ VRSTVA:
%Nejprve skóre:
scores1 = X_test*W1;

%Následuje aplikace aktivaèní funkce ReLU (namísto sigmoidy)
%Tu lze zapsat bez použití cyklu FOR pomocí funkce FIND a toho, že MATLAB
%umožòuje "logické" indexování viz napø.: https://www.mathworks.com/help/matlab/math/matrix-indexing.html?refresh=true

scores1(scores1<0) = 0;
%Rozšíøení vypoètené matice o vektor jednièek:
scores1(:,end+1) = 1;
% Kontrola: scores1(666,111) = 7.2073

%DRUHÁ VRSTVA:
%Nejprve skóre:
scores2 = scores1 * W2;
%Aplikace aktivaèní funkce ReLU (namísto sigmoidy)

scores2(scores2<0) = 0;
%Rozšíøení vypoètené matice o vektor jednièek:

scores2(:,end+1) = 1;
% Kontrola: scores2(666,111) = 6.5808

%TØETÍ VRSTVA:
%Skóre:
scores3 = scores2 * W3;
%Neaplikujte již funkci ReLU, pro hledání maxima není potøeba, po její
%aplikaci naopak dostanete skóre jen 74.6 % procent, protože pokud je více
%maxim < 0, všechna tato maxima se stanou nulovými hodnotami a nebude
%vybráno skuteèné správné maximum

%Funkce max pak zjistí pozice maximální hodnoty v každém øádku pøedchozí
%matice, výsledkem je tedy vektor nejlepších skóre o rozmìrech 1*N
[maxes, predicts] = max(scores3');
%Výpoèet pøesnosti lze pak zapsat na jeden øádek elegantnì jako:
accuracy = mean(double(predicts' == y_test')) * 100;
% =============================================================
% Kontrola: accuracy = 75.9 %
fprintf('Pøesnost maticovì: %f\n', accuracy);
toc
