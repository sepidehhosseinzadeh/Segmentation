function temp_visualize_results(prediction, labels_test)
    p = prediction(:, 2)> prediction(:, 1);
    acc= length(find(p==labels_test))/length(p)
    imgP= reshape(prediction(1:1500*1500, 2), 1500, 1500);
    imshow(imgP);
    imgGt= reshape(labels_test(1:1500*1500), 1500, 1500);
    figure, imshow(imgGt);
end