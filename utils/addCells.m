function c= addCells(c1, c2)
    c= {};
    for i=1:size(c1, 1)
        temp= c1{i}+c2{i};
        c= [c; temp];
    end
end