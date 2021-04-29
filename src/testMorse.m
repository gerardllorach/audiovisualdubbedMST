% Tests the morse encoder and decoder
function testMorse()

    sentenceCode = ''; % '59782';
    for i = 0:99999
        sentenceCode(1) = num2str(floor(i/1e4));
        sentenceCode(2) = num2str(floor(i/1e3) - floor(i/1e4)*10);
        sentenceCode(3) = num2str(floor(i/1e2) - floor(i/1e3)*10);
        sentenceCode(4) = num2str(floor(i/1e1) - floor(i/1e2)*10);
        sentenceCode(5) = num2str(floor(i/1e0) - floor(i/1e1)*10);

         fs = 44100;
         signal = morseEncode(sentenceCode, fs);
         %sound(signal, fs);
         result = morseDecode(signal,fs);
         disp(['Original: ', sentenceCode, ', Result: ', result]);
    end

end