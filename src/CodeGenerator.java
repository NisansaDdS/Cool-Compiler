import java.io.*;
import java.util.Iterator;

/**
 * Created by Nisansa on 15/05/30.
 */
public class CodeGenerator {

    Support s;
    boolean verbose=false;
    ASTnode root;

    public CodeGenerator(ASTnode root,boolean verbose)  {
        this.root = root;
        this.verbose=verbose;

        try {
            s=Support.getSupport();
        } catch (Exception e) {
            System.err.println("Could not initialize support");
            System.err.println(e.getMessage());
        }


        s.buildIndices();

        Iterator<Support.CoolClass> itr=Support.getClassesIterator();
        StringBuilder sb=new StringBuilder();
        while(itr.hasNext()){
            Support.CoolClass c=itr.next();
            if(!Support.basicClassList.contains(c.name)){
                sb.append(c.gen_obj_skel());
                sb.append(System.lineSeparator());
                sb.append(c.gen_class_skel());
                sb.append(System.lineSeparator());
                sb.append(c.gen_class_object());
                sb.append(System.lineSeparator());
            }
        }
        writeFile(sb.toString());
       // System.out.println(sb.toString());


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
}
