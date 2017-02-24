function transMatrixFull = calcTransMatrixFull(V, P, prChangeVelocity)
	% dense transition Matrix. see method for description of transMatrix object
	transMatrix=doTransMatrix(V,P, prChangeVelocity);

	S = 2;
    transMatrixFull = sparse(V*P*S,V*P*S);
	sizes = [V,P,S];
	
    % construct full matrix. 
    for fromV = 1:V
		for fromP  = 1:P
			for fromS = 1:S 
				
				fromCartesian = sub2ind(sizes, fromV,fromP,fromS);
				for pointsOne = 1:3
					for pointsTwo  = 1:2
						toV=transMatrix(fromV,fromP, fromS, pointsOne,pointsTwo,1);
						toP=transMatrix(fromV,fromP,fromS, pointsOne,pointsTwo,2);
						toS=transMatrix(fromV,fromP, fromS, pointsOne,pointsTwo,3);
						
						prob = transMatrix(fromV,fromP,fromS, pointsOne,pointsTwo,4);
						if prob == 0
							continue;
						end
						toCartesian = sub2ind(sizes, toV,toP,toS);

						transMatrixFull(fromCartesian, toCartesian) =	prob;
					end
				end
				
			end
		end
    end


transMatrixFull = normr(transMatrixFull);

end
