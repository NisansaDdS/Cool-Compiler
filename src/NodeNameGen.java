import java.io.*;

/**
 * Created by Nisansa on 15/05/09.
 */
public class NodeNameGen {

    static public void main(String args[]) {
        NodeNameGen nng=new NodeNameGen();
    }

    public NodeNameGen() {
        StringBuilder sb = new StringBuilder();

        sb.append("public class Converter {");
        sb.append(System.lineSeparator());
        sb.append("public static String getName(int id){");
        sb.append(System.lineSeparator());
        sb.append("switch (id) {");
        sb.append(System.lineSeparator());
        sb.append(ReadFile("sym.java"));
        sb.append(ReadFile("AdditionalSym.java"));
        sb.append("default: return(\"\");");
        sb.append(System.lineSeparator());
        sb.append("}");
        sb.append(System.lineSeparator());
        sb.append("}");
        sb.append(System.lineSeparator());
        sb.append("}");
        sb.append(System.lineSeparator());


        writeFile(sb.toString());
    }

    public void writeFile(String data){
        Writer writer = null;
        try {
            writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream("Converter.java"), "utf-8"));
            writer.write(data);
        } catch (IOException ex) {
            // report
        } finally {
            try {writer.close();} catch (Exception ex) {/*ignore*/}
        }
    }

    public String ReadFile(String fileName){
        String everything="";
        try {
            BufferedReader br = new BufferedReader(new FileReader(fileName));
            StringBuilder sb = new StringBuilder();
            String line = br.readLine();

            while (line != null) {
                if(line.contains("public static final int")){
                    String[] sides=line.split("=");
                    sides[0]=sides[0].trim();
                    String[] names=sides[0].split(" ");
                    sides[1]=sides[1].split(";")[0];
                    //sides[1]= sides[1].substring(0, sides[1].length()-1);
                    sides[1]=sides[1].trim();
                    sb.append("case " + sides[1] + ": return(\"" + names[4] + "\");");
                    sb.append(System.lineSeparator());
                }
                line = br.readLine();
            }
            everything = sb.toString();

            br.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return everything;
    }
}
