package ca.ubc.cs411.aevisit;

/**
 * Created by ronaldgarcia on 2017-01-05.
 */
public class Sub extends AE {
    public final AE lhs;
    public final AE rhs;

    public Sub(AE lhs, AE rhs) {
        this.lhs = lhs;
        this.rhs = rhs;
    }

    @Override
    public String toString() {
        return "new Sub(" + lhs + ", " + rhs + ")";
    }

    @Override
    public int interp() {
        return lhs.interp() - rhs.interp();
    }

    @Override
    public <X> X fold(Folder<X> fr) { return fr.forSub(lhs.fold(fr),rhs.fold(fr)); }

    @Override
    public <X> X accept(Visitor<X> v) {
        return v.visit(this); // calls Visitor<X>.visit(Sub) because "this" has type Sub
    }

}
