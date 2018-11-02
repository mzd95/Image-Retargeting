function out_r_nn = nnmex(res, img, nn)

[M,N,~] = size(res);
[X,Y,~] = size(img);

%% Propagation
%forward
for x = 2:M-6
    for y = 2:N-6
        [minD,I] = min([nn(x,y,3),nn(x-1,y,3),nn(x,y-1,3)]);
        if I == 2 && nn(x-1,y,1)+1 <= X-6
            nn(x,y,1:2) = nn(x-1,y,1:2);
            nn(x,y,1) = nn(x,y,1) + 1;
            nn(x,y,3) = minD;
        elseif I == 3 && nn(x,y-1,2)+1 <= Y-6
            nn(x,y,1:2) = nn(x,y-1,1:2);
            nn(x,y,2) = nn(x,y,2) + 1;
            nn(x,y,3) = minD;
        end
    end
end

%backward
for x = M-7:-1:1
    for y = N-7:-1:1
        %propagation
        [minD,I] = min([nn(x,y,3),nn(x+1,y,3),nn(x,y+1,3)]);
        if I == 2 && nn(x+1,y,1)-1 >0
            nn(x,y,1:2) = nn(x+1,y,1:2);
            nn(x,y,1) = nn(x,y,1) - 1;
            nn(x,y,3) = minD;
        elseif I == 3 && nn(x,y+1,2)-1 > 0
            nn(x,y,1:2) = nn(x,y+1,1:2);
            nn(x,y,2) = nn(x,y,2) - 1;
            nn(x,y,3) = minD;
        end   
    end
end

%% Random Search
a = 0.5;
w = max(X,Y);


for x = 1:M-6
    for y = 1:N-6
        cand_x = [0];
        cand_y = [0];
        max_n = ceil( log(1/w) / log(0.5) )  ;
        
        % select out all candidates of offset
        for n = 0 : max_n
            fl = 1;
            while fl
                Ux = round(w*(2*rand()-1)*a^n);
                Uy = round(w*(2*rand()-1)*a^n);
                x2 = nn(x,y,1) + Ux;
                y2 = nn(x,y,2) + Uy;
                fl = x2<1 || x2>X-6 || y2<1 || y2>Y-6;
            end
            cand_x = [cand_x ; x2];
            cand_y = [cand_y ; y2];
        end
        
        % pick the one with min distence
        for i =2:max_n + 2
            x2 = cand_x(i);
            y2 = cand_y(i);
            Dist = sum(sum(sum( (res(x:x+6,y:y+6,:)-img(x2:x2+6,y2:y2+6,:)).^2 )));
            if Dist < nn(x,y,3)
                nn(x,y,3) = Dist;
                nn(x,y,1) = x2;
                nn(x,y,2) = y2;
            end
        end
    end
end


out_r_nn = nn;

end
        