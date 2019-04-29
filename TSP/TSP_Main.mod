 main{
 	//initialize ModelSource and ModelDefinition 
 	var modelSrc = new IloOplModelSource("TSP_Model.mod");
 	var modelDef = new IloOplModelDefinition(modelSrc);
 	//initialize DataSource
 	var data = new IloOplDataSource("TSP_Data.dat");
 	//define boolean-variable which indictaes whether the actual solution is prohibited
 	var prohibited = true;
 	//while solution is prohibited, search for subtours to be eliminated
 	while(prohibited){
 		//create model instance 	
 	 	var model = new IloOplModel(modelDef, cplex);
 	 	//add data
 		model.addDataSource(data);
 		//set access on data
 		data = model.dataElements;
 		//generate model
 		model.generate();
 		
 		if(cplex.solve()){
 			
 		}else{
 			writeln("No solution!"); 
 			break;		
 		}
 		//conduct execute block
 		model.postProcess();
 		//If no subtour <= n/2 is found, solution is valid
 		if(model.shortest_subtour.size == 0){
 			prohibited = false; 		
 		}else{
 			//Otherwise, the shortest subtour found is eliminated 
 			//i.e. is added to set of subtours in data  		
 			data.subTours.add(data.subTours.size, model.shortest_subtour);
 			writeln("Subtour" + model.shortest_subtour + " is eliminated.");		
 		}		
 		
 	}	
 	//write output of optimal solution
	writeln();
	writeln("*****************************************************************");
	writeln("Optimal solution");
	writeln("*****************************************************************");
	writeln();
	writeln("Distance: " + cplex.getObjValue());
	writeln();
	writeln("Tour: ")
	write("1");
	
	var i = 1;
	var proceed = true;
	//nodes of the optimal tour are output in the following order
 	while(proceed){	 	 	
	 	for(var j in model.I){			
	 		if(model.x[i][j].solutionValue == 1){	 		 		
	 			i = j;
	 			write(" - " + i); 
	 			break; 	 		
	 		} 	 	
		}	 	 	
	 	if (i == 1){
	 		proceed = false;	 	
	 	}
 	} 	
 }
