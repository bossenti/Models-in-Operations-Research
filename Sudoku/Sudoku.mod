 using CP;
 
 //data variables
 range I = 1..9; //range for comlumns, rows and permitted values
 int initialOccupancy[I][I]=...; //initial occupancy, free cells are assigned with 0
 
 //decision variables
 dvar int cells[I][I] in I; //indicates which digit is stored in which cell
 
 constraints{
 	
 	//each digit only once in each row 
 	forall(i in I){
 		allDifferent(all(j in I)cells[i][j]);
 	} 
 	
 	//each digit only once in each column 
 	forall(j in I){
 		allDifferent(all(i in I)cells[i][j]);	
 	} 
 	
 	//each digit only once in each 3x3 matrix
 	forall(k,l in 0..2){
 		allDifferent(all(i in (1+3*k) .. (3+3*k),j in (1+3*l) .. (3+3*l))cells[i][j]);	
 			
 	}
 	
 	//initialOccupancy 
 	forall(i,j in I){
 		if(initialOccupancy[i][j]>0){
 			cells[i][j] == initialOccupancy[i][j]; 		
 		} 	
 	}
 }
 
 //Output
 execute{
 	writeln("Solution:");
 	writeln();
 	
 	for(var i in I){
 		for(var j in I){
 			write(cells[i][j] + " "); 
 			
 			//after three columns a vertical line (except from last one)
 			if(j % 3 == 0 && j<9){
 				write("| "); 			
 			}		
 		} 	
 		
 		writeln();
 		
 		//after three rows a horizontal line (except from last one)
 		if(i % 3 == 0 && i<9){		
 			writeln("-----------------------");		
 		}
 	} 
 }