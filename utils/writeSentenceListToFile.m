function writeSentenceListToFile(list, numList, path)
    header = {"# version 1.3.1.0","# Olsaf20.xx", "TestTeile: a0","a0: {"};
    header{2} = header{2}.replace('xx', num2str(numList, '%02d'));
    footer = {"}"};
    % Complement list names. It should be:
    % 33521: 33521.wav / Ulrich gibt fünf alte Tassen.
    for i=1:length(list)
        sentenceCode = list{i};
        % Remove extension if any
        sentenceCode = sentenceCode(1:5);
        % Find words
        words = [code2word(sentenceCode(1), 1), ' ', code2word(sentenceCode(2), 2), ' ', code2word(sentenceCode(3), 3), ' ',...
            code2word(sentenceCode(4), 4), ' ', code2word(sentenceCode(5), 5)];
        ss = [sentenceCode, ': ', sentenceCode, '.wav / ', words];
        % TODO: instead of One Two Three Four Five, it should be the
        % equivalent words to the sentence code.
        list{i} = ss;
    end
    
    textCell = [header, list, footer];
    % Write to file
    filename = [path, 'olsa20.', num2str(numList), '.txt'];
    writecell(textCell', filename);
    % Remove extension
    movefile(filename, string(filename).replace('.txt', ''));
    disp(['List ',num2str(numList),' written']);
end

