% H4124
% genereGrille(Grille):- Grille = [[0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]].
%Valeurs infinis
infinitePos(10005).
infiniteNeg(-10005).
infinitePos(X,Rep):- Rep is X+10000.
infiniteNeg(X,Rep):- Rep is -10000-X.

%Evalue si le coup joue ramene a une configuration legale
configurationLegale(TableauJeu, CoupJoue) :- nth1(CoupJoue, TableauJeu, Colonne), compter(Colonne,N), N>0.

minmaxStatiqueProfPlus(JoueurJouant,Grille,Grille1) :- MMS=[[3,4,5,5,4,3,-1],[4,6,8,8,6,4,-1],[5,8,11,11,8,5,-1],[7,10,13,13,10,7,-1],[5,8,11,11,8,5,-1],[4,6,8,8,6,4,-1],[3,4,5,5,4,3,-1]], heuristiqueMMSProf(Grille,_,MMS,Grille1,JoueurJouant, 2).

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
%scoreCoup(G, MMS, J, Score) :- nth1(J,G,C), compter(C,N), nth1(J,MMS,Cbis), I is 7-N, nth1(I,Cbis,Score).

calculConfig(G, MMS, JoueurMAX, Score, NewScore, C, L) :- L<6, C<8, L2 is L+1, nth1(C,G,Colonne), nth1(L2,Colonne,Case), 
                                                Case == 0, calculConfig(G, MMS, JoueurMAX, Score, NewScore, C, L2).
calculConfig(G, MMS, JoueurMAX, Score, NewScore, C, L) :- L<6, C<8, L2 is L+1, nth1(C,G,Colonne), nth1(L2,Colonne,Case), 
                                                Case == JoueurMAX, nth1(C,MMS,Colonne2), nth1(L2,Colonne2,Value),
                                                ScoreBis is Score + Value, calculConfig(G, MMS, JoueurMAX, ScoreBis, NewScore, C, L2). 
calculConfig(G, MMS, JoueurMAX, Score, NewScore, C, L) :- L<6, C<8, L2 is L+1, nth1(C,G,Colonne), nth1(L2,Colonne,Case), 
                                                Case =\= JoueurMAX, Case =\= 0, nth1(C,MMS,Colonne2), nth1(L2,Colonne2,Value),
                                                ScoreBis is Score - Value, calculConfig(G, MMS, JoueurMAX, ScoreBis, NewScore, C, L2).
calculConfig(G, MMS, JoueurMAX, Score, NewScore, C, 6) :- C<7, C2 is C+1, L2 is 0, calculConfig(G, MMS, JoueurMAX, Score, NewScore, C2, L2).
calculConfig(G, _, _, Score, NewScore, 7, 6) :- L2 is 5+1, C2 is 6+1, nth1(C2,G,Colonne), nth1(L2,Colonne,Case), 
                                                Case == 0, NewScore is Score. 
calculConfig(G, MMS, JoueurMAX, Score, NewScore, 7, 6) :- L2 is 5+1, C2 is 6+1, nth1(C2,G,Colonne), nth1(L2,Colonne,Case), 
                                                Case == JoueurMAX, nth1(C2,MMS,Colonne2), nth1(L2,Colonne2,Value),
                                                NewScore is Score + Value. 
calculConfig(G, MMS, JoueurMAX, Score, NewScore, 7, 6) :- L2 is 5+1, C2 is 6+1, nth1(C2,G,Colonne), nth1(L2,Colonne,Case), 
                                                Case =\= JoueurMAX, Case =\= 0, nth1(C2,MMS,Colonne2), nth1(L2,Colonne2,Value),
                                                NewScore is Score - Value.
scoreCoup(G, MMS, J, JoueurMAX, Score, NewScore) :- nth1(J,G,Col), compter(Col,N), nth1(J,MMS,Colbis), I is 7-N, nth1(I,Colbis,Score),
    									        calculConfig(G, MMS, JoueurMAX, Score, NewScore, 1, 0). 

%Base cases
%Coupure no child node
fonctionMiniMax(TableauJeu, MMS,CoupJoue, Profondeur, JoueurJouant, JoueurMAX, BestNodeValue):- NewCoupJoue is CoupJoue + 1, NewCoupJoue < 7,
                                                                                                not(configurationLegale(TableauJeu, NewCoupJoue)),
                                                                                                fonctionMiniMax(TableauJeu, MMS, NewCoupJoue, Profondeur, JoueurJouant, JoueurMAX, RigthNodeValue), %Recursion en largeur
                                                                                                BestNodeValue is RigthNodeValue.                                                                           
%Coupure no child node and no right node in a max level
fonctionMiniMax(TableauJeu, _,6 , _, JoueurMAX, JoueurMAX, BestNodeValue):- NewCoupJoue is 7, not(configurationLegale(TableauJeu, NewCoupJoue)),
                                                                                            BestNodeValue is -100.
%Coupure no child node and no right node in a min level
fonctionMiniMax(TableauJeu, _,6 , _, JoueurJouant, JoueurMAX, BestNodeValue):- JoueurJouant =\= JoueurMAX, NewCoupJoue is 7, not(configurationLegale(TableauJeu, NewCoupJoue)),
                                                                                            BestNodeValue is 100.

%Coupure max profondeur in a max level
fonctionMiniMax(TableauJeu, MMS, CoupJoue, 0          , JoueurMAX, JoueurMAX, BestNodeValue):- NewCoupJoue is CoupJoue + 1, NewCoupJoue < 7,
                                                                                            configurationLegale(TableauJeu, NewCoupJoue),
                                                                                            scoreCoup(TableauJeu, MMS, JoueurMAX, NewCoupJoue, _, ThisNodeValue),
                                                                                            fonctionMiniMax(TableauJeu, MMS, NewCoupJoue, 0, JoueurMAX, JoueurMAX, RigthNodeValue), %Recursion en largeur
                                                                                            %
                                                                                            BestNodeValue is max(ThisNodeValue, RigthNodeValue).
%Coupure max profondeur in a min level
fonctionMiniMax(TableauJeu, MMS, CoupJoue, 0          , JoueurJouant, JoueurMAX, BestNodeValue):- JoueurJouant =\= JoueurMAX,
                                                                                            NewCoupJoue is CoupJoue + 1, NewCoupJoue < 7,
                                                                                            configurationLegale(TableauJeu, NewCoupJoue),
                                                                                            scoreCoup(TableauJeu, MMS, JoueurMAX, NewCoupJoue, _, ThisNodeValue),
                                                                                            fonctionMiniMax(TableauJeu, MMS, NewCoupJoue, 0, JoueurJouant, JoueurMAX, RigthNodeValue), %Recursion en largeur
                                                                                            %
                                                                                            BestNodeValue is min(ThisNodeValue, RigthNodeValue).

%Coupure max profondeur in and no Right Node
fonctionMiniMax(TableauJeu, MMS, 6      , 0         , _           ,  JoueurMAX, BestNodeValue):- configurationLegale(TableauJeu, 7),
                                                                                            scoreCoup(TableauJeu, MMS, JoueurMAX, 7, _, ThisNodeValue),
                                                                                            BestNodeValue is ThisNodeValue.

%Coupure no right node
fonctionMiniMax(TableauJeu, MMS, 6      , Profondeur, JoueurJouant, JoueurMAX, BestNodeValue):- Profondeur>0, NewCoupJoue is 7,
                                                                                            joueurOppose(JoueurJouant, AutreJoueur),
                                                                                            NewProfondeur is Profondeur - 1, configurationLegale(TableauJeu, NewCoupJoue),
                                                                                            jouerMove(JoueurMAX, TableauJeu, NewCoupJoue, PrevisionTableauJeu),
                                                                                            fonctionMiniMax(PrevisionTableauJeu, MMS, 0, NewProfondeur, AutreJoueur, JoueurMAX, ThisNodeValue), %Recursion en  profondeur
                                                                                            BestNodeValue is ThisNodeValue.

%PseudoCode : if maximizingPlayer then
%               value := −∞
%               for each child of node do
%                 value := max(value, minimax(child, depth − 1, FALSE))
%                 return value 
fonctionMiniMax(TableauJeu, MMS, CoupJoue, Profondeur, JoueurMAX   , JoueurMAX, BestNodeValue):- Profondeur>0,
                                                                                        NewCoupJoue is CoupJoue + 1, NewCoupJoue < 7, % Effet de bord possible, on commence a 1 ou 2?, Changer newCoup joue < 8?
                                                                                        joueurOppose(JoueurMAX, AutreJoueur),
                                                                                        NewProfondeur is Profondeur - 1, configurationLegale(TableauJeu, NewCoupJoue),
                                                                                        jouerMove(JoueurMAX, TableauJeu, NewCoupJoue, PrevisionTableauJeu),
                                                                                        fonctionMiniMax(PrevisionTableauJeu, MMS, 0, NewProfondeur, AutreJoueur, JoueurMAX, ThisNodeValue), %Recursion en  profondeur
                                                                                        fonctionMiniMax(TableauJeu, MMS, NewCoupJoue, Profondeur, JoueurMAX, JoueurMAX, RigthNodeValue), %Recursion en largeur
                                                                                        %+
                                                                                        BestNodeValue is max(ThisNodeValue, RigthNodeValue).

%PseudoCode : else (* minimizing player *) value := +∞
%             for each child of node do
%                   value := min(value, minimax(child, depth − 1, TRUE))
%                   return value
fonctionMiniMax(TableauJeu, MMS ,CoupJoue, Profondeur, JoueurJouant, JoueurMAX, BestNodeValue):- Profondeur>0, JoueurJouant =\= JoueurMAX,
                                                                                        NewCoupJoue is CoupJoue + 1, NewCoupJoue < 7, % Effet de bord possible, on commence a 1 ou 2?
                                                                                        joueurOppose(JoueurJouant, AutreJoueur),
                                                                                        NewProfondeur is Profondeur - 1, configurationLegale(TableauJeu, NewCoupJoue),
                                                                                        jouerMove(JoueurJouant, TableauJeu, NewCoupJoue, PrevisionTableauJeu),
                                                                                        fonctionMiniMax(PrevisionTableauJeu, MMS, 0, NewProfondeur, AutreJoueur, JoueurMAX, ThisNodeValue), %Recursion en  profondeur
                                                                                        fonctionMiniMax(TableauJeu, MMS, NewCoupJoue, Profondeur, JoueurJouant, JoueurMAX, RigthNodeValue), %Recursion en largeur
                                                                                        %-
                                                                                        BestNodeValue is min(ThisNodeValue, RigthNodeValue).