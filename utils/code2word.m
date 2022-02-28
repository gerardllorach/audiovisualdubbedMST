function word = code2word(code, wordCategory)
    % Transform to index
    code = str2num(code) + 1;
    
    words = {
     {'Loic', 'Gerard', 'Name2', 'Name3', 'Name4', 'Name5', 'Name6', 'Name7', 'Name8', 'Name9'},
     {'Verb0', 'Verb1', 'Verb2', 'Verb3', 'Verb4', 'Verb5', 'Verb6', 'Verb7', 'Verb8', 'Verb9'},
     {'Quantity0', 'Quantity1', 'Quantity2', 'Quantity3', 'Quantity4', 'Quantity5', 'Quantity6', 'Quantity7', 'Quantity8', 'Quantity9'},
     {'Adjective0', 'Adjective1', 'Adjective2', 'Adjective3', 'Adjective4', 'Adjective5', 'Adjective6', 'Adjective7', 'Adjective8', 'Adjective9'},
     {'Noun0', 'Noun1', 'Noun2', 'Noun3', 'Noun4', 'Noun5', 'Noun6', 'Noun7', 'Noun8', 'Noun9'},
    };

    word = words{wordCategory}{code};

end