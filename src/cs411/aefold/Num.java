package cs411.aefold;

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
        return "Num(" +
                 n +
                ')';
    }

    @Override
    public int interp() {
        return this.n;
    }

    @Override
    public <X> X fold(Folder<X> fr) {
        return fr.forNum(n);
    }
}
