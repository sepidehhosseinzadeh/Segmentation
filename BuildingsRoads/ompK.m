function s = ompK(K, x, D)
    Res = x;
    [m, n] = size(D);
    %Phi = zeros(K, m);
    for i = 1:K
        temp = D*Res;
        [val(i), index(i)] = max(abs(temp));
        val(i) = temp(index(i));
        Phi(:,i) = D(index(i),:);
        
        t = Phi\x;
        a(:,i) = Phi*t;
        Res = x - a(:,i);
        
    end
    s = zeros(m,1);
    s(index) = t;
end