class Main {

    main() : Object {
        let i : Int <- 2 in {
            (new IO).out_string((addition(i)).concat("\n"))
        }
    };

    addition(i : Int): Int {
        let j: Int <- 2 in { 
            i <- i + j;
            i;
        }
    };
};