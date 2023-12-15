clear all;
close all;
clc
load digits_test;
load digits_tren;
load digits_test_nez2023;
N = size(test_data,1)
centertest_data = [];
centertest_trida = [];
for i=1:N
    centertest_data(i,:,:) = center_image(squeeze(test_data(i,:,:)));
    centertest_trida(i) = test_trida(i);
    disp(sprintf("%.2f%c CENTROVANI TESTOVACICH ",i*10/N,"%"))

end
save('centertest.mat','centertest_data','centertest_trida')
disp("Soubor centertest.mat byl vytvoren")

N = size(tren_data,1)
centertren_data = [];
centertren_trida = [];
for i=1:N
    centertren_data(i,:,:) = center_image(squeeze(tren_data(i,:,:)));
    centertren_trida(i) = tren_trida(i);
    disp(sprintf("%.2f%c CENTROVANI TRENOVACICH",i*100/N,"%"))
end

save('centertren.mat','centertren_data','centertren_trida')
disp("Soubor centertren.mat byl vytvoren")

N = size(test_nez_data,1)
centernez_data = [];
centernez_trida = [];
for i=1:N
    centernez_data(i,:,:) = center_image(squeeze(test_nez_data(i,:,:)));
    centernez_trida(i) = test_nez_trida(i);
    disp(sprintf("%.2f%c CENTROVANI Neznamych",i*100/N,"%"))
end

save('centernez.mat','centernez_data','centernez_trida')








function centered_image = center_image(im)
    s = size(im);
    imi = 255 - im;
   [height, width] = size(im);
    M = 1/sum(imi,"all");
    xid = 1:s(1);
    yid = 1:s(1);
    suma = 0;
    for i=1:32
        suma = suma + i*sum(imi(i,yid));
    end
    Y = suma*M;
    suma = 0;
    for i=1:32
        suma = suma + i*sum(imi(xid,i));
    end
    X = suma * M;


    shift_x = round(16 - X);
    shift_y = round(16 - Y);

    centered_image = ones(size(im))*double(im(1,1));
    
    centered_image(max(1, 1 + shift_y):min(height, height + shift_y), ...
        max(1, 1 + shift_x):min(width, width + shift_x)) = ...
        im(max(1, 1 - shift_y):min(height, height - shift_y), ...
        max(1, 1 - shift_x):min(width, width - shift_x));
end