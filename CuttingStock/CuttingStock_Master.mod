//number of different widths
int m = ...;
range I = 1..m;	

//definition of tupel, which models the different shelf allocations
tuple Shelf{
	key int index;
	int a[I]; //indicates the number of products in the shelf
}

//shelf width
float W = ...;

//possible widths
float width[I] = ...;

//demand 
int products[I] = ...;

//trivial patterns for start
{Shelf} shelfAllocation = ...;

//naming of contsraints to determine dual variables
constraint masterNB[I];

//array to store dual variables
float dualVar[I];

//Number of applied shelfs with shelf allocation j
dvar int+ x[shelfAllocation];

//minimize sum of all shelfs
minimize sum(j in shelfAllocation) x[j];

subject to{
	//constraint ensures that enough shelfs for products are used
	forall(i in I){
		masterNB[i]: sum(j in shelfAllocation)(x[j] * j.a[i]) == products[i];	
	}
}

execute{
	//store dual variables
	for(var i in I){
		dualVar[i] = masterNB[i].dual;
	}
}