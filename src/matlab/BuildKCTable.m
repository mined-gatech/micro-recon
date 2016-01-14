function [KCTable] = BuildKCTable(Exemplar_NBs, K, Exemplar_Index, Exemplar_Params)
    [KCTable] = flann_search(Exemplar_Index, Exemplar_NBs', K, Exemplar_Params);
end
