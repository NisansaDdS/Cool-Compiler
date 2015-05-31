import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

/**
 * Created by Nisansa on 15/05/09.
 */
public class Support {

    private static HashMap<String, CoolClass> classes = new HashMap<String, CoolClass>();
    public static HashMap<String, CoolMethod> basicMethods = new HashMap<String, CoolMethod>();
    public static ArrayList<String> basicClassList=new ArrayList<String>();
    private static Support sup=null;
    public static HashMap<String, ArrayList<CoolClass>> localTypeStack = new HashMap<String, ArrayList<CoolClass>>(); //The array list is for the cases where the variables get new definitions in local scope. The inner most definition is at the end of the list.
    public static CoolClass selftype=null;

    public static Support getSupport() throws Exception {
        if(sup==null){
            sup=new Support();
        }
        return sup;
    }

    private Support() throws Exception {
        System.out.println("Support started....");

        CoolClass object=new CoolClass("Object",null,true);
        addClass(object);

        selftype=new CoolClass("SELF_TYPE",object,true); //Dummy SELF_TYPE class

        CoolClass io = new CoolClass("IO", object,true);
        addClass(io);

        CoolClass integer = new CoolClass("Int", object,true);
        addClass(integer);

        CoolClass string = new CoolClass("String", object,true);
        addClass(string);

        CoolClass bool = new CoolClass("Bool", object,true);
        addClass(bool);

        Iterator<String> itr=classes.keySet().iterator();
        while(itr.hasNext()){
            basicClassList.add(itr.next());
        }

        //Built in methods for Object (Page 13)
        CoolMethod abort = new CoolMethod("abort", object);
        CoolMethod typeName = new CoolMethod("type_name", string);
        CoolMethod copy = new CoolMethod("copy", selftype);
        object.addMethod(abort);
        object.addMethod(typeName);
        object.addMethod(copy);
        updateBasicMethodMap(object);


        //Built in methods for IO (Page 14)
        CoolMethod outString = new CoolMethod("out_string", selftype); //Resolve Self_type
        outString.parametres.add(new CoolAttribute("x", string));
        CoolMethod outInt = new CoolMethod("out_int", selftype); //Resolve Self_type
        outInt.parametres.add(new CoolAttribute("x", integer));
        CoolMethod inString = new CoolMethod("in_string", string);
        CoolMethod inInt = new CoolMethod("in_int", integer);
        io.addMethod(outString);
        io.addMethod(outInt);
        io.addMethod(inString);
        io.addMethod(inInt);
        updateBasicMethodMap(io);

        //Built in methods for String (Page 14)
        CoolMethod length = new CoolMethod("length", integer);
        CoolMethod concat = new CoolMethod("concat", string);
        concat.parametres.add(new CoolAttribute("s", string));
        CoolMethod substr = new CoolMethod("substr", string);
        substr.parametres.add(new CoolAttribute("i", integer));
        substr.parametres.add(new CoolAttribute("l", integer));
        string.addMethod(length);
        string.addMethod(concat);
        string.addMethod(substr);
        updateBasicMethodMap(string);

        System.out.println("Support ready");

    }

    public static CoolClass getFromLocalStack(String name){
        ArrayList<CoolClass> definitions=localTypeStack.get(name);
        if(definitions==null||definitions.isEmpty()){
            return null;
        }
        else{
            return definitions.get(definitions.size()-1);
        }
    }

    public static void addParamsToLocalStack(CoolMethod m){
        for (int i = 0; i <m.parametres.size() ; i++) {
            CoolAttribute a=m.parametres.get(i);
            addParamsToLocalStack(a.name, a.type);
        }
    }

    public static void addParamsToLocalStack(String name, CoolClass type) {
        ArrayList<CoolClass> definitions=localTypeStack.get(name);
        if(definitions==null){
            definitions=new ArrayList<CoolClass>();
            definitions.add(type);
        }
        else{
            definitions.add(type);
            localTypeStack.remove(name);
        }
        localTypeStack.put(name,definitions);
    }


    public static void removeParamsFromLocalStack(CoolMethod m) {
        for (int i = 0; i <m.parametres.size() ; i++) {
            removeParamFromLocalStack(m.parametres.get(i).name);
        }
    }

    public static void removeParamsFromLocalStack(ArrayList<String> names) {
        for (int i = 0; i < names.size(); i++) {
            String name=names.get(i);
            removeParamFromLocalStack(name);
        }
    }

    public static void removeParamFromLocalStack(String name) {
        ArrayList<CoolClass> definitions=localTypeStack.get(name);
        definitions.remove(definitions.size()-1); //Remove the last (newest) one
        localTypeStack.remove(name);
        localTypeStack.put(name,definitions);
    }

    private void updateBasicMethodMap(CoolClass basicClass) {
        Iterator<String> itr=basicClass.methodList.keySet().iterator();
        while(itr.hasNext()) {
            String key=itr.next();
            if(!basicMethods.containsKey(key)) {
                basicMethods.put(key, basicClass.methodList.get(key));
            }
        }
    }

    public static Iterator<CoolClass> getClassesIterator(){
        return(classes.values().iterator());
    }

    public static CoolClass addClass(String name) throws Exception {
        CoolClass c=new CoolClass( name);
        addClass(c);
        return c;
    }


    public static void addClass(CoolClass c) throws Exception {
        if (classes.containsKey(c.name)) {
            throw(new Exception("Class '"+c.name+"' is already defined"));
        }
        else {
            classes.put(c.name, c);
        }
    }



    public static CoolClass getClass(String n) throws Exception {
        CoolClass result = classes.get(n);
        if (result == null) {
            throw(new Exception("Class '"+n+"' is not defined"));
        }
        return result;
    }

    public void buildIndices(){
        Iterator<String> itr=classes.keySet().iterator();
        while(itr.hasNext()){
            classes.get(itr.next()).buildIndices();
        }
    }



    public static class CoolClass {
        public String name;
        private CoolClass parent;
        private ASTnode node;
        public boolean basic=false;
        public HashMap<String, CoolAttribute> attributes = new HashMap<String, CoolAttribute>();
        public HashMap<Integer,String> attributeIndex = new HashMap<Integer,String>();
        public HashMap<String, CoolMethod> methodList = new HashMap<String, CoolMethod>();
        public HashMap<Integer,String> methodIndex = new HashMap<Integer,String>();
        private boolean methodsAndAttributesLoaded=false;
        private boolean attributesInherited=false;
        private boolean methodsInherited=false;


        public CoolClass(String name, CoolClass parent, boolean basic) throws Exception {
            this.name = name;
            this.setParent(parent);
            this.basic = basic;
            if(this.basic){
                setMethodsAndAttributesLoaded(true);
            }
        }

        public void buildIndices(){
            Iterator<String> itr=attributes.keySet().iterator();
            while(itr.hasNext()){
                String name=itr.next();
                CoolAttribute ca=attributes.get(name);
                attributeIndex.put(ca.vtable_position,name);
            }

            itr=methodList.keySet().iterator();
            while(itr.hasNext()){
                String name=itr.next();
                CoolMethod cm=methodList.get(name);
                methodIndex.put(cm.vtable_position,name);
            }
        }

        public CoolAttribute attributeAt(int i){
            return attributes.get(attributeIndex.get(i));
        }

        public CoolMethod methodAt(int i){
            return methodList.get(methodIndex.get(i));
        }

        public CoolClass(String name, CoolClass parent) throws Exception {
            this(name,  parent, false);
        }

        public CoolClass(String name) throws Exception {
            this(name,null);
        }

        public void addMethod(CoolMethod m) throws Exception {
            if(methodList.containsKey(m.name)){
                throw(new Exception("Class '"+name+"' already has a method named '"+m.name+"' defined"));
            }
            else {
                //Now climb up the tree to see if it is in a parent
                CoolClass parent = this.parent;
                if(parent != null) {//The Object Class is the only class with parent NULL
                    while (parent != Support.getClass("Object")) {

                        if (parent.methodList.containsKey(m.name)) {
                            CoolMethod m1 = parent.methodList.get(m.name);

                            String exceptionHeader = "Mathod '" + m.name + "' of Class '" + name + "' cannot override the method from ancestor '" + parent.name + "' because of ";


                            if (m.parametres.size() != m1.parametres.size()) {
                                throw (new Exception(exceptionHeader + "parameter count mismatch"));
                            }

                            if (m.type != m1.type) {
                                throw (new Exception(exceptionHeader + "return value mismatch"));
                            }


                            Iterator<CoolAttribute> itr = m.parametres.iterator();
                            Iterator<CoolAttribute> itr1 = m1.parametres.iterator();
                            while (itr.hasNext()) {
                                CoolAttribute attr = itr.next();
                                CoolAttribute attr1 = itr1.next();
                                if (attr.type != attr1.type) {
                                    throw (new Exception(exceptionHeader + " the value of the parameter '" + attr.name + "' do not match"));
                                }
                            }
                        }
                        parent = parent.getParent();
                    }
                }

                m.setParent(this);
                methodList.put(m.name,m);
            }
        }

        public void addAttribute(CoolAttribute a) throws Exception {
            if(attributes.containsKey(a.name)){
                throw(new Exception("Class '"+name+"' already has an attribute named '"+a.name+"' defined"));
            }
            else{
                //Now climb up the tree to see if it is in a parent
                CoolClass parent = this.parent;
                while (parent != Support.getClass("Object")) {
                    if (parent.attributes.containsKey(a.name)) {
                        throw(new Exception("Cannot define the attribute '"+a.name+"' in Class '"+name+"' becuse it is already inherited from '"+parent.name+"' Class"));
                    }
                    parent=parent.getParent();
                }

                a.setParent(this);
                attributes.put(a.name,a);
            }
        }

        public ASTnode getNode() {
            return node;
        }

        public void setNode(ASTnode node) {
            this.node = node;
        }

        public CoolClass getParent() {
            return parent;
        }

        public void setParent(CoolClass parent) {
            this.parent = parent;
        }

        public boolean isMethodsAndAttributesLoaded() {
            return methodsAndAttributesLoaded;
        }

        public void setMethodsAndAttributesLoaded(boolean methodsAndAttributesLoaded) {
            this.methodsAndAttributesLoaded = methodsAndAttributesLoaded;
        }

        public boolean isAttributesInherited() {
            return attributesInherited;
        }

        public void setAttributesInherited(boolean attributesInherited) {
            this.attributesInherited = attributesInherited;
        }

        public boolean isMethodsInherited() {
            return methodsInherited;
        }

        public void setMethodsInherited(boolean methodsInherited) {
            this.methodsInherited = methodsInherited;
        }

        public String toString(){
            StringBuilder sb=new StringBuilder();
            sb.append("*************************************************");
            sb.append(System.lineSeparator());
            sb.append("Class name: ");
            sb.append(name);
            sb.append(System.lineSeparator());
            if(parent!=null){
                sb.append("Parent name: ");
                sb.append(parent.name);
                sb.append(System.lineSeparator());
            }
            Iterator<String> itr;
            if(attributes.size()>0) {
                sb.append("Attributes:\n");
                itr=attributes.keySet().iterator();
                while(itr.hasNext()){
                    sb.append(" "+attributes.get(itr.next()));
                    sb.append(System.lineSeparator());
                }
            }
            if(methodList.size()>0) {
                sb.append("Methods:\n");
                itr=methodList.keySet().iterator();
                while(itr.hasNext()){
                    sb.append(" "+methodList.get(itr.next()));
                    sb.append(System.lineSeparator());
                }
            }
            return sb.toString();
        }

        public String gen_obj_skel() {
            StringBuilder sb=new StringBuilder();

            //Object structure begins with class pointer
            sb.append("%struct.obj_"+name+" = type { %struct.class_"+name+"*");

            // Then it has fields for each value
            for (int i = 0; i <attributes.size() ; i++) {
                sb.append(", " + Support.type_struct(this,attributeAt(i).type.name));
            }
            sb.append("}");
           return sb.toString();
        }

        public String gen_class_skel() {
            StringBuilder sb=new StringBuilder();
            String parentName=name; //For object
            if(parent!=null){
                parentName=parent.name;
            }

            sb.append("%struct.class_"+name+" = type { %struct.class_"+parentName+"*");
            for (int i = 0; i <methodList.size() ; i++) {
                sb.append(", ");
                sb.append(methodAt(i).signature());
                sb.append("*");
            }
            sb.append("}");
            return sb.toString();
        }

        public String gen_class_object() {
            StringBuilder sb=new StringBuilder();
            sb.append("@the_class_"+name+" = global %struct.class_"+name+" {");

            //Superclass pointer
            String parentName=name; //For object
            if(parent!=null){
                parentName=parent.name;
            }
            sb.append("%struct.class_"+parentName+"* @the_class_"+parentName);


            //All other methods
            for (int i = 0; i <methodList.size() ; i++) {
                CoolMethod m=methodAt(i);
                sb.append(", "+m.signature());
                sb.append(" @"+m.getParent().name+"_"+m.name);
            }
            sb.append(" }, align 8");

            return sb.toString();
        }

        //At what offset (in number of fields) does field with field_name reside?
        //We want the offset and the type of the field found there (as a tuple)
  /*      public field_ref(String attribName) throws Exception {
           CoolAttribute ca =attributes.get(attribName);
            if(ca==null){
                throw(new Exception("Attribute '"+attribName+"' is not defined"));
            }
            else{
                int index=ca.vtable_position;
                return;(index++); //Add one for class pointer
            }
        }
        */


    }



    /**
     * llvm reference for either a Cool class or a primitive (unboxed) type
     * @return
     */
    public static String type_struct(CoolClass c,String name){
        if (name.equalsIgnoreCase("Int")){
            return "%struct.obj_Integer*"; //Fix later. Differnce in Prof's C file and my basic class
        }
        else if(classes.keySet().contains(name)){
            return "%struct.obj_"+name+"*";
        }
        else if (name.equalsIgnoreCase("SELF_TYPE")){
            return type_struct(c,c.name);
        }
        else{
            return name;
        }
    }

    public static class CoolAttribute {
        public String name;
        public CoolClass type;
        private ASTnode node;
        private CoolClass parent;
        public int vtable_position=-1;

        public CoolAttribute(String name, CoolClass type) {
            this.name = name;
            this.type = type;
        }

        //clone
        public CoolAttribute(CoolAttribute ca) {
            this.name = ca.name;
            this.type = ca.type;
            this.node = ca.node;
            this.parent = ca.parent;
            this.vtable_position = ca.vtable_position;
        }

        public ASTnode getNode() {
            return node;
        }

        public void setNode(ASTnode node) {
            this.node = node;
        }

        public CoolClass getParent() {
            return parent;
        }

        public void setParent(CoolClass parent) {
            this.parent = parent;
        }

        public String toString(){
            return type.name+" "+name+" "+vtable_position;
        }
    }

    public static class CoolMethod {
        public String name;
        public CoolClass type;
        public ArrayList<CoolAttribute> parametres = new ArrayList<CoolAttribute>();


        private ASTnode node;
        private CoolClass parent;
        public int vtable_position=-1;


        public CoolMethod(String name, CoolClass type)  {
            this.name = name;
            this.type = type;
        }

        //clone
        public CoolMethod(CoolMethod cm)  {
            this.name = cm.name;
            this.type = cm.type;
            this.node = cm.node;
            this.parent = cm.parent;
            this.vtable_position = cm.vtable_position;
            for (int i = 0; i < cm.parametres.size(); i++) {
                parametres.add(new CoolAttribute(cm.parametres.get(i)));
            }
        }


        public ASTnode getNode() {
            return node;
        }

        public void setNode(ASTnode node) {
            this.node = node;
        }

        public CoolClass getParent() {
            return parent;
        }

        public void setParent(CoolClass parent) {
            this.parent = parent;
        }

        public String toString(){
            StringBuilder sb=new StringBuilder();
            sb.append(type.name+" "+name+" "+vtable_position);
            if(parametres.size()>0) {
                sb.append(System.lineSeparator());
                sb.append("  Parameters:");
                for (int i = 0; i < parametres.size(); i++) {
                    sb.append("   " + parametres.get(i));
                }
            }
            return sb.toString();
        }

        //Signature of this method in llvm notation
        public String signature() {
            StringBuilder sb=new StringBuilder();
            sb.append(" " +Support.type_struct(parent,type.name)+" ");
            sb.append("("+Support.type_struct(parent,parent.name));
            String arg_sep = ", ";
            for (int i = 0; i < parametres.size(); i++) {
                sb.append(arg_sep + " " + Support.type_struct(parent,parametres.get(i).type.name));
                arg_sep=", ";
            }
            sb.append(" )");
            return sb.toString();
        }
    }
}
