function [] = CompareMicro(E, S)

subplot(1,2,1);
imshow(E); axis on; xlim([1 size(S,1)]); ylim([1 size(S,2)]);

subplot(1,2,2);
imshow(S); axis on;