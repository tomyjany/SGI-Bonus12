clear all;
close all;
clc

load digits_test;
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

load digits_tren;
% Testovací data je nutné nejprve pøedzpracovat:
    % Je nutné je normalizovat = odeèíst støední hodnotu trénovacích dat
        % Pøípadnì je možné je i vycentrovat
    % Dále jsou v rámci pøedzpracování testovací data pøevedena z matice
    % Nx32x32 do matice Nx(32*32+1)

%Je nutné implementovat funkci data_preprocessing pøípadnì i její výpoèetnì
%efektivní variantu data_preprocessing_fast
%X_test = data_preprocessing(test_data,tren_data);
X_test = data_preprocessing_fast(test_data,tren_data);

% naètení matice vah
% D...dimenze = a*b+1, kde a je výška a b je šíøka obrázku = 1025
% C...poèet tøíd = 10
% W...matice vah klasifikátoru, rozmìr: DxC 1025x10 = 
load multiclass_perceptron_params.mat;
D = size(W,1);
C = size(W,2);

%Nyní jsou k dispozici pøipravená testovací data v matici X_test a
%parametry klasifikátoru v matici W

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% KLASIFIKACE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%I. Výpoèet úspìšnosti (pøesnosti) = accuracy pomocí dvou cyklù%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
accuracy = 0;
%size(W)
% ========================== VÁŠ KÓD ZDE ======================
%Nejprve vnìjší cyklus pro testovací data:
for i=1:N        
    maxscore = realmin('single'); %score nejlepší tøídy   
    predict = -1; %Index nejlepší tøídy
    %Poté vnitøní cyklus pro jednotlivé tøídy:
    for c=1:C    
        %size(X_test(c,:))
        score = sigmoid_scalar(X_test(i,:)*W(:,c));
        if score>maxscore
            maxscore = score;
            predict = c;
        end
    end
    if (predict == y_test(i)) %Lze zapsat takto díky posunutí indexù, jinak by muselo být predict == y_test(i) + 1
        accuracy = accuracy+1;
    end
end
% Kontrola: první vypoètená hodnota score = 0.7729
% Kontrola: accuracy = 49%
% =============================================================
fprintf('Pøesnost pomocí dvou vnoøených cyklù: %f\n', 100*accuracy/N);
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%II. Výpoèet pøesnosti pomocí jednoho cyklu%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Pouze vnìjší cyklus pro testovací data
tic
accuracy1 = 0;
% ========================== VÁŠ KÓD ZDE ======================
for i=1:N    
    scores = sigmoid_cycles(X_test(i,:)*W);
    %Funkce max pak zjistí pozici maximální hodnoty:
    [maxscore, predict] = max(scores);
    if (predict == y_test(i))
        accuracy1 = accuracy1+1;
    end
end
% =============================================================
fprintf('Pøesnost pomocí jednoho cyklu: %f\n', 100*accuracy1/N);
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%III. Výpoèet pøesnosti bez použití cyklù !!!!%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
% ========================== VÁŠ KÓD ZDE ======================
%Nejprve výpoèet matice obsahující skóre pro všechna testovací data a tøídy, její rozmìr musí být N*C:
scores = sigmoid_fast(X_test * W);
[maxscores, predicts] = max(scores');
%Funkce max pak zjistí pozice maximální hodnoty v každém øádku pøedchozí
%matice, výsledkem je tedy vektor nejlepších skóre o rozmìrech 1*N
predicts = predicts';
%Výpoèet pøesnosti lze pak zapsat na jeden øádek elegantnì jako:
accuracy2 = mean(double(predicts == y_test')) * 100;
% =============================================================
fprintf('Pøesnost maticovì: %f\n', accuracy2);
toc