package cs411.aefold;

/**
 * Created by ronaldgarcia on 2017-01-12.
 */
public class HzVisitor implements Visitor<Boolean> {
    @Override
    public Boolean visit(Num nm) {
        return new Boolean(nm.n == 0);
    }

    @Override
    public Boolean visit(Add ad) {
        // Thanks to short-circuiting || it recurs on rhs only if lhs yields false
        return new Boolean(ad.lhs.accept(this) || ad.rhs.accept(this));
    }

    @Override
    public Boolean visit(Sub sb) {
        return new Boolean(sb.lhs.accept(this) || sb.rhs.accept(this));
    }
}
