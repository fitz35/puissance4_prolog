% Heuristique 7 : min-max,
%                 s'il existe joue coup gagnant,
%                 sinon si l'adversaire à un coup gagnant, bloque le,
%                 sinon, en s'appuyant sur un tableau qui indique un score pour chaque coup, joue le coup avec le meilleur score

%:- consult(minMax).

:- dynamic tableau/2.
tableau([[3,4,5,5,4,3],[4,6,8,8,6,4],[5,8,11,11,8,5],[7,10,13,13,10,7],[5,8,11,11,8,5],[4,6,8,8,6,4],[3,4,5,5,4,3]],1).
tableau([[3,4,5,5,4,3],[4,6,8,8,6,4],[5,8,11,11,8,5],[7,10,13,13,10,7],[5,8,11,11,8,5],[4,6,8,8,6,4],[3,4,5,5,4,3]],2).

r :- retractall(tableau(_,_)) , 
        asserta(tableau([[3,4,5,5,4,3],[4,6,8,8,6,4],[5,8,11,11,8,5],[7,10,13,13,10,7],[5,8,11,11,8,5],[4,6,8,8,6,4],[3,4,5,5,4,3]],1)),
        asserta(tableau([[3,4,5,5,4,3],[4,6,8,8,6,4],[5,8,11,11,8,5],[7,10,13,13,10,7],[5,8,11,11,8,5],[4,6,8,8,6,4],[3,4,5,5,4,3]],2)).

% Heuristique minMax // fait jouer le coup trouvé 
minMaxDynamique(Grille,J,G1) :-  mettreAJourTableau(Grille,J),  tableau(X,J), trouveCoupMinMax(Grille, X, NumColonneAJouer), jouerMove(J,Grille,NumColonneAJouer,G1).

%[[1,2,1,0,0,0],[2,1,0,0,0,0],[1,2,1,0,0,0],[1,2,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[2,1,1,1,2,1]]

obtenirLigne(_,8,_,Ligne,Res):- Res = Ligne.
obtenirLigne(Grille,IndexColonne,IndexLigne,Ligne,Res):-
    nth1(IndexColonne,Grille,Colonne),
    nth1(IndexLigne,Colonne,Elt),
    IndexColonne1 is IndexColonne+1,
    append(Ligne,[Elt],Ligne1),
    obtenirLigne(Grille,IndexColonne1,IndexLigne,Ligne1,Res).


% Trouve les colonnes ayant 2 jetons, du joueur adverse à J, alignés et incrémente la ligne
% du tableau de 3
indiceLignesA2Jetons(_,7,_). % 7 -> fin des lignes
indiceLignesA2Jetons(Grille,IndiceLigne,J):-
    obtenirLigne(Grille,1,IndiceLigne,[],Ligne),
    (joueurOppose(J,Jo),
    alignement2JetonsColonne(Ligne,Jo,0), % On regarde si 2 jetons adverses sont alignés
    augmenterLesCasesLigne(J,IndiceLigne,1),%appel un changement de score sur la colonne.
    I1 is IndiceLigne+1, %On incrémente l'indice des lignes
    indiceLignesA2Jetons(Grille,I1,J));

    (I1 is IndiceLigne+1,
    indiceLignesA2Jetons(Grille,I1,J)).

augmenterLesCasesLigne(_,_,8).
augmenterLesCasesLigne(J,IndiceLigne, Cpt) :- 
    tableau(T,J),
    augmentCase(IndiceLigne,Cpt,3,T,NewTab), 
    Cpt1 is Cpt+1,
    asserta(tableau(NewTab,J)),
    augmenterLesCasesLigne(J,IndiceLigne, Cpt1).



%================ AJOUT ================

regarderLesDiag(G,J) :- joueurOppose(J,J2), regardeDiag1(G,J2), regardeDiag2(G,J2).

augementeScoreDiag1(X,Y,J) :- joueurOppose(J,J2), tableau(T,J2), V is 3,
                                X2 is X+1, X3 is X+2, X4 is X+3, X5 is X+4, X6 is X+5,
                                Y2 is Y-1, Y3 is Y-2, Y4 is Y-3, Y5 is Y-4, Y5 is Y-4, Y6 is Y-5,
                                augmentCase(X,Y,V,T,T1),
                                augmentCase(X2,Y2,V,T1,T2),
                                augmentCase(X3,Y3,V,T2,T3),
                                augmentCase(X4,Y4,V,T3,T4),
                                augmentCase(X5,Y5,V,T4,T5),
                                augmentCase(X6,Y6,V,T5,T6),
                                asserta(tableau(T6,J)).


augementeScoreDiag2(X,Y,J) :- joueurOppose(J,J2), tableau(T,J2), V is 3,
                                X2 is X+1, X3 is X+2, X4 is X+3, X5 is X+4, X6 is X+5,
                                Y2 is Y+1, Y3 is Y+2, Y4 is Y+3, Y5 is Y+4, Y5 is Y+4, Y6 is Y+5,
                                augmentCase(X,Y,V,T,T1),
                                augmentCase(X2,Y2,V,T1,T2),
                                augmentCase(X3,Y3,V,T2,T3),
                                augmentCase(X4,Y4,V,T3,T4),
                                augmentCase(X5,Y5,V,T4,T5),
                                augmentCase(X6,Y6,V,T5,T6),
                                asserta(tableau(T6,J)).

augementDiag1(G,J,X,Y) :- scoreDiag1Custom(G,J,X,Y,R), R > 1, augementeScoreDiag1(X,Y,J).
augementDiag1(G,J,X,Y) :- scoreDiag1Custom(G,J,X,Y,R), R<2.

augementDiag2(G,J,X,Y) :- scoreDiag2Custom(G,J,X,Y,R), R > 1, augementeScoreDiag2(X,Y,J).
augementDiag2(G,J,X,Y) :- scoreDiag2Custom(G,J,X,Y,R), R<2.


regardeDiag1(G,J) :- augementDiag1(G,J,1,4), % diag \ 
                    augementDiag1(G,J,1,5),
                    augementDiag1(G,J,1,6),
                    augementDiag1(G,J,1,7).

regardeDiag2(G,J) :- augementDiag2(G,J,1,1), % diag / 
                    augementDiag2(G,J,1,2),
                    augementDiag2(G,J,1,3),
                    augementDiag2(G,J,1,4).

%R prend la valeur du nombre de jeton de J sur la diagonale \ 

scoreDiag1Custom(_,_,X,Y,_) :- (X > 6 ; X < 1 ; Y < 1 ; Y > 7). 
scoreDiag1Custom(G,J,X,Y,R) :- getCase(G,Y,X,J), regardeDiag1Gauche(G,J,X,Y,0,R1), regardeDiag1Droite(G,J,X,Y,0,R2),   R is R1+R2+1.
scoreDiag1Custom(G,J,X,Y,R) :- regardeDiag1Gauche(G,J,X,Y,0,R1), regardeDiag1Droite(G,J,X,Y,0,R2),  R is R1+R2.

%R prend la valeur du nombre de jeton de J sur la diagonale \
scoreDiag2Custom(_,_,X,Y,_) :- (X > 6 ; X < 1 ; Y < 1 ; Y > 7). 
scoreDiag2Custom(G,J,X,Y,R) :- getCase(G,Y,X,J), regardeDiag2Gauche(G,J,X,Y,0,R1), regardeDiag2Droite(G,J,X,Y,0,R2), R is R1+R2+1.
scoreDiag2Custom(G,J,X,Y,R) :- regardeDiag2Gauche(G,J,X,Y,0,R1), regardeDiag2Droite(G,J,X,Y,0,R2),  R is R1+R2.


%================ FIN DIAG ================

% Trouve si 2 jetons max de la même personne aligné sur une colonne
alignement2JetonsColonne(_,_,2).%2jetons alignés => stop 

alignement2JetonsColonne([X|Rest],J,_):- 
    X \== J,% Jeton au début de la colonne
    alignement2JetonsColonne(Rest,J,0). % Remise à 0 du compteur, on enlève la tête

alignement2JetonsColonne([X|Rest],J,Cpt):-
    X == J, % Jeton au début de la colonne
    Cpt1 is Cpt+1, %Incrément du compteur
    alignement2JetonsColonne(Rest,J,Cpt1). %On enlève la tête, compteur mis à jour


% Trouve les colonnes ayant 2 jetons, du joueur adverse à J, alignés et incrémente la colonne
% du tableau de 3
indiceColonnesA2Jetons(_,8,_). % IndiceCol = 8 -> fin de la colonne
indiceColonnesA2Jetons(Grille,IndiceCol,J):-
    nth1(IndiceCol, Grille, Y), % On récupère la colonne Y à l'indice indiceCol de la grille
    (joueurOppose(J,Jo),
    alignement2JetonsColonne(Y,Jo,0), % On regarde si 2 jetons adverses sont alignés
    augmenterLesCasesColonne(J,IndiceCol,1),%appel un changement de score sur la colonne.
    I1 is IndiceCol+1, %On incrémente l'indice des colonnes
    indiceColonnesA2Jetons(Grille,I1,J));

    (I1 is IndiceCol+1,
    indiceColonnesA2Jetons(Grille,I1,J)).


augmenterLesCasesColonne(_,_,7).
augmenterLesCasesColonne(J,IndiceCol, Cpt) :- tableau(T,J),
                            augmentCase(Cpt,IndiceCol,3,T,NewTab), 
                            Cpt1 is Cpt+1,
                            asserta(tableau(NewTab,J)),
                            augmenterLesCasesColonne(J,IndiceCol, Cpt1).

augmenterLesCasesColonne(J,IndiceCol, Cpt) :- tableau(T,J),
                        augmentCase(Cpt,IndiceCol,3,T,NewTab), 
                        Cpt1 is Cpt+1,
                        asserta(tableau(NewTab,J)),
                        augmenterLesCasesColonne(J,IndiceCol, Cpt1).

mettreAJourTableau(Grille,J) :-
    length(Grille, TailleY),% recupere la taille X
    nth1(1, Grille, Colonne), % recuperation de la colonne
    length(Colonne, TailleX), % recuperation de la taille Y
    forall(
        between(1, TailleY, Y), % pour chaque indice entre 1 et Taille X
        ( 
            
            forall(
                between(1, TailleX, X), % pour chaque indice entre 1 et Taille Y
                ( 
                    trouveEnemie(Grille,X,Y,J)
                )
            )
        )
    ),
    indiceColonnesA2Jetons(Grille,1,J), % augmente les colonnes ayant 2 jetons consécutifs
    regarderLesDiag(Grille,J),%augmente les diagonnales ayant 2 jetons consécutifs
    indiceLignesA2Jetons(Grille,1,J). % augmente les lignes ayant 2 jetons consécutifs



trouveEnemie(Grille,X,Y,J) :- getCase(Grille,Y,X,C), (C == J ; C == 0). %Case nous appartenant ou vide 
trouveEnemie(Grille,X,Y,J) :- getCase(Grille,Y,X,C), joueurOppose(J,Jo),  C == Jo, augmenterLesCasesAutours(J,X,Y).


augmenterLesCasesAutours(J,X,Y) :- tableau(T,J),
                            XP is X+1 , XM is X-1 , YP is Y+1, YM is Y-1,
                            XPP is X+2 , XMM is X-2, YPP is Y+2, YMM is Y-2,
                            augmentCase(XP,Y,1,T,A), %case au dessus 
                            augmentCase(XM,Y,1, A,B), %case en dessous 
                            augmentCase(X,YP,1,B,C), %case sur les coté
                            augmentCase(X,YM,1,C,D), %case sur les coté
                            augmentCase(XP,YP,1,D,E), %diagonales
                            augmentCase(XP,YM,1,E,F), %diagonales
                            augmentCase(XM,YP,1,F,G), %diagonales
                            augmentCase(XM,YM,1,G,H), %diagonales

                            augmentCase(XPP,YMM,0.5,H,H1), %1
                            augmentCase(XPP,YM,0.5,H1,H2), %2
                            augmentCase(XPP,Y,0.5,H2,H3), %3
                            augmentCase(XPP,YP,0.5,H3,H4), %4
                            augmentCase(XPP,YPP,0.5,H4,H5), %5
                            augmentCase(XP,YPP,0.5,H5,H6), %6
                            augmentCase(X,YPP,0.5,H6,H7), %7
                            augmentCase(XM,YPP,0.5,H7,H8), %8
                            augmentCase(XMM,YPP,0.5,H8,H9), %9
                            augmentCase(XMM,YP,0.5,H9,H10), %10
                            augmentCase(XMM,Y,0.5,H10,H11), %11
                            augmentCase(XMM,YM,0.5,H11,H12), %12
                            augmentCase(XMM,YMM,0.5,H12,H13), %13
                            augmentCase(XM,YMM,0.5,H13,H14), %14
                            augmentCase(X,YMM,0.5,H14,H15), %15
                            augmentCase(XP,YMM,0.5,H15,H16), %16

                            asserta(tableau(H16,J)).



%augmente de V la valeur de la case donnée ==> cas ou X<1 on joue sur la premiere ligne 
augmentCase(X,Y,_,T,RetT) :- (X > 6 ; X < 1 ; Y < 1 ; Y > 7), RetT = T. 

%augmente de V la valeur de la case donnée 
augmentCase(X,Y,V,T,NewT) :- getCase(T,Y,X,C),
                    C1 is C+V, nth1(Y,T,Colonne), replace(Colonne,X,C1,NewColonne),
                    replace(T,Y,NewColonne,NewT).


%pas a nous -> remplace le ieme element d'une liste par la valeur X
replace([_|T], 1, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > -1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L).


%[[1,2,1,0,0,0],[2,1,0,0,0,0],[1,2,1,0,0,0],[1,2,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[2,1,1,1,2,1]]
%[[0,0,0,1,0,0],[0,0,1,0,0,0],[0,1,0,0,0,0],[1,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]]
%[[1,1,1,1,1,1],[1,1,1,1,1,1],[1,1,1,1,1,1],[1,1,1,1,1,1],[1,1,1,1,1,1],[1,1,1,1,1,1],[1,1,1,1,1,1]]


%Retourne la colonne ou il faut jouer 
trouveCoupMinMax(Grille, Tableau, NumColonneAJouer) :- trouverLesPoidsJouables(Grille, Tableau, [], 1,FinalVecteur), 
                                                      trouverLePoidsMax(FinalVecteur,NumColonneAJouer).

%retourne la colonne ou le poids de la case jouable est maximum
trouverLePoidsMax(Vecteur,NumColonneAJouer) :- max_list(Vecteur,X), nth1(NumColonneAJouer,Vecteur,X).

%retourne un vecteur avec les poids des cases jouables
trouverLesPoidsJouables(_, _, Vecteur, _,FinalVecteur) :- length(Vecteur,7), FinalVecteur = Vecteur.

trouverLesPoidsJouables(Grille, Tableau, Vecteur, Colonne, FinalVecteur) :- 
    trouverLigneSurColonne(Grille,Colonne,Ligne),
    trouverPoids(Tableau,Colonne,Ligne,Valeur),
    ajouterEnFinDeListe(Valeur,Vecteur,Vecteur1),
    Colonne1 is Colonne+1,
    trouverLesPoidsJouables(Grille, Tableau, Vecteur1, Colonne1,FinalVecteur).


%Ajoute en fin de liste 
ajouterEnFinDeListe(V,L,L1) :- append(L,[V],L1).
 

%Retourne la valeur d'une case du tableau dynamique 
trouverPoids(_, _, Indice, Valeur) :- Indice is -1, Valeur is Indice.
trouverPoids(Tableau, Colonne, Indice, Valeur) :- nth1(Colonne,Tableau,C), nth1(Indice,C,Valeur).

%Retourne l'indice libre de la colonne colonne 
%trouverLigneSurColonne(Grille,Colonne,Ligne) :- nth1(Colonne,Grille,C),  colonneVide(C), length(C, Ligne). %retourne la taille de la colonne si elle est vide
trouverLigneSurColonne(Grille,Colonne,Ligne) :- nth1(Colonne,Grille,C),  colonnePleine(C), Ligne is -1. %retourne -1 si la colonne est pleine  
trouverLigneSurColonne(Grille,Colonne,Ligne) :-  nth1(Colonne,Grille,C), dernier2(C,1,Ligne).%retourne l'indice de la dernière case vide ou l'on peut jouer


%Colonne vide 
%colonneVide(C) :- not(member(1, C); member(2, C)).

%Colonne pleine 
colonnePleine(C) :- not(member(0, C)). 

%Colonne ni pleine ni vide
%   N indice de la ligne
%   Z compteur 
%   L liste 
dernier2([Y|L],Z,N) :- Y \== 0 , Z1 is Z+1, dernier2(L,Z1,N).
dernier2(_,Z,N) :- N is Z.


%------------Doublons------------------


% R�cup�re la case (Colonne,Ligne) de la Grille
%getCase(Grille,Colonne,Ligne,Retour) :- nth1(Colonne,Grille,C), nth1(Ligne,C,Retour).

%renvoi le joueur oppose
%joueurOppose(1,2).
%joueurOppose(2,1).