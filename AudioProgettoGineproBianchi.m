%Definizione delle variabili
L = 480;
Sout = L/2;
alpha = 2; %valore da modificare
Sin = round(Sout * alpha);
delta_k=20;

[input_signal, Fs] = audioread('speech.wav');
in_length = length(input_signal);

output_signal = zeros(round( in_length/alpha + L) , 1 );

win=hamming(L);

%vettore che salva i valori mediani risultati dalle correlazioni
xcorr_median_values = zeros(delta_k-1,1);

%setto il primo frame dell'output
pin_scaled=0;
pout=0;
output_signal(pout+1:pout+L)= input_signal(pin_scaled+1:pin_scaled+L);
pin_scaled=pin_scaled+Sin;
pout=pout+Sout;
pprec=0;

%indice per il loop delle correlazioni
l=1;



if (alpha<1)
    while((pin_scaled+L+(delta_k/2))<(in_length))
        %per ogni frame che soddisfa il ciclo while calcolo la correlazione tra il
        %frame precedente e i frame nell'intorno delta_k
        while(l<=delta_k)
            %frame scalato
            x=input_signal(pin_scaled+l+1:pin_scaled+l+L);
            %frame precedente
            y=input_signal(pprec+1:pprec+L);
            %faccio la correlazione 
            [xcorr_vals, lags]= xcorr(x,y);
            %prendo il valore mediano
            index_median=(length(lags)-1)/2;
          %scelgo il massimo dei mediani
            xcorr_median_values(l)=xcorr_vals(index_median);
            l=l+1;
        end;
        %trovo l'indece e il valore del massimo
        [val_max,index_max]= max(xcorr_median_values);
        %uso l'indice per prendere il frame con la correlazione maggiore e
        %metterlo nel file di output
        a=input_signal(pin_scaled+1-(delta_k/2)+index_max:pin_scaled-(delta_k/2)+index_max+L);
        a=a.*win;
        output_signal(pout+1:pout+L)=output_signal(pout+1:pout+L)+a;
        %aggiorno il frame
        pout=pout+Sout;
        pprec=pin_scaled;

        pin_scaled=pin_scaled+Sin;

        l=1;
    end;
else
    
    while((pin_scaled+L+(delta_k/2))<(in_length)&& pout+L<in_length)
        %per ogni frame preso in considerazione calcolo la correlazione tra il
        %frame senza scaling e i frame nell'intorno delta_k
        while(l<=delta_k)
            %frame scalato
            x=input_signal(pin_scaled+l+1-(delta_k/2):pin_scaled+l+L-(delta_k/2));
            %frame seguente
            y=input_signal(pout+1:pout+L);
            %faccio la correlazione 
            [xcorr_vals, lags]= xcorr(x,y);
            %voglio tenere solo il valore della correlazione quando i due frame
            %sono perfettamente sovrapposti quindi prendo il valore mediano
            index_median=(length(lags)-1)/2;
            %il valore mediano lo metto in un vettore tra cui dovrò scegliere
            %il massimo
            xcorr_median_values(l)=xcorr_vals(index_median);
            l=l+1;
        end;
        %trovo l'indece e il valore del massimo
        [val_max,index_max]= max(xcorr_median_values);
        %uso l'indice per prendere il frame con la correlazione maggiore e
        %metterlo nel file di output
        a=input_signal(pin_scaled+1-(delta_k/2)+index_max:pin_scaled-(delta_k/2)+index_max+L);
        a=a.*win;
        output_signal(pout+1:pout+L)=output_signal(pout+1:pout+L)+a;
        %aggiorno il frame
        pout=pout+Sout;

        pin_scaled=pin_scaled+Sin;

        l=1;
    end;
end

%sound(input_signal,Fs);

sound(output_signal,Fs);
filename='track.wav';
audiowrite(filename, output_signal, Fs);