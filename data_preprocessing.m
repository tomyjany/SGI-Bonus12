function x_out = data_preprocessing(x_in,x_tren_in)
    % x_in...vstupn� testovaci data data, rozm�r: 1000x32x32 = Ntest x 32 x 32
    % x_tren_in...vstupn� trenovac� data, rozm�r: 9000x32x32 = Ntren x 32 x 32
    % x_out...v�stupn� testovac� data

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Proveden� normalizace pomoc� cyklu %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Nejprve st�edn� hodnota jednotliv�ch pixel� tr�novac�ch obr�zk� pomoc� p��kazu
    % mean:
    norm_factor = mean(x_tren_in,1);
    % Pot� normalizace jednotliv�ch obr�zk� ode�ten�m vypo�ten�ch 32 st�edn�ch
    % hodnot:
    % Cyklus pro v�echna testovac� data:
    % ========================== V�� K�D ZDE ======================
    N = size(x_in,1);
    for i=1:N  
        x_out_tmp(i,:,:) = x_in(i,:,:) - norm_factor;
    end
    %disp("kontrola normalizace mela by byt (4.83)");
    %x_out_tmp(10,10,10)
    % Kontrola: x_out_tmp(10,10,10) = 4.83
    % =============================================================
        
    % Matici x_out_tmp o rozm�rech Nx32x32 d�le p�evedeme na matici o rozm�rech
    % Nx1024, p�i�em� budeme postupovat po ��dc�ch a pak po sloupc�ch:

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % RESHAPE matice pomoc� cyklu %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:N  
        %Nejprve ��dek
        index = 1;
        % ========================== V�� K�D ZDE ======================
        for a=1:32
            %Pot� sloupec
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

    % Zb�v� jen doplnit ka�d� vektor testovac�ch dat o hodnotu 1, aby �lo n�soben� s vektorem vah
    % prov�d�t jako skal�rn� sou�in:
    %x_out = [...];
    x_out(:,end + 1) = 1;
    %disp("Size of x_out ")
    %size(x_out)
    % x_out m� nyn� rozm�r N*1025

end
