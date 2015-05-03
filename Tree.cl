(*
 * CIS 561
 * Assignment 1
 *
 * A basic tree structure is implemented by Cool in this file.
 * class TreeNode is defined as non-empty node. Each node contains an integer value, 
 * left subtree and right subtree. isNil function is used for testing whether this is 
 * an empty node(leaf node). And get function is used for retriving values of the
 * attributes. buiderTree function is to create tree structure. And printTree is designed to 
 * traverse the tree in pre-order printing the value of each node. 
 * Nil class can be seen as a special TreeNode which is empty. 
 * Main class includes main function which initialize the tree and print it out.
 *)

class TreeNode inherits IO{

	value : Int;

	left  : TreeNode;

	right : TreeNode;

	isNil() : Bool {false};

	getVal() : Int {value};

	getLeft() : TreeNode {left};

	getRight(): TreeNode {right};

	buildTree(v: Int, l : TreeNode, r : TreeNode) : TreeNode{
		{			
			value  <- v;
			left  <- l;
			right <- r;
			self;
		}

	};

	printTree(t : TreeNode) : Object {

		{
			if t.isNil() 
			then 
				out_string(" Leaf ")
			else{
					out_string(" ");
					out_int(t.getVal());
					printTree(t.getLeft());
					printTree(t.getRight());

				}
			fi;
		}
	};

};


class Nil inherits TreeNode {

	isNil() : Bool {true};
};


class Main inherits IO {

  testTree : TreeNode;


  main() : Object { 

  	{
    	out_string("Program starts...\n");
    	testTree <- (new TreeNode).buildTree(1, (new TreeNode).buildTree(2, 
    		(new TreeNode).buildTree(4, (new Nil), (new Nil)), 
    			(new TreeNode).buildTree(5, (new Nil), (new Nil))),
    		 		(new TreeNode).buildTree(3, (new Nil), (new Nil)));
    	testTree.printTree(testTree);
	}
  } ;
} ; 







