del Scanner.java
del parser.java
del sym.java

java -jar JFlex.jar Cool.jflex --skel jflex-skeleton-nested Cool.jflex
java -cp java-cup-11b.jar java_cup.Main  -locations Cool.cup