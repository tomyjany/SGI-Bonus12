function x_out = data_preprocessing(x_in,x_tren_in)
    % x_in...vstupní testovaci data data, rozmìr: 1000x32x32 = Ntest x 32 x 32
    % x_tren_in...vstupní trenovací data, rozmìr: 9000x32x32 = Ntren x 32 x 32
    % x_out...výstupní testovací data

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Provedení normalizace pomocí cyklu %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Nejprve støední hodnota jednotlivých pixelù trénovacích obrázkù pomocí pøíkazu
    % mean:
    norm_factor = mean(x_tren_in,1);
    % Poté normalizace jednotlivých obrázkù odeètením vypoètených 32 støedních
    % hodnot:
    % Cyklus pro všechna testovací data:
    % ========================== VÁŠ KÓD ZDE ======================
    N = size(x_in,1);
    for i=1:N  
        x_out_tmp(i,:,:) = x_in(i,:,:) - norm_factor;
    end
    %disp("kontrola normalizace mela by byt (4.83)");
    %x_out_tmp(10,10,10)
    % Kontrola: x_out_tmp(10,10,10) = 4.83
    % =============================================================
        
    % Matici x_out_tmp o rozmìrech Nx32x32 dále pøevedeme na matici o rozmìrech
    % Nx1024, pøièemž budeme postupovat po øádcích a pak po sloupcích:

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % RESHAPE matice pomocí cyklu %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:N  
        %Nejprve øádek
        index = 1;
        % ========================== VÁŠ KÓD ZDE ======================
        for a=1:32
            %Poté sloupec
            for b=1:32
                x_out(i,index) = x_out_tmp(i,a,b);
                index = index + 1;
                
            end
        end
        % =============================================================

    end
    %{
        disp("Size of x_out ")
        size(x_out)
        disp("Kontrola x_out 666 = 0.3272 ")
        x_out(666,666)
    %}
    % Kontrola: x_out(666,666) = 0.3272
    % =============================================================    

    % Zbývá jen doplnit každý vektor testovacích dat o hodnotu 1, aby šlo násobení s vektorem vah
    % provádìt jako skalární souèin:
    %x_out = [...];
    x_out(:,end + 1) = 1;
    %disp("Size of x_out ")
    %size(x_out)
    % x_out má nyní rozmìr N*1025

end
