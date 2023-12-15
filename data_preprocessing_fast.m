function x_out = data_preprocessing_fast(x_in,x_tren_in)
    % x_in...vstupn� testovaci data data, rozm�r: 1000x32x32 = Ntest x 32 x 32
    % x_tren_in...vstupn� trenovac� data, rozm�r: 9000x32x32 = Ntren x 32 x 32
    % x_out...v�stupn� testovac� data

     % ========================== V�� K�D ZDE ======================
    % Nejprve st�edn� hodnota jednotliv�ch pixel� tr�novac�ch obr�zk� pomoc� p��kazu mean:
    norm_factor = mean(x_tren_in,1);    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Proveden� normalizace bez cyklu %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Normalizaci x_in ode�ten�m vypo�ten�ch 32 st�edn�ch hodnot lze zapsat i bez pou�it� cyklu for jako maticovou operaci pomoc� p��kazu
    % REPMAT s parametrem N:
    N = size(x_in,1);
    % ========================== V�� K�D ZDE ======================
    x_out = x_in - repmat(norm_factor,N,1);
    % Kontrola: x_out(10,10,10) = 4.83
    % =============================================================    
    
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % RESHAPE matice efektivn? %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Matici x_out o rozm?rech Nx32x32 d�le p?evedeme na matici o rozm?rech Nx1024 p?�kazem RESHAPE.
    % Ten v Matlabu ov�em funguje po sloupc�ch, kde�to v tr�novac�m software obdoba p?�kazu reshape
    % zpracov�vala b?hem tr�nov�n� matice po ?�dc�ch, jako cykly for v p?edchoz� implementaci => p?ed pou�it�m p?�kazu RESHAPE je t?eba prohodit
    % sloupce a ?�dky obr�zk? p?�kazem PERMUTE:
    % ========================== V�� K�D ZDE ======================
    x_out = permute(x_out, [1,3,2]);
    % Nyn� je mo�n� pou��t RESHAPE a v�sledek bude stejn�, jako v tr�novac�m
    % software (numpy+python) a jako byl p?i pou�it� vno?en�ch cykl?:    
    x_out = reshape(x_out,N,[],1);
    % Kontrola: x_out(666,666) = 0.3272
    % =============================================================  
    % Pokud bychom PERMUTE neprovedli, nau?en� v�hy by se aplikovaly na
    % p?ehozen� vstupn� hodnoty a p?esnost rozpozn�v�n� by byla 12.4%, tedy p?ibli�n? 1/C = 1/10!!!
    
    % Zb�v� jen doplnit ka�d� vektor testovac�ch dat o hodnotu 1, aby �lo n�soben� s vektorem vah    
    % prov�d?t jako skal�rn� sou?in:
    %x_out = [...];
    x_out(:,end + 1) = 1;
    % x_out m� nyn� rozm?r N*1025 !!!! 

   
   
end
