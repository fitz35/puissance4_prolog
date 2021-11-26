window(_, 0).
window(Grille, 1):-
    send(@window, size, size(800, 500)),

    % dessin de la grille

    % taille de la grille
    tailleList(Grille, TailleX),
    nth1(1, Grille, Colonne), % recuperation de la premiere colonne
    tailleList(Colonne, TailleY), % recuperation de la taille Y
    
    forall(between(1, TailleX, X),
    ( 
        send(@window, display, new(_, line(X * 500/TailleX, 0, X * 500/TailleX, 500)))
    )),

    forall(between(1, TailleY, Y),
    ( 
        send(@window, display, new(_, line(0, Y * 500/TailleY, 500, Y * 500/TailleY)))
    )),
    % dessin des pions
    dessin_all_pion(Grille, 1),
    % on envoie à la fenêtre le message d'affichage.
    send(@window, open).

% dessine les pions sur la grille
dessin_all_pion(_, 0).
dessin_all_pion(Grille, 1) :- 
    tailleList(Grille, TailleX),% recupere la taille X
    forall(
        between(1, TailleX, X), % pour chaque indice entre 1 et Taille X
        ( 
            nth1(X, Grille, Colonne), % recuperation de la colonne
            tailleList(Colonne, TailleY), % recuperation de la taille Y
            forall(
                between(1, TailleY, Y), % pour chaque indice entre 1 et Taille Y
                ( 
                    dessin_pion(X, Y, Grille)
                )
            )
        )
    ).

% dessine le pion a la coordonnees X, Y de la grille, avec un etat
dessin_pion(X, Y, Grille) :- 
    nth1(X, Grille, Colonne), % recuperation de la colonne
    nth1(Y, Colonne, Pion), % recuperation du pion dans la grille
    ((Pion == 1, dessin_pion_1(X, Y, Grille)) ; 
    (Pion == 2, dessin_pion_2(X, Y, Grille)) ; 
    Pion == 0).


% dessine la representation du joueur un dans la case X, Y d'un tableau Grille.
dessin_pion_1(X, Y, Grille) :-
    calcul_rectangle(X, Y, Grille, DebutWidth, DebutHeight, FinWidth, FinHeight),
    send(@window, display, new(_, line(DebutWidth, DebutHeight, FinWidth, FinHeight))),
    send(@window, display, new(_, line(DebutWidth, FinHeight, FinWidth, DebutHeight))).

% dessine la representation du joueur deux dans la case X, Y d'un tableau Grille.
dessin_pion_2(X, Y, Grille) :-
    calcul_rectangle(X, Y, Grille, DebutWidth, DebutHeight, FinWidth, FinHeight),
    send(@window, display, 
        new(_, ellipse((FinWidth - DebutWidth), (FinHeight - DebutHeight))), point(DebutWidth, DebutHeight)).

% calcul les coordonnees du rectangle dans la grille (affichée) a la position X, Y
calcul_rectangle(X, Y, Grille, DebutWidth, DebutHeight, FinWidth, FinHeight) :-
    tailleList(Grille, TailleX),% recupere la taille X
    nth1(X, Grille, Colonne), % recuperation de la colonne
    tailleList(Colonne, TailleY), % recuperation de la taille Y
    DebutWidth is (X - 1)*500/TailleX,
    DebutHeight is (TailleY - Y + 1)*500/TailleY,
    FinWidth is (X)*500/TailleX,
    FinHeight is (TailleY - Y)*500/TailleY.