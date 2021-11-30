window(_, 0).
window(Window, Grille, 1):-
    send(Window, size, size(550, 540)),

    % dessin de la grille

    % taille de la grille
    tailleList(Grille, TailleX),
    nth1(1, Grille, Colonne), % recuperation de la premiere colonne
    tailleList(Colonne, TailleY), % recuperation de la taille Y
    
    forall(between(1, TailleX, X),
    ( 
        send(Window, display, new(_, line(X * 500/TailleX, 0, X * 500/TailleX, 500)))
    )),

    forall(between(1, TailleY, Y),
    ( 
        send(Window, display, new(_, line(0, Y * 500/TailleY, 500, Y * 500/TailleY)))
    )),
    % dessin des pions
    dessin_all_pion(Window, Grille, 1),
    % dessin des bouttons
    dessin_boutton(Window, Grille, 1),
    % on envoie à la fenêtre le message d'affichage.
    send(Window, open).

% dessin les bouttons
dessin_boutton(_, _, 0).
dessin_boutton(Window, Grille, 1) :- 
    tailleList(Grille, TailleX),
    forall(between(1, TailleX, X),
    (
        send(Window, display, new(B, box(500/TailleX, 40)), point((X-1) * 500/TailleX, 500)),
        send(Window, display, new(_, text("^")), point((X-1 + 0.4) * 500/TailleX, 500 + 40/2)),
        send(B, recogniser, click_gesture(left, '', single, message(@prolog, traitement_click, X, Grille)))
    )).

% dessine les pions sur la grille
dessin_all_pion(_, _, 0).
dessin_all_pion(Window, Grille, 1) :- 
    tailleList(Grille, TailleX),% recupere la taille X
    forall(
        between(1, TailleX, X), % pour chaque indice entre 1 et Taille X
        ( 
            nth1(X, Grille, Colonne), % recuperation de la colonne
            tailleList(Colonne, TailleY), % recuperation de la taille Y
            forall(
                between(1, TailleY, Y), % pour chaque indice entre 1 et Taille Y
                ( 
                    dessin_pion(Window, X, Y, Grille)
                )
            )
        )
    ).

% dessine le pion a la coordonnees X, Y de la grille, avec un etat
dessin_pion(Window, X, Y, Grille) :- 
    nth1(X, Grille, Colonne), % recuperation de la colonne
    nth1(Y, Colonne, Pion), % recuperation du pion dans la grille
    ((Pion == 1, dessin_pion_1(Window, X, Y, Grille)) ; 
    (Pion == 2, dessin_pion_2(Window, X, Y, Grille)) ; 
    Pion == 0).


% dessine la representation du joueur un dans la case X, Y d'un tableau Grille.
dessin_pion_1(Window, X, Y, Grille) :-
    calcul_rectangle(X, Y, Grille, DebutWidth, DebutHeight, FinWidth, FinHeight),
    send(Window, display, new(_, line(DebutWidth, DebutHeight, FinWidth, FinHeight))),
    send(Window, display, new(_, line(DebutWidth, FinHeight, FinWidth, DebutHeight))).

% dessine la representation du joueur deux dans la case X, Y d'un tableau Grille.
dessin_pion_2(Window, X, Y, Grille) :-
    calcul_rectangle(X, Y, Grille, DebutWidth, DebutHeight, FinWidth, FinHeight),
    send(Window, display, 
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

% traite les cliques
traitement_click(Colonne, Grille) :- fait_cout(Colonne, Grille, @joueur1, @joueur2, _).