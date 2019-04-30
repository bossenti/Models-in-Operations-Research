 using CP;
 
 //data variables
 int n = ...; //number of nodes to visit
 range V = 1..n; //set of all nodes
 
 range VWith0 = 0..n; //n+1 indices starting with 0
 //n+1 indices necessary, cause node 1 is first and last one in the sequence
 //starting with 0, since type-array is created with append function, which creates an array starting with zero
 
 //definition tupel for transfer matrix
 tuple Gap { 
 	int node1; 
 	int node2; 
 	int dist;
 };
 
 int d[V][V] = ...; //distance matrix
 int T[i in V] = i; //indices of nodes as types
 int TNew[VWith0] = append(all(i in V) T[i], all(i in 1..1)T[i]); //array with types (originally indices of nodes), 1 as first and last
 {Gap} M = {<i, j, d[i][j]> | i in V, j in V}; //transfer matrix (Gap between intervalls of type i and j corresponds to the gap between node i and j)
 
 //decision variables
 dvar interval nodes[i in VWith0] size 0; //one interval for each node (exception: 2 intervals for node 1)
 dvar sequence haul in all(i in VWith0)nodes[i] types TNew; //sequence with all nodes and corresponding types
 
 //target function
 minimize  endOf(nodes[n]); //minimize end of last interval
 
 constraints{
 
 	noOverlap(haul, M, true); //preclude parallel usage of multiple nodes and set respective haul as buffer
 								// (true ensures that these buffers are only valid for the direct successor)
 	
 	first(haul, nodes[0]); //set node 1 (with index 0) at first in the tour
 							   //as sought tour is a circle of nodes, starting node is arbitrary
 	
 	last(haul, nodes[n]); //set node 1 (with index n) as last in the tour
 							 //end with same node as started
 	
 } 
 
 
 execute{

		writeln("Optimal solution");
		writeln("");
 		writeln("minimum total haul: " + Opl.endOf(nodes[n])); //output total haul (corresponds end of last node)
 		writeln("");
 		writeln("optimal tour: ");
 		write("1"); //tour starts with node 1 beginnt mit Knoten 1
 		var s  = haul.first(); //start with first interval
 		
 		while(-1 != Opl.typeOfNext(haul,s,-1)){ //As long as interval s is not the last one in sequence s
 			 write(" - " + Opl.typeOfNext(haul,s,-1));	//output type of following interval (typ corresponds node index)
 			 s = haul.next(s);	//set s to next node interval in sequence
 		}	
 }
 
 