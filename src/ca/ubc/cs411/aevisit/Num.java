package ca.ubc.cs411.aevisit;

/**
 * Created by ronaldgarcia on 2017-01-05.
 */
public class Num extends AE {
    public final int n;

    public Num(int n) {
        this.n = n;
    }

    @Override
    public String toString() {
        return "new Num(" + n + ')';
    }

    @Override
    public int interp() {
        return this.n;
    }

    @Override
    public <X> X fold(Folder<X> fr) {
        return fr.forNum(n);
    }

    @Override
    public <X> X accept(Visitor<X> v) {
        return v.visit(this); // calls Visitor<X>.visit(Num) because "this" has type Num
    }
}
