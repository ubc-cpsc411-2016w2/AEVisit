package ca.ubc.cs411.aevisit;

/**
 * Created by ronaldgarcia on 2017-01-10.
 */
public class InterpFolder implements Folder<Integer> {
    @Override
    public Integer forNum(int n) { return n; }

    @Override
    public Integer forAdd(Integer n1, Integer n2) {
        return n1 + n2;
    }

    @Override
    public Integer forSub(Integer n1, Integer n2) {
        return n1 - n2;
    }
}
