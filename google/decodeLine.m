function string = decodeLine(line)
    number = [];
    %% Phase 0: Count Important Letters
    count = containers.Map;
    count('Z') = 0;
    count('U') = 0;
    count('X') = 0;
    count('G') = 0;
    count('W') = 0;
    count('H') = 0;
    count('F') = 0;
    count('S') = 0;
    count('O') = 0;
    count('I') = 0;
    for i=1:length(line)
        if isKey(count, line(i))
            count(line(i)) = count(line(i)) + 1;
        end
    end
    %% Phase 1: Unique Letters
    for i = 1:count('Z')
        decreaseEntry(count,'Z');
        decreaseEntry(count,'O');
        number = [number 0];
    end
    for i = 1:count('W')
        decreaseEntry(count,'W');
        decreaseEntry(count,'O');
        number = [number 2];
    end
    for i = 1:count('U')
        decreaseEntry(count,'U');
        decreaseEntry(count,'O');
        decreaseEntry(count,'F');
        number = [number 4];
    end
    for i = 1:count('X')
        decreaseEntry(count,'I');
        decreaseEntry(count,'X');
        decreaseEntry(count,'S');
        number = [number 6];
    end
    for i = 1:count('G')
        decreaseEntry(count,'G');
        decreaseEntry(count,'I');
        decreaseEntry(count,'H');
        number = [number 8];
    end
    
    %% Phase 2: Second Order Unique Letters
    % Letters that are unique after above numbers have been removed
    for i = 1:count('H')
        decreaseEntry(count,'H');
        number = [number 3];
    end
    for i = 1:count('F')
        decreaseEntry(count,'F');
        decreaseEntry(count,'I');
        number = [number 5];
    end
    for i = 1:count('S')
        decreaseEntry(count,'S');
        number = [number 7];
    end
    
    %% Phase 3: Third Order Unique Letters
    for i = 1:count('O')
        decreaseEntry(count,'O');
        number = [number 1];
    end
    for i = 1:count('I')
        decreaseEntry(count,'I');
        number = [number 9];
    end
    
    number = sort(number,'ascend');
    string = '';
    for i=1:length(number)
       string = strcat(string,int2str(number(i))); 
    end
    
end

function resultingDictionary = decreaseEntry(dictionary, key)
    dictionary(key) = dictionary(key) - 1;
    resultingDictionary = dictionary;
end

