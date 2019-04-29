 //number of nodes
 int n = ...;
 
 //set of all nodes
 range I = 1..n;
 
 //distance matrix
 int d [I][I] = ...;
 
 //subtour
 tuple subTour{
 	int cardinality;
 	{int} node; //Set of nodes contained in subtour 
 }
 
 //Set of all discovered subtours
 {subTour} subTours = ...;
 
 //indicates whether node j is visited directly after node i
 dvar boolean x[I][I];
 
 //minimize total sum of distance
 minimize sum(i in I, j in I)(d[i][j]*x[i][j]);
 
 subject to{
  
  	//each node is left exactly once
 	forall(i in I){
 		sum(j in I: j != i) x[i][j] == 1; 	
 	} 
 	
 	//each node is visited exactly one
 	forall(j in I){
 		sum(i in I: i != j) x[i][j] == 1; 	
 	}
 	
 	//Subtour-Elimination (2 <= |S| <= n/2 is taken care in the execute block)
 	forall (S in subTours){
 		sum(i in S.node, j in S.node)x[i][j] <= card(S.node) - 1;	
 	}
 }
 
 //help variables to store (temporarily) found subtours in the execute block
 {int} help_subtour;
 {int} shortest_subtour;
 
 execute{
 	//go through all nodes and consider them as a potential starting point for a sub tour
 	for (var start in I){ 	
 		//i is set to start
 		var i = start;
 	
	 	var proceed = true;
	 	
	 	help_subtour.clear();
	 	
	 	//itterate edges of the solution from i until you reach start
	 	//or until the subtour found is longer than n/2 
	 	
	 	while(proceed){
	 	 	
	 	 	for(var j in I){ 	 	
	 	 		//search the outgoing edge of i contained in the solution 
	 	 		if(x[i][j] == 1){
	 	 			//set i to j, to continue from there	 	 			 		 		
	 	 			i = j;
	 	 			help_subtour.add(i); //add visited knots to auxiliary set
	 	 			break; 	 		
	 	 		} 	 	
	 	 	}
	 	 	//interrupt for subtours greater than n/2
	 	 	if(help_subtour.size > n/2){
	 	 		proceed = false;	 	 	
	 	 	}
	 	 	//arrived at start (i.e. subtour with length <= n/2 is found)
	 	 	else if (i == start){
	 	 		proceed = false;
	 	 		//first subtour found (i.e. shortest_subtour is an empty set)
	 	 		//is stored in shortest_subtour	
	 	 		if(shortest_subtour.size == 0){ 	 	
	 				for(var k in help_subtour){
	 					shortest_subtour.add(k);	 		
	 				}	 		 	
	 			}
	 			//subtour found is horter than hortest_subtour found so far
			 	if(help_subtour.size < shortest_subtour.size){			 	 	
			 		//previous shortest_subtour is deleted
			 		shortest_subtour.clear();
			 		//shortest subtour found is stored in shortest_subtour
			 		for(var k in help_subtour){
			 			shortest_subtour.add(k);	 		
			 		}	 	 	
			 	} 	
	 	 	}
	 	}	 	
	} 
 }