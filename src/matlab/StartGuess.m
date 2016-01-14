function [S] = StartGuess(E, MSIZE)

    S = zeros(MSIZE);

    for ii=1:numel(S)
        t = E{randi(size(E,1))};
        S(ii) = t(randi(numel(t)));
    end

end
