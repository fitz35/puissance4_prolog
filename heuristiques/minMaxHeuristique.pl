
% Heuristique 6 : min-max,
%                 s'il existe joue coup gagnant,
%                 sinon si l'adversaire à un coup gagnant, bloque le,
%                 sinon, en s'appuyant sur un tableau qui indique un score pour chaque coup, joue le coup avec le meilleur score

:- dynamic tableau/1.
tableau([[3,4,5,5,4,3],[4,6,8,8,6,4],[5,8,11,11,8,5],[7,10,13,13,10,7],[5,8,11,11,8,5],[4,6,8,8,6,4],[3,4,5,5,4,3]]).


% Heuristique minMax // fait jouer le coup trouvé 
minMaxDynamique(Grille,J,G1) :- tableau(X), trouveCoupMinMax(Grille, X, NumColonneAJouer), jouerMove(J,Grille,NumColonneAJouer,G1).


tailleList([_|Q], T) :- tailleList(Q, T2), T is T2 + 1.


mettreAJourTableau(Grille) :-      
    length(Grille, TailleX),% recupere la taille X
    forall(
        between(1, TailleX, X), % pour chaque indice entre 1 et Taille X
        ( 
            nth1(X, Grille, Colonne), % recuperation de la colonne
            length(Colonne, TailleY), % recuperation de la taille Y
            forall(
                between(1, TailleY, Y), % pour chaque indice entre 1 et Taille Y
                ( 
                    ajoutAutourEnemie(Grille,X,Y)
                )
            )
        )
    ).


ajoutAutourEnemie(Grille,X,Y) :- getCase(Grille,X,Y,C), C == 1, write("Un enemie en "), write(X), write(Y).

%[[1,2,1,0,0,0],[2,1,0,0,0,0],[1,2,1,0,0,0],[1,2,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[2,1,1,1,2,1]]


%Retourne la colonne ou il faut jouer 
trouveCoupMinMax(Grille, Tableau, NumColonneAJouer) :- trouverLesPoidsJouables(Grille, Tableau, [], 1,FinalVecteur), write(FinalVecteur), 
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

% R�cup�re la case (Colonne,Ligne) de la Grille
%getCase(Grille,Colonne,Ligne,Retour) :- nth1(Colonne,Grille,C), nth1(Ligne,C,Retour).