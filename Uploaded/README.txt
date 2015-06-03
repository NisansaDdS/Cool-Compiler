Code Generator

*This generates new user-defined classes with methods, it does inherit and override methods.
*This uses some Cool built-in methods

......................................................

How To Build

* Run the MakeFile
* Please note that as per our discussion about the starnge bug in CUP, this MakeFile will not re-generate the Parser.java, sym.java, Scanner.java (i.e. This MakeFile assumes that they are already there.)

........................................................

How To Test

* I have added an inbuilt testing instance to the makefile. It generates code for a simple hello-world.cl. 

...............................................................

Live Demo

A live demo is available on my IX as well. The URL is; https://ix.cs.uoregon.edu/~nisansa/CodeSamples/Compiler/
But ix does not have clang so you cannot run that part there.

$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
TypeChecker

* This covers all the scenarios in https://piazza.com/class/i7dughpewipz?cid=78
* I belive it is an axhastive list of things to cover.
* I have included Powr.cl which has all the Cool constructs for testing purposes. 

......................................................

How To Build

* Run the MakeFile
* Please note that as per our discussion about the starnge bug in CUP, this MakeFile will not re-generate the Parser.java, sym.java, Scanner.java (i.e. This MakeFile assumes that they are already there.)

........................................................

How To Test

* I have added an inbuilt testing instance to the makefile. It typechecks Powr.cl. 
* You can give your own cool files to test as well. 
* I have uploded the following correct coolfiles to my GitHub repo for testing
	+ https://github.com/NisansaDdS/Cool-Compiler/blob/master/fib.cl
	+ https://github.com/NisansaDdS/Cool-Compiler/blob/master/hairyscary.cl
	+ https://github.com/NisansaDdS/Cool-Compiler/blob/master/power.cl
	+ https://github.com/NisansaDdS/Cool-Compiler/blob/master/Tree.cl

...............................................................

Live Demo

A live demo is available on my IX as well. The URL is; https://ix.cs.uoregon.edu/~nisansa/CodeSamples/Compiler/