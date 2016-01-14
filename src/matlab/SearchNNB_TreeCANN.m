function [Recon] = SearchNNB_TreeCANN(S, Recon)
    
    S_orig = S;
    for ExemplarIndex=1:size(Recon.E,1)
        
        % Get the TreeCANN parameters
        pach_w = Recon.TreeCANN.patch_w;
        num_of_train_patches = Recon.TreeCANN.num_of_train_patches;
        num_PCA_dims = Recon.TreeCANN.num_PCA_dims;
        num_of_ann_matches = Recon.TreeCANN.num_of_ann_matches;
        eps = Recon.TreeCANN.eps;
        A_grid = Recon.TreeCANN.A_grid;
        B_grid = Recon.TreeCANN.B_grid;
        A_win = Recon.TreeCANN.A_win;
        B_win = Recon.TreeCANN.B_win;
        
        if(ExemplarIndex == 2)
            S = shiftdim(S_orig, 1);
        elseif(ExemplarIndex == 3)
            S = shiftdim(S_orig, 2);
        end
         
        % Setup the data structures for this exemplar, we precompute
        % some stuff because the exemplar image does not change between
        % queries.
        E = Recon.E{ExemplarIndex};
        B = zeros(size(E, 1), size(E, 2), 3); B(:, :, 1) = E; 
        [B_patch_pos_X  B_patch_pos_Y] = extract_patch_position(size(B), patch_w, B_grid);
        B_patch_learn = extract_patches_for_pca(B, patch_w, B_patch_pos_X, B_patch_pos_Y, num_of_train_patches/2);
        
        % Loop through each layer, we will treat it as a separate
        % image
        for layerii=1:size(S,3)
            Q = S(:, :, layerii);
            A = zeros(size(Q, 1), size(Q, 2), 3); A(:, :, 1) = Q;
            [A_patch_pos_X  A_patch_pos_Y] = extract_patch_position(size(A), patch_w, A_grid);

            
            
        end
        
    end

end

function [patches]  = extract_patches_for_pca(im, patch_w, pos_X, pos_Y, num_of_train_patches)

    rand_indx = randi(size(pos_X,2),num_of_train_patches,1);
    pos_X = pos_X(rand_indx);
    pos_Y = pos_Y(rand_indx);

    patch_size = patch_w*patch_w*size(im,3);
    patches = zeros(patch_size, num_of_train_patches);
    for i=1:length(rand_indx)
        patch  = im(  pos_Y(i):pos_Y(i)+patch_w -1, pos_X(i):pos_X(i)+patch_w-1 ,:) ; 
        %patches(:,i) = reshape(patch, patch_size, 1);
         patches(:,i) = reshape(permute(patch, [2 1 3] ),[prod(numel(patch)) 1] );
    end

end


function [im_patch_pos_X  im_patch_pos_Y] = extract_patch_position(im_size,  patch_w, im_grid_step )

    x = 1:im_grid_step:im_size(2) - patch_w+1;
    y = 1:im_grid_step:im_size(1) - patch_w+1;
    [X Y] = meshgrid(y,x);

    im_patch_pos_X = reshape(Y,1,numel(Y));
    im_patch_pos_Y = reshape(X,1,numel(X));

end