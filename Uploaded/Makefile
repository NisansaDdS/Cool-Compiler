#
# Makefile for Cool compiler components 
#

LIB = ./lib
CUPHOME = $(LIB)
CUP = java -cp $(CUPHOME)/java-cup-11b.jar java_cup.Main 
CUPLIB = ./lib/java-cup-11b-runtime.jar
CLI = ./lib/commons-cli-1.2.jar

## Eventually we'll use all of these 
LIBS = $(CUPLIB):$(CLI)

# JAVACOPT =  -Xlint:unchecked 
JAVACOPT =  

all: Cool.class

#Creates the Converter Class
Converter: AdditionalSym.java sym.java NodeNameGen.java
	javac NodeNameGen.java
	java -classpath . NodeNameGen
	rm NodeNameGen.class

Cool.class: Converter CodeGenerator.java TypeChecker.java sym.java Support.java Scanner.java parser.java ErrorReport.java Cool.java ASTnode.java AdditionalSym.java Support.java 
	javac -classpath .:$(LIBS) Cool.java

run:
	java -classpath .:$(LIBS) Cool hello-world.cl
	clang -S -emit-llvm BasicClasses.c
	cat BasicClasses.ll gen.ll > fin.ll
	clang fin.ll
	./a.out


#=================

clean: 
	rm *.class
	rm *.ll





