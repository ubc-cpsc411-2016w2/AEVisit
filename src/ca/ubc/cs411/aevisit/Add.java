package ca.ubc.cs411.aevisit;

/**
 * Created by ronaldgarcia on 2017-01-05.
 */
public class Add extends AE {
    public final AE lhs;
    public final AE rhs;

    public Add(AE lhs, AE rhs) {
        this.lhs = lhs;
        this.rhs = rhs;
    }

    @Override
    public String toString() {
        return "Add(" + lhs + "," + rhs + ")";
    }

    @Override
    public int interp() {
        return lhs.interp() + rhs.interp();
    }

    @Override
    public <X> X fold(Folder<X> fr) { return fr.forAdd(lhs.fold(fr),rhs.fold(fr)); }

    @Override
    public <X> X accept(Visitor<X> v) {
        return v.visit(this); // calls Visitor<X>.visit(Add) because "this" has type Add
    }
}
