<?php

$data = <<<EXCERPT
"INFINITY" = "Infinito";
"-Inf" = "-Infinito";
"Inf" = "Infinito";
"NaN" = "Non è un numero";
"Over" = "Dati in eccesso";
"Under" = "Underflow";
"DivByZero" = "Diviso zero";
"value too high" = "valore troppo alto";

"OVERFLOW" = "Dati in eccesso";
"currency" = "Valuta";

"Ellipsis" = "…";

"Advanced" = "Scientifica";
"Basic" = "Basilare";
"Hexadecimal" = "Esadecimale";
"Programmers" = "Programmatore";
"Hide Binary" = "Nascondi binario";
"Show Binary" = "Mostra binario";

"tapeSavedFileName" = "Nastro.txt";
"ShowTape" = "Mostra nastro";
"HideTape" = "Nascondi nastro";

/* for the close menu item */
"Close Calculator Window" = "Chiudi finestra Calcolatrice";
"Close Paper Tape Window" = "Chiudi finestra nastro";
"Close About Window" = "Chiudi finestra Informazioni su";
"Close" = "Chiudi";

"last updated" = "Ultimo aggiornamento: ";
"Begin Conversion" = "Inizia conversione";
"End Conversion" = "Fine conversione";
"Currency Rate update failed" = "Impossibile aggiornare i tassi di cambio.";
"Currency exchange provided by Yahoo! Finance. Actual conversion rates may vary." = "Tasso di cambio fornito da Yahoo! Finanza. Il tasso di cambio è variabile.";

"Rad" = "Rad";
"using radians input mode" = "modalità di input radianti in uso";
"Deg" = "Deg";
"using degrees input mode" = "modalità di input gradi in uso";
"RPN" = "RPN";
"enter" = "invio";

"%@ to %@" = "%@ a %@";

"Dec" = "Dec";
"Hex" = "Esa";
"Oct" = "Ott";
"ASCII" = "ASCII";
"Unicode" = "Unicode";
"IEEE Hex" = "IEEE Esa";

"M" = "M";

"ASCII value of the displayed number" = "Valore ASCII del numero visualizzato";
"Unicode value of the displayed number" = "Valore Unicode del numero visualizzato";

"Error" = "Errore";

"CLEAR_ALL_TOOLTIP" = "Cancella (Esc); Cancella tutto (Opzione-Esc)";
"CLEAR_ALL_AXHELP"  = "Cancella (premi Esc); Cancella tutto (premi Opzione-Esc)";
"CLEAR_TOOLTIP" = "Cancella (Esc)";

"PAREN_ERROR" = "Devi inserire un operatore per procedere";

/* Button titles */
"ENTER" = "invio";
"EQUALS" = "=";
"equals" = "è uguale a";
"SECOND" = "2°";
"SIN-1" = "sin-1";
"SINH-1" = "sinh-1";
"COS-1" = "cos-1";
"COSH-1" = "cosh-1";
"TAN-1" = "tan-1";
"TANH-1" = "tanh-1";
"SIN" = "sin";
"COS" = "cos";
"TAN" = "tan";
"SINH" = "sinh";
"COSH" = "cosh";
"TANH" = "tan";
"ETOX" = "ex";
"TENTOX" = "10x";
"TWOTOX" = "2x";
"LOG" = "log10";
"LOG2" = "log2";
"LN" = "ln";
"YTOX" = "yx";

"CUBED" = "x3";
"CUBED_TOOLTIP" = "Il cubo del valore visualizzato";
"CUBEROOT_TOOLTIP" = "Calcola la radice cubica del valore visualizzato.";

"SIN_TOOLTIP" = "Calcola il seno del valore visualizzato";
"COS_TOOLTIP" = "Calcola il coseno del valore visualizzato";
"TAN_TOOLTIP" = "Calcola la angente del valore visualizzato";
"H_SIN_TOOLTIP" = "Calcola il seno iperbolico del valore visualizzato";
"H_COS_TOOLTIP" = "Calcola il coseno iperbolico del valore visualizzato";
"H_TAN_TOOLTIP" = "Calcola la tangente iperbolica del valore visualizzato";
"LOG_TOOLTIP" = "Calcola il logaritmo base 10 del valore visualizzato";
"LOG2_TOOLTIP" = "Calcola il logaritmo base 2 del valore visualizzato";
"LN_TOOLTIP" = "Calcola il logaritmo naturale del valore visualizzato";
"YTOX_TOOLTIP" = "Eleva il valore visualizzato alla potenza del successivo valore inserito (o premi ^)";

"I_SIN_TOOLTIP" = "Calcola il seno inverso del valore visualizzato";
"I_COS_TOOLTIP" = "Calcola il coseno inverso del valore visualizzato";
"I_TAN_TOOLTIP" = "Calcola tangente inversa del valore visualizzato";
"I_H_SIN_TOOLTIP" = "Calcola il seno iperbolico inverso del valore visualizzato";
"I_H_COS_TOOLTIP" = "Calcola il coseno iperbolico inverso del valore visualizzato";
"I_H_TAN_TOOLTIP" = "Calcola la tangente iperbolica inversa del valore visualizzato";
"TENTOX_TOOLTIP" = "Calcola il numero 10 elevato alla potenza del valore visualizzato";
"TWOTOX_TOOLTIP" = "Calcola il numero 2 elevato alla potenza del valore visualizzato";
"ETOX_TOOLTIP" = "Calcola il numero e elevato alla potenza del valore visualizzato";
"XROOTY_TOOLTIP" = "Calcola la radice ennesima del valore visualizzato, dove n è il valore successivo inserito";
EXCERPT;

header("Content-Type: text/json");
$data = preg_replace("/((?:\/\*(?:[^*]|(?:\*+[^*\/]))*\*+\/)|(?:\/\/.*))/", '', $data);
echo count(split("\n", $data));

?>