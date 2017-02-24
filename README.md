
This is a matlab implementation for Hierarchical Hidden Markov Models (HHMMs)-based search of lyrics key-phrases:
-a textual keyphrase (with musical scores) is considered as query; 
-audio candidate segments from audio are targets




Availability of software:
---------------------------------

Copyright 2015,2016 Music Technology Group - Universitat Pompeu Fabra

Position-DBN-HMM-Lyrics is free software: you can redistribute it and/or modify it under the terms of the 
GNU Affero General Public License as published by the Free Software Foundation (FSF), either version 3 of the License, 
or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  
If not, see http://www.gnu.org/licenses/


Citation:
---------------------------------
Please cite the following work if you use the part of this software in your work: 

Dzhambazov, G., Şentürk S., & Serra X. (2015).  
Searching Lyrical Phrases in A-Capella Turkish Makam Recordings. 
16th International Society for Music Information Retrieval (ISMIR) Conference

NOTE: this repository covers only step 2: HMM-based model of the paper



Usage of software:
---------------------------------

### inputs: 
candSegments - read from file
URI_targetNoExt


### outputs: 
 
allWeights = [];
allStartFrames = [];
allEndFrames = [];

!!! current parameters: 
initial tempoCoeff = 2
weight - according to acoustic weight
pr velocity transition = 0.2
with tempo estimation from me. not from Sertan



Software modules description:
---------------------------------------
top-most script doit

[main script for step 2. HMM](https://github.com/georgid/Position-DBN-HMM-Lyrics/blob/master/doitDBNHMM.m)

it [calls here](https://github.com/georgid/Position-DBN-HMM-Lyrics/blob/master/doitDBNHMM.m#L73) [decodeOneCandSegment](https://github.com/georgid/Position-DBN-HMM-Lyrics/blob/master/decodeOneCandSegment.m)

Transition probabilities in creating a dense transition matrix in [doTransMatrix](https://github.com/georgid/Position-DBN-HMM-Lyrics/blob/master/doTransMatrix.m) 


Notes:
--------------------------------------
rankPaths - select only full paths ; calculate ranks for these selected paths 

NOTE: decodeViterbi -> if whichFrame=1


params: init prob equal to start at p=1:10; fix to start at vel v=2;  


we allow bigger transition prob, to allow change of speed to accommodate skipping or  insertion of phonemes relative to phoneme transcipt
