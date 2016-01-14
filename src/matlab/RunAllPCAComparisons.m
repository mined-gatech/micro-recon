function [] = RunAllPCAComparisons()

    load ../../results/macadamia_result.mat
    load ~/work/samples/nutshells/macadamia_small.mat
    MakeFigures('macadamia', M, S_star3, S_star9);
    close all

    load ~/work/samples/nutshells/ivory_dilated.mat; M = double(M);
    load ../../results/pecan_results.mat; 
    MakeFigures('ivory', M, S_star3, S_star9);
    close all

    load ../../results/rand_vf50pct_grf_1_2_3_result.mat
    load ~/work/samples/rand_vf50pct_grf_1_2_3.mat; M = double(M);
    MakeFigures('rand_vf50', M, S_star3, S_star9);
    close all

    load ../../results/rand_vf21pct_grf_1_2_3_result.mat
    load ~/work/samples/rand_vf21pct_grf_1_2_3.mat; M = double(M);
    MakeFigures('rand_vf21', M, S_star3, S_star9);
    close all

    load ../../results/voronoi_result.mat
    load ~/work/samples/rand_polycrystal_dilated.mat; M = double(M);
    MakeFigures('voronoi', M, S_star3, S_star9);
    close all

end

function [] = MakeFigures(sample_name, M, S_star3, S_star9)
    FPATH = '../../results/pca/';
    WIN_SIZES = [9 30 75];
    NUM_SAMPLES = [2000 1000 500];

    for ii=1:length(WIN_SIZES)
        fprintf(1, 'Making %s figures with window size %d:\n', sample_name, WIN_SIZES(ii))
        CompareByPCA(M, S_star3, NUM_SAMPLES(ii), WIN_SIZES(ii), sprintf('%s/%s_sz%d_3slice_pca', FPATH, sample_name, WIN_SIZES(ii))); 
        CompareByPCA(M, S_star9, NUM_SAMPLES(ii), WIN_SIZES(ii), sprintf('%s/%s_sz%d_9slice_pca', FPATH, sample_name, WIN_SIZES(ii))); 
    end
end


