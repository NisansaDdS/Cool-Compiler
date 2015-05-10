del Scanner.java
del parser.java
del sym.java
del Converter.java
del *.class

java -jar JFlex.jar Cool.jflex --skel jflex-skeleton-nested Cool.jflex
java -cp java-cup-11b.jar java_cup.Main  -locations Cool.cup

javac NodeNameGen.java
java -classpath . NodeNameGen

del NodeNameGen.class


javac ErrorReport.java sym.java AdditionalSym.java Converter.java ASTnode.java Scanner.java ScanDriver.java -classpath ./java-cup-11b-runtime.jar;./JFlex.jar;./commons-cli-1.2.jar 

jar cf test.jar ErrorReport.class sym.class AdditionalSym.class Converter.class ASTnode.class Scanner.class ScanDriver.class
