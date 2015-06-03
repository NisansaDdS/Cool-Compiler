import java.io.*;
import java.util.Iterator;

/**
 * Created by Nisansa on 15/05/30.
 */
public class CodeGenerator {

    Support s;
    boolean verbose=false;
    ASTnode root;
    int id=0;

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

            itr = Support.getClassesIterator();

            System.out.println("Creating methods");
            //Methods
            while (itr.hasNext()) {
                Support.CoolClass c = itr.next();
                if (!Support.basicClassList.contains(c.name)) {
                    for (int i = 0; i < c.methodList.size(); i++) {
                        Support.CoolMethod cm = c.methodAt(i);
                        if (cm.getImplimetedIn().name.equalsIgnoreCase(c.name)) { //Overridden or new method
                            sb.append(cm.defineMathod());
                            sb.append(System.lineSeparator());
                            sb.append(cm.saveArguments());
                            sb.append(System.lineSeparator());
                            //Real logic
                            sb.append(cm.createReturn());
                            sb.append(System.lineSeparator());
                            sb.append("}");
                        }
                    }
                }
            }

            writeFile(sb.toString());
            // System.out.println(sb.toString());
        }catch (Exception e) {
                System.err.println("Code Generation error");
                System.err.println(e.getMessage());
        }

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
