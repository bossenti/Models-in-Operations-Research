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

//dual variables
float dualVar[I]=...;

//trivial patterns for start
{Shelf} shelfAllocation = ...;
 
//number of product i in new shelf allocation
dvar int+ y[I];

//minimize reduce costs
minimize 1 - sum (i in I)(dualVar[i]*y[i]);

subject to{
	//width of shelf must not be exceeded
	sum(i in I) width[i]*y[i] <= W;
}