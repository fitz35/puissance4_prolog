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
heuristiqueMMSProf(G,L,MMS,G1,JoueurJouant, Profondeur) :- length(L,T), T < 7,J is T+1, %Trouve l'indice de la colone sur laquelle on travaille, on commence a 0 ou 1? on s'arrete a 6 ou 7?
                                                            ceCoupNousFaitPerdre(JoueurJouant, G, J),                                                                           %Vérifie si jouer dans cette colonne offre un coup gagnant, si c'est le cas on passe au cas suivant
                                                            invoquerMiniMax(G, MMS, J, Profondeur, JoueurJouant, L, L1),
                                                            heuristiqueMMSProf(G, L1, MMS, G1, JoueurJouant, Profondeur).
heuristiqueMMSProf(G,L,MMS,G1,JoueurJouant, Profondeur) :- length(L,T), T < 7,ajouterEnFin(-1,L,L1),heuristiqueMMSProf(G,L1,MMS,G1,JoueurJouant, Profondeur).                               %Ajoute -1 si le coup permet à l'adversaire de gagner
heuristiqueMMSProf(G,L,_,G1,JoueurJouant, _) :- max_liste(L,X),nth1(I,L,X),jouerMove(JoueurJouant, G, I, G1).                                                      %Joue le meilleur coup trouvé

%Evalue a false si ce coup nous fait perdre
ceCoupNousFaitPerdre(JoueurJouant, Grille, Coup):- joueurOppose(JoueurJouant,JoueurOppose),jouerMove(JoueurJouant, Grille, Coup, G2),testMovePourGagner(JoueurOppose, G2,_).

%Pour chaque coup, nous invoquons la procedure miniMax et nous mettons la valeur dans la liste
invoquerMiniMax(TableauJeu, MMS, CoupJoue, Profondeur, JoueurJouant, ScoreList, NewScoreList) :- jouerMove(JoueurJouant, TableauJeu, CoupJoue, PrevisionTableauJeu),
                                                                                                 joueurOppose(JoueurJouant, AutreJoueur),
                                                                                                 fonctionMiniMax(PrevisionTableauJeu, MMS, 0, Profondeur, AutreJoueur, JoueurJouant, NewScore), 
                                                                                                 ajouterEnFin(NewScore, ScoreList, NewScoreList).

% MMS est la grille d'evaluation, J le numero de la colonne jouee, G la grille du jeu,
% Score valeur de la case dans le tableau MMS sur laquelle le joueur a joue
scoreCoup(G, MMS, J, Score) :- nth1(J,G,C), compter(C,N), nth1(J,MMS,Cbis), I is 7-N, nth1(I,Cbis,Score).


%Base cases
%Algo minMax 
%PseudoCode : if depth = 0 or node is a terminal node then
%               return the heuristic value of node
fonctionMiniMax(TableauJeu, MMS,CoupJoue, 0         , _       , _        , BestNodeValue):- NewCoupJoue is CoupJoue + 1, scoreCoup(TableauJeu,MMS,NewCoupJoue,NodeScore), BestNodeValue is NodeScore, 
                                                                                            write(" coupure Profondeur, leaf score =  "), write(NodeScore), write("\n").
fonctionMiniMax(TableauJeu, MMS,CoupJoue, Profondeur, _       , _        , BestNodeValue):- NewCoupJoue is CoupJoue + 1, Profondeur\=0, nth1(NewCoupJoue, TableauJeu, Colonne), compter(Colonne,1), scoreCoup(TableauJeu,MMS,CoupJoue,NodeScore), BestNodeValue is NodeScore,  
                                                                                            write(" coupure No Child leaf score = "), write(NodeScore), write("\n").
%Coupure no right node pour une profondeur max
fonctionMiniMax(TableauJeu, MMS,6      , Profondeur, JoueurJouant, JoueurMAX, BestNodeValue):- Profondeur>0,
                                                                                            NewCoupJoue is 7,
                                                                                            joueurOppose(JoueurJouant, AutreJoueur),
                                                                                            NewProfondeur is Profondeur - 1,
                                                                                            jouerMove(JoueurMAX, TableauJeu, NewCoupJoue, PrevisionTableauJeu),
                                                                                            write(" Profondeur : "), write(NewProfondeur), write(" Coup Joue : "), write(7), write("\n"),
                                                                                            fonctionMiniMax(PrevisionTableauJeu, MMS, 0, NewProfondeur, AutreJoueur, JoueurMAX, ThisNodeValue), %Recursion en  profondeur
                                                                                            BestNodeValue is ThisNodeValue,
                                                                                            write(" Best max node value for  node prof = "), write(Profondeur), write("   coup = "), write(7), write(" is score = "), write(BestNodeValue), write("\n"),
                                                                                            write(" coupure no right node \n").

%PseudoCode : if maximizingPlayer then
%               value := −∞
%               for each child of node do
%                 value := max(value, minimax(child, depth − 1, FALSE))
%                 return value 
fonctionMiniMax(TableauJeu, MMS, CoupJoue, Profondeur, JoueurMAX   , JoueurMAX, BestNodeValue):- Profondeur>0,
                                                                                        NewCoupJoue is CoupJoue + 1, NewCoupJoue < 7, % Effet de bord possible, on commence a 1 ou 2?, Changer newCoup joue < 8?
                                                                                        joueurOppose(JoueurMAX, AutreJoueur),
                                                                                        NewProfondeur is Profondeur - 1,
                                                                                        jouerMove(JoueurMAX, TableauJeu, NewCoupJoue, PrevisionTableauJeu),
                                                                                        write(" Profondeur : "), write(NewProfondeur), write(" Coup Joue : "), write(NewCoupJoue), write("\n"),
                                                                                        fonctionMiniMax(PrevisionTableauJeu, MMS, 0, NewProfondeur, AutreJoueur, JoueurMAX, ThisNodeValue), %Recursion en  profondeur
                                                                                        write(" Profondeur : "), write(NewProfondeur), write(" Coup Joue : "), write(NewCoupJoue), write("\n"),
                                                                                        fonctionMiniMax(TableauJeu, MMS, NewCoupJoue, Profondeur, JoueurMAX, JoueurMAX, RigthNodeValue), %Recursion en largeur
                                                                                        BestNodeValue is max(ThisNodeValue, RigthNodeValue),
                                                                                        write(" Best max node value for  node prof = "), write(Profondeur), write("   coup = "), write(NewCoupJoue), write(" is score = "), write(BestNodeValue), write("\n").

%PseudoCode : else (* minimizing player *) value := +∞
%             for each child of node do
%                   value := min(value, minimax(child, depth − 1, TRUE))
%                   return value
fonctionMiniMax(TableauJeu, MMS ,CoupJoue, Profondeur, JoueurJouant, JoueurMAX, BestNodeValue):- Profondeur>0, JoueurJouant =\= JoueurMAX,
                                                                                        NewCoupJoue is CoupJoue + 1, NewCoupJoue < 7, % Effet de bord possible, on commence a 1 ou 2?
                                                                                        joueurOppose(JoueurJouant, AutreJoueur),
                                                                                        NewProfondeur is Profondeur - 1,
                                                                                        jouerMove(JoueurJouant, TableauJeu, NewCoupJoue, PrevisionTableauJeu),
                                                                                        write(" Profondeur : "), write(NewProfondeur), write(" Coup Joue : "), write(NewCoupJoue), write("\n"),
                                                                                        fonctionMiniMax(PrevisionTableauJeu, MMS, 0, NewProfondeur, AutreJoueur, JoueurMAX, ThisNodeValue), %Recursion en  profondeur
                                                                                        write(" Profondeur : "), write(NewProfondeur), write(" Coup Joue : "), write(NewCoupJoue), write("\n"),
                                                                                        fonctionMiniMax(TableauJeu, MMS, NewCoupJoue, Profondeur, JoueurJouant, JoueurMAX, RigthNodeValue), %Recursion en largeur
                                                                                        BestNodeValue is min(ThisNodeValue, RigthNodeValue),
                                                                                        write(" Best min node value for  node prof = "), write(Profondeur), write("   coup = "), write(NewCoupJoue), write(" is score = "), write(BestNodeValue), write("\n").
