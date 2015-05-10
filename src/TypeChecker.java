import com.sun.org.apache.xpath.internal.SourceTree;

import java.util.HashSet;
import java.util.Iterator;

/**
 * Created by Nisansa on 15/05/09.
 */
public class TypeChecker {
    ASTnode root;
    Support sup = null;

    //Built in Classes for reference
    Support.CoolClass object;
    Support.CoolClass io;
    Support.CoolClass integer;
    Support.CoolClass string;
    Support.CoolClass bool;

    public TypeChecker(ASTnode root) {
        this.root = root;

        try {
            sup = Support.getSupport();
            object = Support.getClass("Object");
            io = Support.getClass("IO");
            Support.getClass("Int");
            Support.getClass("String");
            Support.getClass("Bool");

            typecheck();
        } catch (Exception e) {
            System.err.println("Typecheck Failed!");
            System.err.println(e.getMessage());
        }

    }

    public void typecheck() throws Exception {
        System.out.println("Read and load Classes....");
        readClasses(root);
        System.out.println("Class loading successful!");
        System.out.println("Setting up inheritance");
        setUpInheritance(root);
        System.out.println("Finished setting up inheritance");
        System.out.println("Check for inheritance cycles");
        checkCycles();
        System.out.println("Finished Checking for inheritance cycles");
        System.out.println("Read and load Attributes....");
    }

    private void readMethodsAndAttributes() throws Exception {
        Iterator<Support.CoolClass> itr=Support.getClassesIterator();
        while(itr.hasNext()) {
            Support.CoolClass c = itr.next();
            ASTnode n=c.getNode();
            if(n!=null && n.rightChild!=null){ //Right child of a class is the set of features
                readMethodsAndAttributes(c,n.rightChild);
            }
        }
    }

    private  void readMethodsAndAttributes(Support.CoolClass c,ASTnode node) throws Exception {
        if (node != null) {
            if(node.nodeSignature==AdditionalSym.ATTRIBUTE){

            }
            else if(node.nodeSignature==AdditionalSym.METHOD_BLOCK){

            }
        }
        else{
            throw(new Exception("Class root not detected"));
        }
    }


    private void checkCycles() throws Exception {
        HashSet<Support.CoolClass> checkedList=new HashSet<Support.CoolClass>();
        checkedList.add(object);

        HashSet<Support.CoolClass> uncheckedList=new HashSet<Support.CoolClass>();
        Iterator<Support.CoolClass> itr=Support.getClassesIterator();
        while(itr.hasNext()){
            Support.CoolClass c=itr.next();
            if(c.name!="Object"){
                uncheckedList.add(c);
            }
        }

        HashSet<Support.CoolClass> uncheckedBackupList=new HashSet<Support.CoolClass>();
        boolean checkeListModified=false;

        do {
            checkeListModified=false;
            itr = uncheckedList.iterator();
            while (itr.hasNext()) {
                Support.CoolClass c = itr.next();
                if (checkedList.contains(c.getParent())) {
                    checkedList.add(c);
                    checkeListModified = true;
                } else {
                    uncheckedBackupList.add(c);
                }
            }
            uncheckedList.clear();
            uncheckedList.addAll(uncheckedBackupList);
            uncheckedBackupList.clear();
        }while(!uncheckedList.isEmpty() && checkeListModified);

        if(!uncheckedList.isEmpty()){ //We have found a cycle
            throw(new Exception("Inheritance Cycle found!")); //LoL :-D
        }

    }


    private void readClasses(ASTnode node) throws Exception {
        if (node != null) {
            if(node.nodeSignature==sym.CLASS){
                addClass((String)node.type, node); //The type of a class is the class name
            }
            else if(node.nodeSignature==AdditionalSym.LIST){ //This is a list of classes
                readClasses(node.leftChild);
                readClasses(node.rightChild);
            }
            else{
                throw(new Exception("AST is not correct. Expected "+Converter.getName(sym.CLASS)+" or "+Converter.getName(AdditionalSym.LIST)+" but found "+Converter.getName(node.nodeSignature)));
            }
        }
        else{
            throw(new Exception("Program root not detected"));
        }
    }

    private void setUpInheritance(ASTnode node) throws Exception {
        if (node != null) {
            if(node.nodeSignature==sym.CLASS){
                Support.CoolClass thisClass=Support.getClass((String)node.type);
                if(node.leftChild!=null && node.leftChild.nodeSignature==sym.INHERITS){ //Inherit option is present
                    ASTnode pDetails=node.leftChild;
                    //First check to see if extending has been done on a non allowed class
                    if(pDetails.type.equals("Int")||pDetails.type.equals("Bool")||pDetails.type.equals("String")){
                        throw(new Exception("Class "+node.type+" is trying to extend "+pDetails.type+". It is illigal"));
                    }
                    Support.CoolClass parentClass=Support.getClass((String)pDetails.type);
                    thisClass.setParent(parentClass);
                }
                else{ //No inherit option, so inherit from object class
                    thisClass.setParent(object);
                }
                System.out.println("    Parent of "+thisClass.name+" is "+thisClass.getParent().name);
            }
            else if(node.nodeSignature==AdditionalSym.LIST){ //This is a list of classes
                setUpInheritance(node.leftChild);
                setUpInheritance(node.rightChild);
            }
            else{
                throw(new Exception("AST is not correct. Expected "+Converter.getName(sym.CLASS)+" or "+Converter.getName(AdditionalSym.LIST)+" but found "+Converter.getName(node.nodeSignature)));
            }
        }
        else{
            throw(new Exception("Program root not detected"));
        }
    }

    protected void addClass(String name, ASTnode node) throws Exception {
        Support.CoolClass c= Support.addClass(name);
        c.setNode(node);
        System.out.println("    Class "+c.name+" added");
    }


}
