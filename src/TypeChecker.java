import java.util.ArrayList;
import java.util.HashMap;
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
    
    boolean verbose=false;

    public TypeChecker(ASTnode root,boolean verbose) {
        this.root = root;
        this.verbose=verbose;

        try {
            sup = Support.getSupport();
        } catch (Exception e) {
            System.err.println("Could not initialize support");
            System.err.println(e.getMessage());
        }


        try {
            object = Support.getClass("Object");
            io = Support.getClass("IO");
            integer=Support.getClass("Int");
            string=Support.getClass("String");
            bool=Support.getClass("Bool");

            typecheck();

        } catch (Exception e) {
            System.err.println("Typecheck Failed!");
            System.err.println(e.getMessage());
            e.printStackTrace();
        }

    }
    
    public void output(String s){
        if(verbose){
            System.err.println("# "+s);
        }
    }

    public void typecheck() throws Exception {
        System.out.println("Type Checking Started ...");
        output("Read and load Classes....");
        readClasses(root);
        output("Setting up inheritance");
        setUpInheritance(root);
        output("Check for inheritance cycles");
        checkCycles();
        output("Read and load Attributes and Methods....");
        readMethodsAndAttributes();
        output("Start inheriting attributes....");
        inheritAttributes();
        output("Start inheriting methods....");
        inheritMethods();
        output("Start Type checking attributes...");
        typecheckAttribues();
        output("Start Type checking methods...");
        typecheckMethods();
        output("Start checking the Main class...");
        checkMainClass();
        System.out.println("Type Checking done!");

        printStatus();
    }

    private void checkMainClass() throws Exception {
        Support.CoolClass main=Support.getClass("Main");
        if(main!=null){
            Support.CoolMethod m=main.methodList.get("main");
            if(m==null){
                throw(new Exception("No 'main' Method found in the 'Main' class."));
            }
            else{
                if(m.parametres.size()!=0){
                    throw(new Exception("The 'main' Method cannot have any parameters (arguments)."));
                }
            }
        }
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
                    if(thisNode!=null) {
                        ASTnode exprNode = thisNode.rightChild;
                        if (exprNode != null) { //We are only going to bother about methods that have expressions in them. (Note: What about ones that have a return value but do not return?)
                            Support.addParamsToLocalStack(m);
                            evaluate(c, exprNode);

                            //Evaluate SELF_TYPE
                            if(exprNode.type==Support.selftype){
                                exprNode.type=c;
                            }



                           // output("Method '" + m.name + "' has to return type " +m.getNode().type.name+" "+exprNode.type.name+" "+Converter.getName(exprNode.nodeSignature));
                            if (!isTypesConsistant(m.getNode().type, exprNode.type)) { //Checking the return value
                                throw (new Exception("Method '" + m.name + "' has to have return type '" + m.getNode().type.name + "' but it is returning type '" + exprNode.type.name + "'"));
                            }
                            Support.removeParamsFromLocalStack(m);
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

    private Support.CoolClass evaluate(Support.CoolClass c, ASTnode n) throws Exception {
        if(n!=null){
           // output("EvalM "+Converter.getName(n.nodeSignature));

            //Attribute section
            if(n.nodeSignature==sym.INTLIT){
                return SetNodeType(n, integer);
            }
            else if(n.nodeSignature==sym.STRINGLIT){
                return SetNodeType(n, string);
            }
            else if(n.nodeSignature==sym.TRUE || n.nodeSignature==sym.FALSE){
                return SetNodeType(n,bool);
            }

            //Method section
            else if(n.nodeSignature==AdditionalSym.LIST) { //List of expressions
                evaluate(c, n.leftChild); //There has to be atleast one element
                Support.CoolClass listType=n.leftChild.type;

                //Optionals
                if(n.rightChild!=null){
                    listType=EvaluateList(c,n.rightChild);
                }
                return SetNodeType(n, listType);
            }
            else if(n.nodeSignature==sym.LET){
                letVarNames.clear();
                addLocalVarsFromLet(c,n.leftChild);
                evaluate(c, n.rightChild);
                Support.removeParamsFromLocalStack(letVarNames);
                return SetNodeType(n, n.rightChild.type);
            }
            else if(n.nodeSignature==AdditionalSym.INVOKE){
               // typeCheckMethodParams(c, n.rightChild);
                Support.CoolClass mc=c; //Method owner class
                if(n.leftChild!=null){ //Owner is not this class. A name of another class was given
                    evaluate(c,n.leftChild);
                    mc=n.leftChild.type;
                }

                if(n.middleChild!=null){ //Optional [@TYPE] was set
                    Support.CoolClass tyC=Support.getClass((String)n.middleChild.value);
                    if(tyC!=null) {
                        if(!isTypesConsistant(tyC,mc)){
                            throw(new Exception("Casted class '"+tyC.name+"' is not compatible with the class type '"+mc.name+"'."));
                        }
                    }
                    mc=tyC;
                }
                Support.CoolMethod m= mc.methodList.get(n.value); //Get the relevant method
                if(m==null){
                    throw(new Exception("Class '"+mc.name+"' does not have a method named '"+n.value+"'."));
                }

                typeCheckMethodParams(c, n.rightChild);
                ArrayList<Support.CoolClass> paramTypes=getParamTypes(n.rightChild);

                //See if the count of params are correct
                if(paramTypes.size()!=m.parametres.size()){
                    throw(new Exception("Trying to call method '"+m.name+"' with wrong number of parameters."));
                }

                for (int i = 0; i <paramTypes.size() ; i++) {
                    if(!isTypesConsistant(m.parametres.get(i).type,paramTypes.get(i))){
                        throw(new Exception("Argument "+i+" was expected to be of type '"+m.parametres.get(i).type.name+"' but was given type '"+paramTypes.get(i).name+"'."));
                    }
                }
                return SetNodeType(n,m.type);
            }
            else if(n.nodeSignature==sym.NEW){
                return SetNodeType(n, Support.getClass((String)n.value));
            }
            else if(n.nodeSignature==sym.ASSIGN){
                Support.CoolClass lhs=evaluate(c,n.leftChild);
                Support.CoolClass rhs=evaluate(c,n.rightChild);
                if(!isTypesConsistant(lhs,rhs)){
                    throw(new Exception("Expression of type '"+rhs.name+"' cannot be assigned to variables of type '"+lhs.name+"'"));
                }
                return SetNodeType(n, n.rightChild.type);
            }
            else if(n.nodeSignature==sym.ID){
                String id=(String)n.value;
                Support.CoolClass cl=object;
                if(id.equalsIgnoreCase("self")){
                    cl=c;
                }
                else{
                    cl=Support.getFromLocalStack(id);
                }

                if(cl==null){ //Not found in local scope. Now try class scope
                    Support.CoolAttribute ca=c.attributes.get(id);
                    if(ca==null){
                        throw(new Exception("Identifier '"+id+"' was not found in current scope"));
                    }
                    else {
                        cl = ca.type;
                    }
                }
                return SetNodeType(n, cl);
            }
            else if(n.nodeSignature==sym.WHILE){
                evaluateCondition(c, n.leftChild);
                evaluate(c,n.rightChild);
                return SetNodeType(n,object); //While does not have a type!
            }
            else if(n.nodeSignature==sym.LT || n.nodeSignature==sym.LEQ){
                evaluate(c,n.leftChild);
                if(n.leftChild.type!=integer){
                    throw(new Exception("Left side of comparison has to be Int; not '"+n.leftChild.type.name+"'"));
                }
                evaluate(c,n.rightChild);
                if(n.rightChild.type!=integer){
                    throw(new Exception("Right side of comparison has to be Int; not '"+n.rightChild.type.name+"'"));
                }
                return SetNodeType(n,bool);
            }
            else if(n.nodeSignature==sym.MINUS || n.nodeSignature==sym.PLUS|| n.nodeSignature==sym.TIMES|| n.nodeSignature==sym.DIV){
                evaluate(c,n.leftChild);
                if(n.leftChild.type!=integer){
                    throw(new Exception("Left side of "+Converter.getName(n.nodeSignature)+" has to be Int; not '"+n.leftChild.type.name+"'"));
                }
                evaluate(c,n.rightChild);
                if(n.rightChild.type!=integer){
                    throw(new Exception("Right side of "+Converter.getName(n.nodeSignature)+" has to be Int; not '"+n.rightChild.type.name+"'"));
                }
                return SetNodeType(n,integer);
            }
            else if(n.nodeSignature==sym.IF){
                evaluateCondition(c, n.leftChild);
                evaluate(c,n.middleChild);
                evaluate(c,n.rightChild);
                Support.CoolClass minComAn=(Support.CoolClass)(GetMinimumCommonAncesstor(n.middleChild.type,n.rightChild.type)[0]);
                return SetNodeType(n,minComAn);
            }
            else if(n.nodeSignature==sym.EQ){
                evaluate(c,n.leftChild);
                evaluate(c,n.rightChild);
                if((n.leftChild.type==integer && n.rightChild.type!=integer)||(n.leftChild.type!=integer && n.rightChild.type==integer)){
                    throw(new Exception("Integers can only be compared to Integers"));
                }
                else if((n.leftChild.type==string && n.rightChild.type!=string)||(n.leftChild.type!=string && n.rightChild.type==string)){
                    throw(new Exception("Strings can only be compared to Strings"));
                }
                else if((n.leftChild.type==bool && n.rightChild.type!=bool)||(n.leftChild.type!=bool && n.rightChild.type==bool)){
                    throw(new Exception("Bools can only be compared to Bools"));
                }
                return SetNodeType(n,bool);
            }
            else if(n.nodeSignature==sym.CASE) {
                evaluate(c,n.leftChild); //Case condition
      /*          if(n.leftChild.nodeSignature==sym.ISVOID){ // Note: Is this how to check this?
                    throw(new Exception("Case condition cannot be void"));
                }*/
                ArrayList<Support.CoolClass[]> caseTypes=getCaseTypes(c,n.rightChild);
                int min=Integer.MAX_VALUE;
                Support.CoolClass select=null;

                for (int i = 0; i <caseTypes.size() ; i++) {
                 //  if(isTypesConsistant(n.leftChild.type, caseTypes.get(i)[0])) {
                        Object[] result = GetMinimumCommonAncesstor(n.leftChild.type, caseTypes.get(i)[0]);
                        int val = (Integer) result[1];
                        if (min > val) {
                            min = val;
                            select = caseTypes.get(i)[1];
                        }
                  //  }
                }
                if(select==null){
                    throw(new Exception("No valid case found"));
                }
                return SetNodeType(n,select);
               // return SetNodeType(n,object); //Case does not have a type!
            }
            else if(n.nodeSignature==sym.ISVOID) {
                evaluate(c,n.leftChild);
                return SetNodeType(n,bool);
            }
            else if(n.nodeSignature==sym.NOT) {
                evaluate(c,n.leftChild);
                if(n.leftChild.type!=bool){
                    throw(new Exception("Only bools can be given to the NOT operator. But was given '"+n.leftChild.type.name+"'"));
                }
                return SetNodeType(n,bool);
            }
            else if(n.nodeSignature==sym.NEG) {
                evaluate(c,n.leftChild);
                if(n.leftChild.type!=integer){
                    throw(new Exception("Only integers can be given to the ~ operator. But was given '"+n.leftChild.type.name+"'"));
                }
                return SetNodeType(n,integer);
            }
            else{
                throw(new Exception("Node type with index "+n.nodeSignature+" is unhandled")); //Technically, this line is unreachable
            }
        }
        else{
            throw(new Exception("AST is not correct. Invalid method node"));
        }
    }

    private ArrayList<Support.CoolClass[]> getCaseTypes(Support.CoolClass c, ASTnode n) throws Exception {
        ArrayList<Support.CoolClass[]> list=new ArrayList<Support.CoolClass[]>();
        if(n!=null){
            if(n.nodeSignature==AdditionalSym.LIST){
                list.addAll(getCaseTypes(c,n.leftChild));
                list.addAll(getCaseTypes(c, n.rightChild));
            }
            else if(n.nodeSignature==sym.RIGHTARROW){
                String name = (String) n.leftChild.leftChild.value; //id
                Support.CoolClass type=Support.getClass((String)n.leftChild.rightChild.value);
                Support.addParamsToLocalStack(name,type);
                evaluate(c,n.rightChild);
                Support.removeParamFromLocalStack(name);
                list.add(new Support.CoolClass[]{type,n.rightChild.type}); //Element [0] to take decision Element [1] to set type

                //list.add(type);   //Note: Which one is correct?
            }
        }
        return list;
    }

    private Object[] GetMinimumCommonAncesstor(Support.CoolClass a, Support.CoolClass b) {
        int height=0;
        if(a==b){
            return new Object[]{a,height};
        }

        HashSet<Support.CoolClass> encountered=new HashSet<Support.CoolClass>();
        encountered.add(a);
        encountered.add(b);
        while(true){
            height++;
            a=a.getParent();
            if(encountered.contains(a)){
                return new Object[]{a,height};
            }
            encountered.add(a);

            b=b.getParent();
            if(encountered.contains(b)){
                return new Object[]{b,height};
            }
            encountered.add(b);
        }
    }

    private void evaluateCondition(Support.CoolClass c, ASTnode n) throws Exception {
        evaluate(c,n); //Evaluate the condition
        if(n.type!=bool){
            throw(new Exception("Loop condition has to be Bool; not '"+n.type.name+"'"));
        }
    }

    private ArrayList<Support.CoolClass> getParamTypes(ASTnode n) {
        ArrayList<Support.CoolClass> list=new ArrayList<Support.CoolClass>();
        if(n!=null){
            if(n.nodeSignature==AdditionalSym.ITEMS){
                list.addAll(getParamTypes(n.leftChild));
                list.addAll(getParamTypes(n.rightChild));
            }
            else{
                list.add(n.type);
            }
        }
        return list;
    }

    private void typeCheckMethodParams(Support.CoolClass c, ASTnode n) throws Exception {
        if(n!=null){
            if(n.nodeSignature==AdditionalSym.ITEMS){
                typeCheckMethodParams(c,n.leftChild);
                typeCheckMethodParams(c,n.rightChild);
            }
            else{
                evaluate(c,n);
            }
        }
    }

    ArrayList<String> letVarNames=new ArrayList<String>();

    private void addLocalVarsFromLet(Support.CoolClass c, ASTnode n) throws Exception {
        if(n!=null){
            if(n.nodeSignature==AdditionalSym.ITEMS){
                addLocalVarsFromLet(c,n.leftChild);
                addLocalVarsFromLet(c,n.rightChild);
            }
            else if (n.nodeSignature==sym.ASSIGN){
                Support.CoolClass type=Support.getClass((String)n.leftChild.rightChild.value); //Value is the type
                String name=(String)n.leftChild.leftChild.value;
                if(n.rightChild!=null){ //If the optional initialization is used
                    evaluate(c, n.rightChild);
                    if(!isTypesConsistant(type,n.rightChild.type)){
                        throw(new Exception("In the LET expression, attribute '"+name+"' has value '"+type.name+"' it cannot be set to value '"+n.rightChild.type.name+"'"));
                    }
                }
                Support.addParamsToLocalStack(name,type);
                letVarNames.add(name);
            }
        }
    }

    private Support.CoolClass EvaluateList(Support.CoolClass c, ASTnode n) throws Exception {
        if(n!=null){
            if(n.nodeSignature==AdditionalSym.LIST){
                Support.CoolClass lhs=EvaluateList(c, n.leftChild);
                Support.CoolClass rhs=EvaluateList(c, n.rightChild);
                if(rhs!=null){
                    return rhs;
                }
                else{
                    return  lhs;
                }
            }
            else{
                evaluate(c, n);
                return n.type;
            }
        }
        return null;
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
                        evaluate(c, assignedVal);
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



    private Support.CoolClass SetNodeType(ASTnode n, Support.CoolClass c) {
        n.type =c;
        return c;
    }

    private void printStatus() {
        Iterator<Support.CoolClass> itr=Support.getClassesIterator();
        while(itr.hasNext()) {
            Support.CoolClass c = itr.next();
            output(c.toString());
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
                   /* Support.CoolMethod cm=new Support.CoolMethod(p.methodList.get(candidateMethodName)); //clone it
                    cm.setParent(c); //set this to patent (For the use of SELF_TYPE)
                    cm.setImplimetedIn(p.methodList.get(candidateMethodName).getImplimetedIn()); //Where the implimetation is from
                    c.methodList.put(candidateMethodName,cm); //Add it   p.methodList.get(candidateMethodName)
                    */
                    c.methodList.put(candidateMethodName,p.methodList.get(candidateMethodName));
                }
                else{ //update the vtable position of the overridenmethod
                    Support.CoolMethod childCM=c.methodList.get(candidateMethodName); //This is the child class method
                    Support.CoolMethod parentCM=p.methodList.get(candidateMethodName); //This is the parent calss method;
                    childCM.vtable_position=parentCM.vtable_position;
                }
            }
        }
        //Now get the max vtable_position from parents
        int index=Integer.MIN_VALUE;
        Iterator<String> itr=c.methodList.keySet().iterator();
        while(itr.hasNext()) {
            String methodName = itr.next();
            index=Math.max(index,c.methodList.get(methodName).vtable_position);
        }

        index++;

        //Now set vtable_position for the methods that are new to this class
        itr = c.methodList.keySet().iterator();
        while(itr.hasNext()) {
            String methodName = itr.next();
            Support.CoolMethod cm = c.methodList.get(methodName);
            if (cm.vtable_position < 0) {
                cm.vtable_position = index;
                index++;
            }

            // if(p==null){
            //    System.out.println("AAAAAA "+cm.name+" "+cm.vtable_position);
            //}
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
        HashMap<String,Support.CoolAttribute> inheritedAttr=new HashMap<String,Support.CoolAttribute>();

        if(p!=null) { //Object class has no parent
            if (!p.isAttributesInherited()) { //First check the parent and load
                inheritAttributes(p);
            }

            inheritedAttr.putAll(p.attributes);
        }

        //Arrtibutes that are unique to this class are given vtable values that are AFTER the ones that were inherited
        int index=inheritedAttr.size();
        Iterator<String> itr=c.attributes.keySet().iterator();
        while(itr.hasNext()){
            String key=itr.next();
            Support.CoolAttribute ca=c.attributes.get(key);
            ca.vtable_position=index;
            index++;
        }

        //Now put all the attributes of the parent into this class
        c.attributes.putAll(inheritedAttr);

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
                node.type =type; //Setting the value of the node!!!
                c.addAttribute(attrib);
            }
            else if(node.nodeSignature==AdditionalSym.METHOD_BLOCK){
                String methName=(String)node.leftChild.leftChild.value; //Identifier
                String typeName="";

                //Handle SELF_TYPE
                if(((String)node.leftChild.rightChild.value).equalsIgnoreCase("SELF_TYPE")){
                    typeName=c.name;
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
                node.type =type;  //Setting the value of the node!!!
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
            else if(node.nodeSignature==AdditionalSym.ITEMS){
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
                output("    Parent of " + thisClass.name + " is " + thisClass.getParent().name);
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
        output("    Class " + c.name + " added");
    }


}
