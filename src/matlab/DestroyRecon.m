function [Recon] = DestroyRecon(Recon)

% Clears up the memory associated with a flann index
if(exist('Recon') && isfield(Recon, 'Exemplar_Index'))
    for ii=1:size(Recon.Exemplar_Index, 1)
        if(Recon.Exemplar_Index{ii} ~= 0)
            fprintf(1, 'Freeing FLANN Index\n');
            flann_free_index(Recon.Exemplar_Index{ii}); 
        end
        Recon.Exemplar_Index{ii} = 0;
    end
end