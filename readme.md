This is a collection of helper functions used when implementing platforms for SUNRUSE.influx.  On requiring "sunruse-influx-platforms-helpers", you will get an object containing the following functions:

## makeUnary

### Given:
* String naming the function.
* String specifying the input primitive type by name.
* String specifying the output primitive type by name.
* Function taking the primitive value when the input is constant and returning a primitive constant for the output.
* Function stored as "generateCode" against the native function object; what this takes and returns is platform-specific.

### Returns:
* A native function object.

## makeOrderedBinary

### Given:
* String naming the function.
* String specifying the input primitive type by name.
* String specifying the output primitive type by name.
* Function taking the primitive value pair when the input is constant and returning a primitive constant for the output.
* Function stored as "generateCode" against the native function object; what this takes and returns is platform-specific.

### Returns:
A native function object specifying a binary operator where the order of the parameters changes the output; this takes:
	* a
	* b

## makeUnorderedBinary

### Given:
* String naming the function.
* String specifying the input primitive type by name.
* String specifying the output primitive type by name.
* Function taking the primitive value pair when the input is constant and returning a primitive constant for the output.
* Function stored as "generateCode" against the native function object; what this takes and returns is platform-specific.

### Returns:
* A native function object specifying a binary operator where the order of the parameters does not change the output; this takes:
	* a
	* b

## makeSwitch

### Given:
* String specifying the input/output primitive type by name.
* Function stored as "generateCode" against the native function object; what this takes and returns is platform-specific.

### Returns:
* A native function object specifying a "switch" function, taking:
	* a
	* b
	* on 
	
	And returning a when on is false, and b when on is true.
	
