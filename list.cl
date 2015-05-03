class Node {
    data: Object;
    prev: Node;
    next: Node;

    getData(): Object { data };
    getPrev(): Node { prev };
    getNext(): Node { next };

    setPrev(p: Node): Node {
        {
            prev <- p;
            self;
        }
    };

    setNext(n: Node): NOde {
        {
            next <- n;
            self;
        }
    };

    init(d: Object) Node {
        {
            data <- d;
	    self;
        }
    };
};

class List {
    l: Node <- (new Node).init("@");
    count: Int <- 0;

    getCount(): Int { count };

    append(n: Node) List {
        if count=0 then {
            l.setPrev(n);
            l.setNext(n);
            n.setPrev(l);
            n.setNext(l);
	    count <- count + 1;
	    self;
        } else {
            n.setNext(l);
            n.setPrev(l.getPrev());
            l.getPrev().setNext(n);
            l.setPrev(n);
	    count <- count +1;
	    self;
        } fi
    };

    delete() Node {
        if count=0 then {
            l;
        } else {
	    n: Node <- l.getPrev();
	    n.getPrev().setNext(n.getNext());
	    n.getNext().setPrev(n.getPrev());
	    count <- count -1;
	    n;
	} fi
    };
}
    
class Main {
    l: List;

    main(): Object {
        {
            i: Int <- 0;
            while i<5 loop {
                l.append((new Node).init(i));
		i <- i + 1;
            } pool;

            i <- 0;
	    io: IO <- new IO;
	    while i<5 loop {
	        io.out_int(l.delete().getData())
		i <- i + 1;
	    } pool;
        }
    };
};