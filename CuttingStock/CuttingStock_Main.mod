 main{
  
 	//create data source of CuttingStock_Shelves
 	var data = new IloOplDataSource("CuttingStock_Shelfs.dat");
 	
 	//create source and definition for master model
 	var masterSrc = new IloOplModelSource("CuttingStock_Master.mod");
 	var masterDef = new IloOplModelDefinition(masterSrc);
 	
 	//create source and definition for pricing model
 	var pricingSrc = new IloOplModelSource("CuttingStock_Pricing.mod");
 	var pricingDef = new IloOplModelDefinition(pricingSrc);
 	
 	//flag indicates whether reduced costs are negative
 	var reducedCostsNegative = true;
 	
 	//search for new shelf layouts as long as the reduced costs are negative
 	while (reducedCostsNegative){
 	 	
 	 	//create master problem and add data
	 	var master = new IloOplModel(masterDef, cplex);
	 	master.addDataSource(data);
	 	
	 	//generate master problem and relax it
	 	master.generate();
	 	master.convertAllIntVars();
	 	
	 	//store DataElements of master in variable
	 	data = master.dataElements;
	 	
	 	if(cplex.solve()){
	 		writeln("Relaxed solution of master problem: " + cplex.getObjValue() + " shelfs");	
	 	}else{
	 		writeln("No solution!");
	 		reducedCostsNegative = false;	 	
	 	}
	 	
	 	//process execute block
	 	master.postProcess();
	 	
	 	//store dual variables from master in temporary DataElements
	 	var dataPricing = new IloOplDataElements();
	 	dataPricing.dualVar = master.dualVar;
	 	
	 	//create pricing problem and add both data and dataPricing
	 	var pricing = new IloOplModel(pricingDef, cplex);
	 	pricing.addDataSource(data);
	 	pricing.addDataSource(dataPricing);
	 	
	 	//generate pricing problem
	 	pricing.generate();
	 	//add shelf allocation found to set of valid shelf allocations
	 	if(cplex.solve() && cplex.getObjValue() < 0){
	 		writeln("New shelf allocation from pricing problem: " + pricing.y.solutionValue);
	 		writeln();
	 		data.shelfAllocation.add(data.shelfAllocation.size + 1, pricing.y.solutionValue);	 			 	
	 	}else{ 
	 		//interrupt while loop
	 		writeln("No further solution with negative reduced costs!");
	 		writeln();
	 		reducedCostsNegative = false;	 	
 		}
	}
	
	//unrelaxed solution
 	var master = new IloOplModel(masterDef, cplex);
 	master.addDataSource(data);
 	
 	//generate master problem
 	master.generate();
 	
 	if(cplex.solve()){
 		//Output of optimal solution
 		writeln("__________________________________________________________________________");
 		writeln(""); 	
 		writeln("Optimal solution of master problem: " + cplex.getObjValue() + " shelfs");
 		writeln();
 		writeln("Applied shelf allocations: "); 		
 		
		//varibale for total waste
 		var waste = 0;
 		
 		for (var i in master.shelfAllocation){
 			 	//output of applied shelf allocation
 			 	if(master.x[i].solutionValue > 0){
 			 		writeln(master.x[i].solutionValue + " x " + i.a);
 			 		var width = 0;
 			 			//calculation of total waste
		 				for(var j = 1 ; j <= i.a.size ; j++){
 			 				width = width +  i.a[j] * master.width[j];
 			 			} 			 			
		 				waste = waste + (master.x[i].solutionValue * (master.W - width)); 			 						 	
 			 	} 			 					
 		}
 		//output of total waste
 		writeln("");
 		writeln("realized waste: " + waste);	
 	}else{
 		writeln("No solution!");	 	
 	}
} 	 	