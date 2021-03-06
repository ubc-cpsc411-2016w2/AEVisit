package ca.ubc.cs411.aevisit;

/**
 * Created by ronaldgarcia on 2017-01-12.
 */
public class HzVisitor implements Visitor<Boolean> {
    @Override
    public Boolean visit(Num nm) {
        return nm.n == 0;
    }

    @Override
    public Boolean visit(Add ad) {
        // Thanks to short-circuiting || the following recurs on rhs only if lhs yields false
        return ad.lhs.accept(this) || ad.rhs.accept(this);
    }

    @Override
    public Boolean visit(Sub sb) {
        return sb.lhs.accept(this) || sb.rhs.accept(this);
    }
}
