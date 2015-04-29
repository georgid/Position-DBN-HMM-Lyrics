function transMatrix =  doTransMatrix( n_v, n_p, pr)
%  @param: n_p : from position
% @param: n_v: from velocity

n_s = 2; 
% s_1 - sil section
% s_2 - section score

% stay at same seciton at end of prev. section
stayAtSectionProb = zeros(n_s,1);
stayAtSectionProb(1) = 0.8;
stayAtSectionProb(2) = 0;

% stay at section before finishing current section
sameSectionProb = 1;


% @param pr: fixed prob of change of velocity +- 1


% 3rd dim is pointer to the only 6 probable next state tuples (s,p,v)
% (1:3,1:2) two options for next section:    (1:3,1) - same section, (1:3,2) - change to other section possible
% 4th dim is coordinate for 1. toV, 2. toP, 3. toS  and 4. prob for the target point
transMatrix=zeros( n_v, n_p, n_s, 3, 2, 4); 

	for currVel = 1:n_v


		for currPos = 1:n_p
				
			for currSection = 1:n_s

					% 1. toV : velocity of the three points
				transMatrix(currVel,currPos, currSection, 1, 1:2, 1) = currVel -1;
				transMatrix(currVel,currPos, currSection, 2, 1:2, 1) = currVel;
				transMatrix(currVel,currPos, currSection, 3, 1:2, 1) = currVel +1;
				
				
				% 2.  toPosition : position of the three points
				duration = getDurationForSection(currSection,n_p);
				toPosiiton = mod ( (currPos + currVel - 1 ), duration )  + 1;
				transMatrix(currVel,currPos, currSection, 1:3, 1:2 ,2) = toPosiiton;
				
				% if transition skips last position => force to stay in last
				% position, because it is indicator for change of section
% 				transMatrix(currVel,currPos,1:3,2) = min  (currPos + currVel, n_p); 
				
				% 3. section
				if toPosiiton <= currPos % position reset => possible change of section
					nextSection = currSection;
					transMatrix(currVel,currPos,currSection, 1:3, 1, 3) =  nextSection ;
					
					transMatrix(currVel,currPos,currSection, 1, 1, 4) = stayAtSectionProb(currSection) * pr/2;
					% same volocity
					transMatrix(currVel,currPos,currSection, 2, 1, 4) = stayAtSectionProb(currSection) * (1-pr);

					transMatrix(currVel,currPos,currSection, 3, 1, 4) = stayAtSectionProb(currSection) * pr/2;
					
					if currSection == 1
						nextSection =  2;
					elseif currSection == 2
						nextSection = 1;
											
					end
					transMatrix(currVel,currPos,currSection, 1:3,2,3) =  nextSection;
	
					
					transMatrix(currVel,currPos,currSection, 1,2,4) = (1 - stayAtSectionProb(currSection)) * pr/2;
					% same volocity
					transMatrix(currVel,currPos,currSection, 2,2,4) = (1 - stayAtSectionProb(currSection)) * (1-pr);

					transMatrix(currVel,currPos,currSection, 3,2,4) = (1 - stayAtSectionProb(currSection)) * pr/2;
					
					
				
				else % % position still wihin section=> same section. in this case the second point at ccordinate 5 is redundant
					nextSection = currSection;
					transMatrix(currVel,currPos,currSection, 1:3,1:2, 3) =  nextSection;
					% 3. probability 
					
					
					transMatrix(currVel,currPos,currSection, 1, 1:2, 4) = sameSectionProb * pr/2;
					% same volocity
					transMatrix(currVel,currPos,currSection, 2,1:2, 4) = sameSectionProb * (1-pr);

					transMatrix(currVel,currPos,currSection, 3,1:2, 4) = sameSectionProb * pr/2;
					
					
				
					
					
				end
				
				

				
				% velocity cannot decrease to 1-1= 0. 
				if transMatrix(currVel,currPos, currSection,  1,1,1) == 0
					%     So assign 0 prob.
						transMatrix(currVel,currPos, currSection, 1,1:2, 4) = 0;
						transMatrix(currVel,currPos,currSection, 3,1:2, 4) = pr;

				end



				% velocity cannot increase to max n_v + 1
				if transMatrix(currVel,currPos,currSection,3,1,1) == n_v + 1; 
					%     So assign 0 prob.
						transMatrix(currVel,currPos,currSection, 3,1:2, 4) = 0;
						transMatrix(currVel,currPos,currSection, 1,1:2, 4) = pr;

				end
				
			end

		end

	end



end


function duration = getDurationForSection(s,n_p)
	if s == 1
		duration = 50;
	elseif s==2 
		duration = n_p;
	else
		error('not expected duration of section when constructing trans matrix');
	end
end