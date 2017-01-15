# AudioProgetto
Installazione:
Aprire il file Matlab “Codice.m”.
Importare su Matlab tutti i file nella stessa cartella di lavoro.

Per avviare l’applicazione:
Le prime righe del codice di progettoAudio.m descrivono i valori di input utilizzati dall’algoritmo; in particolare il valore “sFactor” rappresenta il valore di time-scalina con cui si desidera modificare la traccia audio: settando questo valore a piacere e facendo partire in run l’applicativo si nota infatti si nota un rallentamento o un’accelerazione del file .wav a seconda del valore scelto per sFactor (per come è costruito l’algoritmo per valori di sFactor<1 la traccia audio verrà rallentata; per valori di sFactor>1 la traccia audio verrà accelerata).


Descrizione:
Speech time-scaling: allungare o accorciare la durata di un file audio senza alterare l’altezza (pitch) del suono, in funzione di un time-scaling-factor compreso tra 0.5 (dimezza la durata) e 2 (raddoppia la durata) 
Una volta caricato un file audio, vengono dichiarate le variabili L, Sout, Sfactor e delta.
Viene settato il primo frame dell’output.
Viene avviato il ciclo while per far partire l’algoritmo.
L’algoritmo salva per prima cosa i valori mediani delle correlazioni dei segnali in un vettore.
Viene impostato un indice per il loop delle correlazioni.
Finché il frame in analisi non oltrepassa la lunghezza del segnale in ingresso, per ogni frame preso in considerazione l’algoritmo calcola la correlazione tra il frame senza scaling e i frame nell’intorno delta_k adiacenti.
Vengono fatte 40 correlazioni e tra queste viene preso solo il valore mediano.
Si ottengono in questo modo 40 valori mediani e tra questi viene scelto il maggiore.
Si considera ora l'indice del mediano maggiore e si riconosce il frame d’interesse, quello con la correlazione maggiore.

Il valore della correlazione viene salvato solo quando i due frame sono perfettamente sovrapposti, quindi quando il valore mediano è esattamente uguale a:
—————> (length(lag)-1)/2.
Questo valore viene inserito in un vettore; tra i valori salvati nel vettore viene scelto il valore massimo.
Il nuovo file audio in output viene infine salvato e riprodotto.
