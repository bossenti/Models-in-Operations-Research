 using CP;
 
 //data variables
 int numberEmSurg = ...; //number of emergency surgeries
 range N = 1..numberEmSurg; //create range for emergency surgeries
 
 int durationE[N] = ...; //durations of the single emergency surgery
 int TE[N] = ...; //type of the single emergeny surgery
 
 int numberOptSurg = ...; //number of optional surgeries
 range O = 1..numberOptSurg; //create range for optional surgeries
 
 int durationO[O]=...; //durations of the single optional surgery
 int TO[O]=...;	//type of the single optional surgery
 
 int shiftChange = ...; //duration of a shift change
 
 int numberSurgTypes = 3;	//number of distinct surgery types
 range type = 1..numberSurgTypes; //range of surgery types
 
  //definition transfer matrix
 tuple Gap{
 	int t1;
 	int t2;
 	int time; 
 };
 
 int interimPeriod [type][type] = ...; //interim periods between surgeries depending on type
 
 {Gap} M = {<i, j, interimPeriod[i][j]> | i in type, j in type}; //creation of transfer matrix
 int durationClean = 30; //duration of final cleaning
 
 //decision varibales
 dvar interval emSurg[n in N] in 0..600 size durationE[n];	//array of intervalls for each emergeny surgery with corresponding duration as size
 														//between 8am and 6pm (in minutes)
 dvar interval optSurg[o in O] optional in 0..600 size durationO[o]; //array of intervalls for each optional surgery with corresponding duration as size
																	  //between 8am and 6pm (in minutes)
 dvar interval cleaning in 540..660 size durationClean; //interval for final cleaning
 														  //between 5pm and 7pm (in minutes)
 
 dvar sequence scheduleE in emSurg types TE;	//sequence of all emergency surgeries with corresponding type
 dvar sequence scheduleO in optSurg types TO; //sequence of all optional surgeries with corresponding type
 
 maximize sum(o in O) presenceOf(optSurg[o]); //maximize number of performed optional surgeries (emergency surgeries has to be performed either)
 
 constraints{
  
 	noOverlap(scheduleE, M);	//emergency surgeries can not happen in parallel, in between buffer is planned according to transfer matrix
 	noOverlap(scheduleO, M); 	//optional surgeries can not happen in parallel, in between buffer is planned according to transfer matrix
 	
 	forall(n in N, o in O){
 		endBeforeStart(emSurg[n], optSurg[o], shiftChange); 	//No optional surgery may be performed before all emergency surgeries have taken place.
	} 																//buffer for shift change is recognized
 	
 	forall(o in O){													//final cleaning may only be carried out after the optional OPs have been performed.
 		endBeforeStart(optSurg[o], cleaning); 	
 	}
 	
 	forall (o1 in O, o2 in O){												//optional surgeries have to performed according to the ranking 	
 		if (o1 < o2) before(scheduleO, optSurg[o1], optSurg[o2]);	
 	}

 }
 
 execute{
   writeln("***************************************************************");  
   writeln("Surgery schedule");
   writeln("***************************************************************");
   writeln("Procedure of emergency surgeries:")
 
 	var s = scheduleE.first(); //start with first emergency surgery of sequence
 
 	while(true){
 	 	writeln(s.name + " is performed from " + Math.floor(s.start/60 + 8) + "h " + (s.start%60) + "min "+ "to " + Math.floor(s.end/60 + 8) + "h " + (s.end%60) + "min.");	
 	 	//print name of surgery, start and end of surgery 
 	 	if(-1 == Opl.typeOfNext(scheduleE,s,-1)){ //if s is last interval of sequence
 	 		break; 	 	//break
 	 	}
 	 	s = scheduleE.next(s); //assign s the next interval of the sequence
 	}
 	writeln("***************************************************************");
 	writeln("Procedure of optional surgeries:");
 	
 	var s = scheduleO.first();  //start with first optional surgery of sequence
 	
 	while(true){
 	 	writeln(s.name + " is performed from " + Math.floor(s.start/60 + 8) + "h " + (s.start%60) + "min "+ "to " + Math.floor(s.end/60 + 8) + "h " + (s.end%60) + "min.");	
 	 	//print name of surgery, start and end of surgery
 	 	if(-1 == Opl.typeOfNext(scheduleO,s,-1)){//if s is last interval of sequence
 	 		break; //break	 	
 	 	}
 	 	s = scheduleO.next(s);//assign s the next interval of the sequence
 	}
 	
 	writeln("***************************************************************"); 	
 	writeln("The operating room is cleaned from " + Math.floor(cleaning.start/60 + 8) + "h " + (cleaning.start%60) + "min "+ "to " + Math.floor(cleaning.end/60 + 8) + "h " + (cleaning.end%60) + "min.")
 	//print start and end of final cleaning
 }
 
 
 
 
 