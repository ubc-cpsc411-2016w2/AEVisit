package cs411.aefold;

public class Main {

    public static void main(String[] args) {
	// write your code here
        System.out.println("411 Rulez!");
        AE e1 = new Num(7);
        System.out.println(new Num(7));
        System.out.println(new Add(new Num(7),new Num(3)));
        AE e = new Sub(new Add(new Num(7), new Num(3)), new Num(2));
        System.out.println(e);
        System.out.println(e.interp());
        System.out.println(e.fold(new InterpFolder()));
        System.out.println();
    }
}
