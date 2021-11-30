% H4124
% genereGrille(Grille):- Grille = [[0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]].
%Valeurs infinis
infinitePos(10005).
infiniteNeg(-10005).
infinitePos(X,Rep):- Rep is X+10000.
infiniteNeg(X,Rep):- Rep is -10000-X.

%Boucle forEach allant de X a Y inclus
boucleForEach(X,Y):- X>=1, X=<Y.
boucleForEach(X,Y):- Z is X+1, Z=<Y, boucleForEach(Z, Y).

minmaxStatiqueProf(JoueurJouant,Grille,Grille1) :- MMS=[[3,4,5,5,4,3,-1],[4,6,8,8,6,4,-1],[5,8,11,11,8,5,-1],[7,10,13,13,10,7,-1],[5,8,11,11,8,5,-1],[4,6,8,8,6,4,-1],[3,4,5,5,4,3,-1]], heuristiqueMMSProf(Grille,_,MMS,Grille1,JoueurJouant, 1).

%G la grille du jeu, L la ligne MinMax jouable, MMS le tableau MinMaxStatique
heuristiqueMMSProf(G,L,MMS,G1,JoueurJouant, Profondeur) :- length(L,T), T < 7,J is T+1, %Trouve l'indice de la colone sur laquelle on travaille
                                                            ceCoupNousFaitPerdre(JoueurJouant, G, J),                                                                           %Vérifie si jouer dans cette colonne offre un coup gagnant, si c'est le cas on passe au cas suivant
                                                            invoquerMiniMax(G, MMS, J, Profondeur, JoueurJouant, L, L1),
                                                            heuristiqueMMSProf(G, L1, MMS, G1, JoueurJouant, Profondeur).
heuristiqueMMSProf(G,L,MMS,G1,JoueurJouant, Profondeur) :- length(L,T), T < 7,ajouterEnFin(-1,L,L1),heuristiqueMMSProf(G,L1,MMS,G1,JoueurJouant, Profondeur).                               %Ajoute -1 si le coup permet à l'adversaire de gagner
heuristiqueMMSProf(G,L,_,G1,JoueurJouant, _) :- max_liste(L,X),nth1(I,L,X),jouerMove(JoueurJouant, G, I, G1).                                                      %Joue le meilleur coup trouvé

%Evalue a false si ce coup nous fait perdre
ceCoupNousFaitPerdre(JoueurJouant, Grille, Coup):- joueurOppose(JoueurJouant,JoueurOppose),jouerMove(JoueurJouant, Grille, Coup, G2),testMovePourGagner(JoueurOppose, G2,_).

%Pour chaque coup, nous invoquons la procedure miniMax et nous mettons la valeur dans la liste
invoquerMiniMax(TableauJeu, MMS, CoupJoue, Profondeur, JoueurJouant, ScoreList, NewScoreList) :- fonctionMiniMax(TableauJeu,MMS,CoupJoue, Profondeur, JoueurJouant, JoueurJouant, 0, NewScore), ajouterEnFin(NewScore, ScoreList, NewScoreList).

% MMS est la grille d'evaluation, J le numero de la colonne jouee, G la grille du jeu,
% Score valeur de la case dans le tableau MMS sur laquelle le joueur a joue
scoreCoup(G, MMS, J, Score) :- nth1(J,G,C), compter(C,N), nth1(J,MMS,Cbis), I is 7-N, nth1(I,Cbis,Score).

%Algo minMax 
%PseudoCode : if depth = 0 or node is a terminal node then
%               return the heuristic value of node
fonctionMiniMax(TableauJeu,MMS,CoupJoue, 0, _, _, _, NewScore):- write("prof0"), scoreCoup(TableauJeu,MMS,CoupJoue,NewScore).
fonctionMiniMax(TableauJeu,MMS,CoupJoue, Profondeur, _, _, _, NewScore):- Profondeur\=0, nth1(CoupJoue, TableauJeu, Colonne), write("avant"), compter(Colonne,1), write("apres"), scoreCoup(TableauJeu,MMS,CoupJoue,NewScore).

%PseudoCode : if maximizingPlayer then
%               value := −∞
%               for each child of node do
%                 value := max(value, minimax(child, depth − 1, FALSE))
%                 return value 
    
fonctionMiniMax(TableauJeu,MMS,CoupJoue, Profondeur, JoueurJouant,JoueurMAX, Score,NewScore):- JoueurJouant==JoueurMAX, write("max"), infiniteNeg(CoupJoue,NewScore), 
                                                                                            boucleForEach(1,7),
    																						joueurOppose(JoueurJouant, AutreJoueur),
                                                                                            NewProfondeur is Profondeur - 1,
                                                                                            NewProfondeur >= 0,
                                                                                            write(NewProfondeur),
    																						fonctionMiniMax(TableauJeu,MMS,CoupJoue, NewProfondeur, AutreJoueur,JoueurMAX, NewScore, OtherScore),
                                                                                            NewScore is max(Score, OtherScore),write(" tourSuivant").



%PseudoCode : else (* minimizing player *) value := +∞
%             for each child of node do
%                   value := min(value, minimax(child, depth − 1, TRUE))
%                   return value
fonctionMiniMax(TableauJeu,MMS,CoupJoue, Profondeur, JoueurJouant,JoueurMAX, Score,NewScore):- JoueurJouant\=JoueurMAX, write("min"), infinitePos(CoupJoue,NewScore),
                                                                                            boucleForEach(1,7),
    																						joueurOppose(JoueurJouant, AutreJoueur),
                                                                                            NewProfondeur is Profondeur - 1,
                                                                                            NewProfondeur >= 0,
    																						fonctionMiniMax(TableauJeu,MMS,CoupJoue, NewProfondeur, AutreJoueur,JoueurMAX, Score, OtherScore),
                                                                                            NewScore is min(Score, OtherScore).

