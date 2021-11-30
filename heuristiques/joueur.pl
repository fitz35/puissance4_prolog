% DE hexanome 4124

% valide un input
valid(Cout, G) :- Cout > 0, Cout < 8, nth1(Cout, G, Colonne), compter(Colonne, NbZero), NbZero > 0.

% demande un input et le valide
ask(Cout, G) :- 
    repeat, 
        ecrit(" entrez un nombre: ",1),
        read(Cout),
    valid(Cout, G),
    !.

fait_cout(Colonne, Grille, N1, N2, Res) :- 
    nth1(Colonne,Grille,C), ajouter(C, @tourJoueur, C1), changeColonne(Grille,Colonne,C1,[],1,G1),
    affiche(G1,[],1),
    dessin_all_pion(@window, G1, 1),
    joueurOppose(@tourJoueur, JoueurOp), @tourJoueur is JoueurOp, heuristique(G1, JoueurOp, [N1|N2],1,Res). % gagnant()

% DE :
% Damien Carreau
% Enzo Boscher
% Alexandre Bonhomme
% Pierre-Louis Jallerat
% Mickael Ben Said
% Antoine Mandin

jouerJoueur(_,Joueur, _, _, 1,_) :- ecrit("Joueur joue ",1),ecrit(Joueur,1).
jouerJoueur(G,Joueur, N1, N2, 0,Res) :- ecrit("Joueur joue ",1),ecrit(Joueur,1),
                                ask(L, G) , nth1(L,G,C), ajouter(C, Joueur, C1), changeColonne(G,L,C1,[],1,G1),
                                affiche(G1,[],0),
                                dessin_all_pion(G1, 0),
                                joueurOppose(Joueur, JoueurOp), heuristique(G1, JoueurOp, [N1|N2],0,Res). % gagnant()
