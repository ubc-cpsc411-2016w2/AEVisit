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
        System.out.println(new Num(0).fold(new HzFolder()));
        System.out.println(new Num(1).fold(new HzFolder()));
        System.out.println(new Add(new Num(0),new Num(1)).fold(new HzFolder()));
        System.out.println(new Add(new Num(0),new Num(6)).fold(new AddSubSevenFolder()));
        System.out.println(new Add(new Num(0),new Num(1)).accept(new HzVisitor()));
        // throw new Error("bad things happened");
    }
}
