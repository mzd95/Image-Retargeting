function res = votemex(img, ann, bnn)

[M,N,~] = size(ann);
[X,Y,~] = size(bnn);
Nt = M*N;
Ns = X*Y;
res = ones(M+6,N+6,3);

for x = 1:M+6
    for y = 1:N+6
        
        S2 = zeros(1,1,3);
        m = 0;
        for i = 0:6
            for j = 0:6
                if x-i > 0 && y-j > 0 && x-i <= M && y-j <= N
                    c1_x = x-i;
                    c1_y = y-j;
                    c2_x = ann(c1_x,c1_y,1);
                    c2_y = ann(c1_x,c1_y,2);
                    x2 = c2_x + i;
                    y2 = c2_y + j;
                    S2 = S2 + img(x2,y2,:);
                    m = m + 1;
                end
            end
        end
        
        S1 = zeros(1,1,3);
        n = 0;
        for i = 0:6
            for j = 0:6
                if x-i > 0 && y-j > 0 && x-i <= M && y-j <= N
                    [index_x,index_y] = find(bnn(:,:,1) == x-i & bnn(:,:,2) == y-j);
                    len = length(index_x);
                    if len == 1
                        index_x = index_x + i;
                        index_y = index_y + j;
                        S1 = S1 + img(index_x,index_y,:);
                        n = n+1;
                    elseif len > 1
                        index_x = index_x + i;
                        index_y = index_y + j;
                        for k = 1:len
                            S1 = S1 + img(index_x(k),index_y(k),:);
                        end
                        n = n + len;
                    end

                end
            end
        end
        
        C1 = Nt/(n*Nt+m*Ns);
        C2 = Ns/(n*Nt+m*Ns);
        res(x,y,:) = C1*S1 + C2*S2;
        
    end
end

end