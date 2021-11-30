% H4124

%Valeurs infinis
infinitePos(10005).
infiniteNeg(-10005).
infinitePos(X,Rep):- Rep is X+10000.
infiniteNeg(X,Rep):- Rep is -10000-X.

%Compter le nombre de 0 dans une colonne
compter([],0).
compter([0|T],N) :- compter(T,N1), N is N1 + 1.
compter([X|T],N) :- X \== 0, compter(T,N).

%Boucle forEach allant de X a Y inclus
boucleForEach(X,Y):- X>=1, X=<Y.
boucleForEach(X,Y):- Z is X+1, Z=<Y, boucleForEach(Z, Y).

%Renvoie X le maximum de la liste [X|XS]
max_liste([X],X) :- !, true.                    %Si X est le seul element de la liste et est le max
max_liste([X|Xs], M):- max_liste(Xs, M), M >= X.    %Si M est superieur ou egal a X
max_liste([X|Xs], X):- max_liste(Xs, M), X >  M.    %Si X est superieur a M

minmaxStatiqueProf(JoueurJouant,Grille,Grille1) :- MMS=[[3,4,5,5,4,3,-1],[4,6,8,8,6,4,-1],[5,8,11,11,8,5,-1],[7,10,13,13,10,7,-1],[5,8,11,11,8,5,-1],[4,6,8,8,6,4,-1],[3,4,5,5,4,3,-1]], heuristiqueMMSProf(Grille,_,MMS,Grille1,JoueurJouant, 1).

%G la grille du jeu, L la ligne MinMax jouable, MMS le tableau MinMaxStatique
heuristiqueMMSProf(G,L,MMS,G1,JoueurJouant, Profondeur) :- length(L,T), T < 7,J is T+1, %Trouve l'indice de la colone sur laquelle on travaille
                                                            ceCoupNousFaitPerdre(JoueurJouant, G, J),                                                                           %Vérifie si jouer dans cette colonne offre un coup gagnant, si c'est le cas on passe au cas suivant
                                                            invoquerMiniMax(L, JoueurJouant, J, Profondeur, L1),
                                                            heuristiqueMMSProf(G, L1, MMS, G1, JoueurJouant, Profondeur).
heuristiqueMMSProf(G,L,MMS,G1,JoueurJouant, Profondeur) :- length(L,T), T < 7,ajouterEnFin(-1,L,L1),heuristiqueMMS(G,L1,MMS,G1,JoueurJouant).                               %Ajoute -1 si le coup permet à l'adversaire de gagner
heuristiqueMMSProf(G,L,_,G1,JoueurJouant, Profondeur) :- max_liste(L,X),nth1(I,L,X),jouerMove(JoueurJouant, G, I, G1).                                                      %Joue le meilleur coup trouvé

%Evalue a false si ce coup nous fait perdre
ceCoupNousFaitPerdre(JoueurJouant, Grille, Coup):- joueurOppose(JoueurJouant,JoueurOppose),jouerMove(JoueurJouant, G, J, G2),testMovePourGagner(JoueurOppose, G2,_).

%Pour chaque coup, nous invoquons la procedure miniMax et nous mettons la valeur dans la liste
invoquerMiniMax(TableauJeu, MMS, CoupJoue, Profondeur, JoueurJouant, ScoreList, NewScoreList) :- fonctionMiniMax(TableauJeu,MMS,CoupJoue, Profondeur, JoueurJouant, JoueurJouant, 0, NewScore), ajouterEnFin(NewScore, ScoreList, NewScoreList).

% MMS est la grille d'evaluation, J le numero de la colonne jouee, G la grille du jeu,
% Score valeur de la case dans le tableau MMS sur laquelle le joueur a joue
scoreCoup(G, MMS, J, Score) :- nth1(J,G,C), compter(C,N), nth1(J,MMS,Cbis), I is 7-N, nth1(I,Cbis,Score).

%Algo minMax 
%PseudoCode : if depth = 0 or node is a terminal node then
%               return the heuristic value of node
fonctionMiniMax(TableauJeu,MMS,CoupJoue, 0, JoueurJouant,JoueurMAX, Score,_):- write(0), scoreCoup(TableauJeu,MMS,CoupJoue,Score).
fonctionMiniMax(TableauJeu,MMS,CoupJoue, Profondeur, JoueurJouant,JoueurMAX, Score,_):- write(Profondeur), Profondeur\=0, nth1(CoupJoue, TableauJeu, Colonne), compter(Colonne,1), scoreCoup(TableauJeu,MMS,CoupJoue,Score).

%PseudoCode : if maximizingPlayer then
%               value := −∞
%               for each child of node do
%                 value := max(value, minimax(child, depth − 1, FALSE))
%                 return value 
    
fonctionMiniMax(TableauJeu,MMS,CoupJoue, Profondeur, JoueurJouant,JoueurMAX, Score,NewScore):- write(Profondeur), JoueurJouant==JoueurMAX, infiniteNeg(CoupJoue,Score),
                                                                                            boucleForEach(1,7),
                                                                                            NewScore is max(Score,
                                                                                            joueurOppose(JoueurJouant, AutreJoueur),
                                                                                            fonctionMiniMax(TableauJeu,MMS,coupJoue, profondeur-1, AutreJoueur,JoueurMAX, Score, NewScore)).



%PseudoCode : else (* minimizing player *) value := +∞
%             for each child of node do
%                   value := min(value, minimax(child, depth − 1, TRUE))
%                   return value
fonctionMiniMax(TableauJeu,MMS,CoupJoue, Profondeur, JoueurJouant,JoueurMAX, Score,NewScore):- write(Profondeur),JoueurJouant \= JoueurMAX, infinitePos(CoupJoue,Score),
                                                                                            boucleForEach(1,7),
                                                                                            NewScore is min(Score,
                                                                                            joueurOppose(JoueurJouant, AutreJoueur),
                                                                                            fonctionMiniMax(TableauJeu,MMS,coupJoue, profondeur-1, AutreJoueur,JoueurMAX, Score, NewScore)).

