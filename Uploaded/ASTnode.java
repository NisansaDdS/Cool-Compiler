/**
 * Created by Nisansa on 15/05/09.
 */
public class ASTnode {
    public int nodeSignature=-1;
    public ASTnode leftChild;
    public ASTnode middleChild;
    public ASTnode rightChild;
    public Object value;
    public Support.CoolClass type;

    //Leaf
    public ASTnode(int nodeSignature,Object value) {
        this.value = value;
        this.nodeSignature = nodeSignature;
    }

    //Internal node
    public ASTnode(int nodeSignature, ASTnode leftChild,ASTnode middleChild, ASTnode rightChild, Object value) {
        this.nodeSignature = nodeSignature;
        this.leftChild = leftChild;
        this.middleChild=middleChild;
        this.rightChild = rightChild;
        this.value = value;
    }

    public String toString(){
        return getString("");
    }

    public String getString(String offset){
        StringBuilder sb=new StringBuilder();
        sb.append(offset);
        sb.append(Converter.getName(nodeSignature));
        sb.append("\n");
        if(value !=null) {
            sb.append(offset);
            sb.append(value);
            sb.append("\n");
        }
        if(leftChild!=null) {
            sb.append(offset);
            sb.append(leftChild.getString(offset + "."));
        }
        if(middleChild!=null) {
            sb.append(offset);
            sb.append(middleChild.getString(offset + "."));
        }
        if(rightChild!=null) {
            sb.append(offset);
            sb.append(rightChild.getString(offset + "."));
        }
        return sb.toString();
    }
}
