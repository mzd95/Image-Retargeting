function [res, ann, bnn] = search_vote_func(img, res, niters, j, k, resultFolder, sceneName)
% Please replace the nnmex and votemex after you have implemented your own
% searching and voting function for PatchMatch

%% Parameters for patchmatch
[M,N,~] = size(res);
[X,Y,~] = size(img);

%% Go th n iterations
for iter = 1:niters
    %% Searching for NNF ( in which do one iteration of propagation and random search )
    if iter == 1
        % Random Offset
        ann = zeros(M-6,N-6,3);
        bnn = zeros(X-6,Y-6,3);
        ann(:,:,1) = round( rand(M-6,N-6)*(X-7)+1 );
        ann(:,:,2) = round( rand(M-6,N-6)*(Y-7)+1 );
        bnn(:,:,1) = round( rand(X-6,Y-6)*(M-7)+1 );
        bnn(:,:,2) = round( rand(X-6,Y-6)*(N-7)+1 );
        for x = 1:M-6
            for y = 1:N-6
                x2 = ann(x,y,1);
                y2 = ann(x,y,2);
                ann(x,y,3) = sum(sum(sum( (res(x:x+6,y:y+6,:)-img(x2:x2+6,y2:y2+6,:)).^2 )));
            end
        end
        for x2 = 1:X-6
            for y2 = 1:Y-6
                x =  bnn(x2,y2,1);
                y =  bnn(x2,y2,2);
                bnn(x2,y2,3) = sum(sum(sum( (res(x:x+6,y:y+6,:)-img(x2:x2+6,y2:y2+6,:)).^2 )));
            end
        end
        
        % First iteration
        ann = nnmex(res, img, ann);
        bnn = nnmex(img, res, bnn);
    else
    	ann = nnmex(res, img, ann);
        bnn = nnmex(img, res, bnn);
    end

	%% Voting     
    res = votemex(img, ann, bnn);    
    outPath = sprintf('%s/%s_%04d-%04d-Iter-%04d.png', resultFolder, sceneName, j, k, iter);
    imwrite(uint8(255*res), outPath);    
	fprintf(1,'%d_%d_%d\n ',j,k,iter);

end

end
