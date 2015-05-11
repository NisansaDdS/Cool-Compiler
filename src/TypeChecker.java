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
            integer=Support.getClass("Int");
            string=Support.getClass("String");
            bool=Support.getClass("Bool");

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
        System.out.println("Read and load Attributes and Methods....");
        readMethodsAndAttributes();
        System.out.println("Attributes and Methods loading successful!");
        System.out.println("Start inheriting attributes....");
        inheritAttributes();
        System.out.println("Attribute inheritance done!");
        System.out.println("Start inheriting methods....");
        inheritMethods();
        System.out.println("Method inheritance done!");
        System.out.println("Start value checking attributes...");
        typecheckAttribues();
        System.out.println("Type checking attributes done!");
        System.out.println("Start value checking methods...");
        typecheckMethods();

       // printStatus();
    }

    private void typecheckMethods() throws Exception {
        Iterator<Support.CoolClass> itr=Support.getClassesIterator();
        while(itr.hasNext()) {
            Support.CoolClass c = itr.next();
            if (!c.basic) { //We do not have to bother about the builtin classes
                Iterator<String> itr1=c.methodList.keySet().iterator();
                while(itr1.hasNext()){
                    Support.CoolMethod m=c.methodList.get(itr1.next());
                    ASTnode thisNode=m.getNode();
                    if(thisNode!=null){
                        ASTnode exprNode = thisNode.rightChild;
                        if (exprNode != null) { //We are only going to bother about methods that have expressions in them. (Note: What about ones that have a return value but do not return?)
                            m.addParamsToLocalStack();
                            evaluateMethod(c, exprNode);
                        if(!isTypesConsistant(m.getNode().type,exprNode.type)){ //Checking the return value
                            throw(new Exception("Method '"+m.name+"' has value '"+m.getNode().type.name+"' but it is returning value '"+exprNode.type.name+"'"));
                        }
                        }
                    }
                    else{ //We should only let it pass if it is a un-overrriden basic method
                        if(!Support.basicMethods.containsKey(m.name)){
                            throw(new Exception("Method '"+m.name+"' has been overridden but not implimented"));
                        }
                    }
                }
            }
        }
    }

    private void evaluateMethod(Support.CoolClass c,ASTnode n) throws Exception {
        if(n!=null){
            if(n.nodeSignature==AdditionalSym.LIST) { //List of expressions
                evaluateMethod(c,n.leftChild); //There has to be atleast one element
                Support.CoolClass listType=n.leftChild.type;

            }
            else{
                System.out.println(Converter.getName(n.nodeSignature));
            }
        }
        else{
            throw(new Exception("AST is not correct. Invalid method node"));
        }
    }

    private void typecheckAttribues() throws Exception {
        Iterator<Support.CoolClass> itr=Support.getClassesIterator();
        while(itr.hasNext()) {
            Support.CoolClass c = itr.next();
            if(!c.basic){ //We do not have to bother about the builtin classes
                Iterator<String> itr1=c.attributes.keySet().iterator();
                while(itr1.hasNext()){
                    String attribName=itr1.next();
                    Support.CoolAttribute attrib=c.attributes.get(attribName);
                    ASTnode assignedVal=attrib.getNode().rightChild;
                    if(assignedVal!=null){ //Only need to check if the optional initialization is there
                        evaluateAttribute(assignedVal);
                        if(!isTypesConsistant(attrib.getNode().type,assignedVal.type)){
                            throw(new Exception("Attribute '"+attrib.name+"' has value '"+attrib.getNode().type.name+"' it cannot be set to value '"+assignedVal.type.name+"'"));
                        }
                    }
                }
            }
        }
    }

    private boolean isTypesConsistant(Object lhsO, Object rhsO) {
        Support.CoolClass lhs=(Support.CoolClass)lhsO;
        Support.CoolClass rhs=(Support.CoolClass)rhsO;

        while(true) {
            if (lhs == rhs) {
                return true;
            }
            else if(rhs==object){ //We have come to the top of the inheritance chain without a match
                return false;
            }

            rhs = rhs.getParent(); //Generalize rhs
        }
    }

    private void evaluateAttribute(ASTnode n) throws Exception {
        if(n!=null){
            if(n.nodeSignature==sym.INTLIT){
                SetNodeType(n,integer);
            }
            else if(n.nodeSignature==sym.STRINGLIT){
                SetNodeType(n,string);
            }
            else if(n.nodeSignature==sym.TRUE || n.nodeSignature==sym.FALSE){
                SetNodeType(n,bool);
            }
        }
        else{
            throw(new Exception("AST is not correct. Invalid attribute node"));
        }
    }

    private void SetNodeType(ASTnode n, Support.CoolClass c) {
        n.type =c;
    }

    private void printStatus() {
        Iterator<Support.CoolClass> itr=Support.getClassesIterator();
        while(itr.hasNext()) {
            Support.CoolClass c = itr.next();
            System.out.println(c.toString());
        }
    }

    private void inheritMethods(){
        Iterator<Support.CoolClass> itr=Support.getClassesIterator();
        while(itr.hasNext()) {
            Support.CoolClass c = itr.next();
            if(!c.isMethodsInherited()){
                inheritMethods(c);
            }
        }
    }

    private void inheritMethods(Support.CoolClass c) {
        Support.CoolClass p = c.getParent();

        if(p!=null) { //Object class has no parent
            if (!p.isMethodsInherited()) { //First check the parent and load
                inheritMethods(p);
            }
            //Methods are put only if they are not overridden.
            Iterator<String> itr=p.methodList.keySet().iterator();
            while(itr.hasNext()){
                String candidateMethodName=itr.next();
                if(!c.methodList.containsKey(candidateMethodName)){ //If it is not overridden
                    c.methodList.put(candidateMethodName,p.methodList.get(candidateMethodName)); //Add it
                }
            }
        }

    }

    private void inheritAttributes(){
        Iterator<Support.CoolClass> itr=Support.getClassesIterator();
        while(itr.hasNext()) {
            Support.CoolClass c = itr.next();
            if(!c.isAttributesInherited()){
                inheritAttributes(c);
            }
        }
    }

    private void inheritAttributes(Support.CoolClass c) {
        Support.CoolClass p = c.getParent();

        if(p!=null) { //Object class has no parent
            if (!p.isAttributesInherited()) { //First check the parent and load
                inheritAttributes(p);
            }
            //Now put all the attributes of the parent into this class
            c.attributes.putAll(p.attributes);
        }
    }


    private void readMethodsAndAttributes() throws Exception {
        Iterator<Support.CoolClass> itr=Support.getClassesIterator();
        while(itr.hasNext()) {
            Support.CoolClass c = itr.next();
            if(!c.isMethodsAndAttributesLoaded()) { //This class might have already loaded its methods and attributes loaded because it is a super class of a previous class.
                readMethodsAndAttributes(c); //If not load for this class
            }
        }
    }

    private  void readMethodsAndAttributes(Support.CoolClass c) throws Exception {
        Support.CoolClass p = c.getParent();
        if (!p.isMethodsAndAttributesLoaded()) { //First check the parent and load
            readMethodsAndAttributes(p);
        }

        //Now load the attributes and methods of own class
        ASTnode n = c.getNode();
        if (n != null && n.rightChild != null) { //Right child of a class is the set of features
            readMethodsAndAttributes(c, n.rightChild);
        }
    }

    private  void readMethodsAndAttributes(Support.CoolClass c,ASTnode node) throws Exception {
        if (node != null) {
            if(node.nodeSignature==AdditionalSym.ATTRIBUTE){
                String atrName=(String)node.leftChild.leftChild.value; //Identifier
                Support.CoolClass type=Support.getClass((String) node.leftChild.rightChild.value); //Type name
                Support.CoolAttribute attrib=new Support.CoolAttribute(atrName,type);
                attrib.setNode(node);
                node.value =type; //Setting the value of the node!!!
                c.addAttribute(attrib);
            }
            else if(node.nodeSignature==AdditionalSym.METHOD_BLOCK){
                String methName=(String)node.leftChild.leftChild.value; //Identifier
                String typeName="";

                //Handle SELF_TYPE
                if(((String)node.leftChild.rightChild.value).equalsIgnoreCase("SELF_TYPE")){
                    typeName=(String)c.getNode().value;
                }
                else{
                    typeName=(String) node.leftChild.rightChild.value;
                }

                Support.CoolClass type=Support.getClass(typeName); //Type name (Return value)
                Support.CoolMethod meth=new Support.CoolMethod(methName,type);
                meth.setNode(node);
                if(node.middleChild!=null){
                    readParameters(meth,node.middleChild);
                }
                node.value =type;  //Setting the value of the node!!!
                c.addMethod(meth);
            }
            else if (node.nodeSignature==AdditionalSym.LIST) { //This is a list of methods and/or attributes
                readMethodsAndAttributes(c,node.leftChild);
                readMethodsAndAttributes(c,node.rightChild);
            }
            else{
                throw(new Exception("AST is not correct. Expected "+Converter.getName(AdditionalSym.ATTRIBUTE)+" or "+Converter.getName(AdditionalSym.METHOD_BLOCK)+" or "+Converter.getName(AdditionalSym.LIST)+" but found "+Converter.getName(node.nodeSignature)));
            }
        }
        else{
            //Both attributes and methods are optional so them being NULL is not an error
        }
    }

    private void readParameters(Support.CoolMethod meth, ASTnode node) throws Exception {
        if (node != null) {
            if(node.nodeSignature==AdditionalSym.ID_TYPE){
                String name=(String)node.leftChild.value; //Identifier
                Support.CoolClass type=Support.getClass((String) node.rightChild.value); //Type name
                meth.parametres.add(new Support.CoolAttribute(name,type));
            }
            else if(node.nodeSignature==AdditionalSym.LIST){
                readParameters(meth, node.leftChild);
                readParameters(meth, node.rightChild);
            }
            else{
                throw(new Exception("AST is not correct. Expected "+Converter.getName(AdditionalSym.ID_TYPE)+" or "+Converter.getName(AdditionalSym.LIST)+" but found "+Converter.getName(node.nodeSignature)));
            }
        }
        else{
            //Unreachable. This block is here just to be sure
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
                addClass((String)node.value, node); //The value of a class is the class name
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
                Support.CoolClass thisClass=Support.getClass((String)node.value);
                if(node.leftChild!=null && node.leftChild.nodeSignature==sym.INHERITS){ //Inherit option is present
                    ASTnode pDetails=node.leftChild;
                    //First check to see if extending has been done on a non allowed class
                    if(pDetails.value.equals("Int")||pDetails.value.equals("Bool")||pDetails.value.equals("String")){
                        throw(new Exception("Class "+node.value +" is trying to extend "+pDetails.value +". It is illigal"));
                    }
                    Support.CoolClass parentClass=Support.getClass((String)pDetails.value);
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
