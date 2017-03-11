package ca.ubc.cs411.aevisit;

/**
 * Created by ronaldgarcia on 2017-01-12.
 */
public class AddSubSevenFolder implements Folder<AE> {
    @Override
    public AE forNum(int n) {
        return new Num(n);
    }

    @Override
    public AE forAdd(AE n1, AE n2) {
        return new Sub(new Add(n1,n2),new Num(7));
    }

    @Override
    public AE forSub(AE n1, AE n2) {
        return new Sub(n1,n2);
    }
}
