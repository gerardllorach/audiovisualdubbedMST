function word = code2word(code, wordCategory)
    % Transform to index
    code = str2num(code) + 1;
    
    words = {
     {'Jean-Luc', 'Emile', 'Agnès', 'Julien', 'Etienne', 'Michel', 'Eugène', 'Félix', 'Charlotte', 'Sophie'},
     {'ramasse', 'voudrait', 'attrape', 'dessine', 'demande', 'ramène', 'reprend', 'achete', 'propose', 'déplace'},
     {'tois', 'deux', 'quinze', 'huit', 'douze', 'onze', 'neuf', 'six', 'cinq', 'sept'},
     {'classeurs', 'livres', 'crayons', 'piquets', 'vélos', 'jetons', 'ballons', 'anneaux', 'rubans', 'pions'},
     {'jaunes', 'rouges', 'verts', 'bruns', 'bleus', 'mauves', 'roses', 'blancs', 'gris', 'noirs'},
    };

    word = words{wordCategory}{code};

end