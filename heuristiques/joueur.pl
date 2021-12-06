% DE hexanome 4124

% valide un input
valid(Cout, G) :- number(Cout), Cout > 0, Cout < 8, nth1(Cout, G, Colonne), compter(Colonne, NbZero), NbZero > 0.

% demande un input et le valide
ask(Cout, G) :- 
    repeat, 
        ecrit(" entrez un nombre: ",1),
        read(Cout),
    valid(Cout, G),
    !.

% DE :
% Damien Carreau
% Enzo Boscher
% Alexandre Bonhomme
% Pierre-Louis Jallerat
% Mickael Ben Said
% Antoine Mandin

jouerJoueur(G,Joueur, N1, N2, Etat,Res) :- ecrit("Joueur joue ",1),ecrit(Joueur,1),
                                ask(L, G) , nth1(L,G,C), ajouter(C, Joueur, C1), changeColonne(G,L,C1,[],1,G1),
                                affiche(G1,[],Etat),
                                dessin_all_pion(G1, Etat),
                                joueurOppose(Joueur, JoueurOp), heuristique(G1, JoueurOp, [N1|N2],Etat,Res). % gagnant()
