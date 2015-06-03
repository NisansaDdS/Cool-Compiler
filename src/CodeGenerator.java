import java.io.*;
import java.util.ArrayList;
import java.util.Iterator;

/**
 * Created by Nisansa on 15/05/30.
 */
public class CodeGenerator {

    Support s;
    boolean verbose=false;
    ASTnode root;
    int id=0;
    int stringId=0;
    ArrayList<String> globalVariables=new ArrayList<String>();

    public CodeGenerator(ASTnode root,boolean verbose)  {
        this.root = root;
        this.verbose=verbose;






        try {

            try {
                s=Support.getSupport();
                s.buildIndices();
            } catch (Exception e) {
                throw(new Exception("Could not initialize support"));
            }
            StringBuilder sbMain = new StringBuilder();

            Iterator<Support.CoolClass> itr = Support.getClassesIterator();
            StringBuilder sb = new StringBuilder();

            System.out.println("Creating class signatures");
            //%struct.obj_X , %struct.class_X , @the_class_X
            while (itr.hasNext()) {
                Support.CoolClass c = itr.next();
                if (!Support.basicClassList.contains(c.name)) {
                    sb.append(c.gen_obj_skel());
                    sb.append(System.lineSeparator());
                    sb.append(c.gen_class_skel());
                    sb.append(System.lineSeparator());
                    sb.append(c.gen_class_object());
                    sb.append(System.lineSeparator());
                }
            }
            sbMain.append(sb.toString());

            sb = new StringBuilder(); //We need to do this bacause the global variables have to come before the methods. But they will only be found when we explore the methods

            System.out.println("Creating methods");
            itr = Support.getClassesIterator();
            while (itr.hasNext()) {
                Support.CoolClass c = itr.next();
                if (!Support.basicClassList.contains(c.name)) {

                    //Methods
                    for (int i = 0; i < c.methodList.size(); i++) {
                        Support.CoolMethod cm = c.methodAt(i);
                        if (cm.getImplimetedIn().name.equalsIgnoreCase(c.name)) { //Overridden or new method
                            sb.append(cm.defineMathod());
                            sb.append(System.lineSeparator());
                            sb.append(cm.saveArguments());
                            sb.append(System.lineSeparator());
                            //Real logic
                            generateCode(sb,c,cm,cm.getNode());

                            sb.append(cm.createReturn());
                            sb.append(System.lineSeparator());
                            sb.append("}");
                            sb.append(System.lineSeparator());
                        }
                    }

                    //Constructor
                    sb.append(c.gen_class_constructor());
                    sb.append(System.lineSeparator());
                }
            }

            //Now add all the global variable lines
            for (int i = 0; i <globalVariables.size() ; i++) {
                sbMain.append(globalVariables.get(i));
                sbMain.append(System.lineSeparator());
            }

            //Now add the methods
            sbMain.append(sb.toString());

            //add the main method
            sbMain.append(generateTheLLVMmain());

            writeFile(sbMain.toString());
        }catch (Exception e) {
                System.err.println("Code Generation error");
                System.err.println(e.getMessage());
        }

    }

    private String generateCode(StringBuilder sb,Support.CoolClass c,Support.CoolMethod hm,ASTnode n){ //(hm-host method)


        if(n.nodeSignature==AdditionalSym.METHOD_BLOCK){

            sb.append(generateCode(sb,c,hm,n.rightChild));
            //do the return check
        }
        else if(n.nodeSignature==AdditionalSym.INVOKE){

            Support.CoolClass mc=c; //Method owner class
            if(n.leftChild!=null){ //Owner is not this class. A name of another class was given
                mc=n.leftChild.type;
            }

            if(n.middleChild!=null){ //Optional [@TYPE] was set
               // Support.CoolClass tyC=Support.getClass((String)n.middleChild.value);
              //  if(tyC!=null) {
               //     if(!isTypesConsistant(tyC,mc)){
                 //       throw(new Exception("Casted class '"+tyC.name+"' is not compatible with the class type '"+mc.name+"'."));
              //      }
              //  }
               // mc=tyC;
            }

            Support.CoolMethod m= mc.methodList.get(n.value); //Get the relevant method

            String ownerName=m.getImplimetedIn().name;
            String methodName=m.name;

            //Note this has to be done only when the owner is not this class (ie either inherited or n.leftchild was not null)
            String ownerVar="%owner";

            //%io = alloca %struct.obj_IO*, align 4
            sb.append("    "+ownerVar+" = alloca %struct.obj_"+ownerName+"*, align 4");
            sb.append(System.lineSeparator());

            //%0 = load %struct.obj_IO* (...)** getelementptr inbounds (%struct.class_IO* @the_class_IO, i32 0, i32 1), align 4
            String id0=hm.nextRegID();
            sb.append("    "+id0+" = load %struct.obj_"+ownerName+"* (...)** getelementptr inbounds (%struct.class_"+ownerName+"* @the_class_"+ownerName+", i32 0, i32 1), align 4");
            sb.append(System.lineSeparator());

            //%callee.knr.cast = bitcast %struct.obj_IO* (...)* %0 to %struct.obj_IO* ()*
            sb.append("    %callee.knr.cast"+hm.callerID+" = bitcast %struct.obj_"+ownerName+"* (...)* "+id0+" to %struct.obj_"+ownerName+"* ()*");
            sb.append(System.lineSeparator());

            //%call = call %struct.obj_IO* %callee.knr.cast()
            sb.append("    %call"+hm.callId+" = call %struct.obj_"+ownerName+"* %callee.knr.cast"+hm.callerID+"()");
            sb.append(System.lineSeparator());

            //store %struct.obj_IO* %call, %struct.obj_IO** %io, align 4
            sb.append("    store %struct.obj_"+ownerName+"* %call"+hm.callId+", %struct.obj_"+ownerName+"** "+ownerVar+", align 4");
            sb.append(System.lineSeparator());

            hm.callerID++;
            hm.callId++;
            ///////////////////////
            String paramName=generateCode(sb,c, hm,n.rightChild); //Method params //la




            //%2 = load %struct.obj_IO** %io, align 4
            String id2=hm.nextRegID();
            sb.append("    "+id2+" = load %struct.obj_"+ownerName+"** "+ownerVar+", align 4");
            sb.append(System.lineSeparator());

            //%clazz = getelementptr inbounds %struct.obj_IO* %2, i32 0, i32 0
            String clazz=hm.nextRegID();
            sb.append("    "+clazz+" = getelementptr inbounds %struct.obj_"+ownerName+"* "+id2+", i32 0, i32 0");
            sb.append(System.lineSeparator());

            //%3 = load %struct.class_IO** %clazz, align 4
            String id3=hm.nextRegID();
            sb.append("    "+id3+" = load %struct.class_"+ownerName+"** "+clazz+", align 4");
            sb.append(System.lineSeparator());

            //%IO_out = getelementptr inbounds %struct.class_IO* %3, i32 0, i32 3
            String methodVar=hm.nextRegID();
            sb.append("    "+methodVar+" = getelementptr inbounds %struct.class_"+ownerName+"* "+id3+", i32 0, i32 3"); //Note: get from m.vtable_position curenly it is 7. Fix it
            sb.append(System.lineSeparator());

            //%4 = load %struct.obj_IO* (%struct.obj_IO*, %struct.obj_Object*)** %IO_out, align 4
            String id4=hm.nextRegID();
            sb.append("    "+id4+" = load %struct.obj_"+ownerName+"* (%struct.obj_"+ownerName+"*, %struct.obj_Object*)** "+methodVar+", align 4"); //Note: Second one should change depending on the params
            sb.append(System.lineSeparator());

            //%5 = load %struct.obj_IO** %io, align 4
            String id5=hm.nextRegID();
            sb.append("    "+id5+" = load %struct.obj_"+ownerName+"** "+ownerVar+", align 4");
            sb.append(System.lineSeparator());

            //%6 = load %struct.obj_String** %la, align 4
            String id6=hm.nextRegID();
            sb.append("    "+id6+" = load %struct.obj_String** "+paramName+", align 4"); //Note type and var should change depending on the argumets, perhaps get a list of registers instead of just param name
            sb.append(System.lineSeparator());

            //%7 = bitcast %struct.obj_String* %6 to %struct.obj_Object*
            String id7=hm.nextRegID();
            sb.append("    "+id7+" = bitcast %struct.obj_String* "+id6+" to %struct.obj_Object*"); //Note depends on above
            sb.append(System.lineSeparator());

            //%call3 = call %struct.obj_IO* %4(%struct.obj_IO* %5, %struct.obj_Object* %7)
            sb.append("    %call"+hm.callId+" = call %struct.obj_"+ownerName+"* "+id4+"(%struct.obj_"+ownerName+"* "+id5+", %struct.obj_Object* "+id7+")"); //Note depends on above
            sb.append(System.lineSeparator());

            hm.callId++;
        }
        else if(n.nodeSignature==sym.STRINGLIT){


            //First create the string

            //@.str11 = private unnamed_addr constant [6 x i8] c"Baaaa\00", align 1
            String val=(String)n.value;
            int size=val.length()+1;
            globalVariables.add("@.strs"+stringId+" = private unnamed_addr constant ["+size+" x i8] c\""+val+"\\00\", align 1");

            //%la = alloca %struct.obj_String*, align 4
            String la=hm.nextRegID();
            sb.append("    "+la+" = alloca %struct.obj_String*, align 4");
            sb.append(System.lineSeparator());

            //%0 = load %struct.obj_String* (...)** getelementptr inbounds (%struct.class_String* @the_class_String, i32 0, i32 1), align 4
            String id0=hm.nextRegID();
            sb.append("    "+id0+" = load %struct.obj_String* (...)** getelementptr inbounds (%struct.class_String* @the_class_String, i32 0, i32 1), align 4");
            sb.append(System.lineSeparator());

            //%callee.knr.cast2 = bitcast %struct.obj_String* (...)* %0 to %struct.obj_String* (i8*)*
            sb.append("    %callee.knr.cast"+hm.callerID+" = bitcast %struct.obj_String* (...)* "+id0+" to %struct.obj_String* (i8*)*");
            sb.append(System.lineSeparator());

            //%call2 = call %struct.obj_String* %callee.knr.cast2(i8* getelementptr inbounds ([6 x i8]* @.str11, i32 0, i32 0))
            sb.append("    %call"+hm.callId+" = call %struct.obj_String* %callee.knr.cast"+hm.callerID+"(i8* getelementptr inbounds (["+size+" x i8]* @.strs"+stringId+", i32 0, i32 0))");
            sb.append(System.lineSeparator());

            //store %struct.obj_String* %call2, %struct.obj_String** %la, align 4
            sb.append("    store %struct.obj_String* %call"+hm.callId+", %struct.obj_String** "+la+", align 4");
            sb.append(System.lineSeparator());

            hm.callerID++;
            hm.callId++;
            stringId++;

            return la;

        }
        else{
            System.out.println(Converter.getName(n.nodeSignature));
        }



        return("");
    }

    private String generateTheLLVMmain(){
        StringBuilder sb = new StringBuilder();
        sb.append("define i32 @main(i32 %argc, i8** %argv) #0 {");
        sb.append(System.lineSeparator());
        sb.append("entry:");
        sb.append(System.lineSeparator());
        sb.append("   %retval = alloca i32, align 4");
        sb.append(System.lineSeparator());
        sb.append("   %argc.addr = alloca i32, align 4");
        sb.append(System.lineSeparator());
        sb.append("   %argv.addr = alloca i8**, align 4");
        sb.append(System.lineSeparator());
        sb.append("   store i32 0, i32* %retval");
        sb.append(System.lineSeparator());
        sb.append("   store i32 %argc, i32* %argc.addr, align 4");
        sb.append(System.lineSeparator());
        sb.append("   store i8** %argv, i8*** %argv.addr, align 4");
        sb.append(System.lineSeparator());
        sb.append("   %call1 = call %struct.obj_Main* @Main_new()");
        sb.append(System.lineSeparator());
        sb.append("   %call = call %struct.obj_Object* @Main_main(%struct.obj_Main* %call1)");
        sb.append(System.lineSeparator());
        sb.append("   ret i32 0");
        sb.append(System.lineSeparator());
        sb.append("}");
        sb.append(System.lineSeparator());
        return (sb.toString());
    }

    public void writeFile(String text) {
        String oFileName="D:\\Eclipse WorkSpace\\Compiler\\C code\\gen.ll";


        try {
            File statText = new File(oFileName);
            FileOutputStream is = new FileOutputStream(statText);
            OutputStreamWriter osw = new OutputStreamWriter(is);
            BufferedWriter w = new BufferedWriter(osw);
            w.write(text);
            w.close();
        } catch (IOException e) {
            System.err.println("Problem writing to the file SpamHam.arff");
            System.out.println(e.toString());
        }
    }

    public String nextRegID() {
        return "%_" + id++;
    }

    public Support.Register nextRegister(String type) throws Exception {
        return new Support.Register(nextRegID(), type);
    }


}
