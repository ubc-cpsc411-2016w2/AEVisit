package cs411.aefold;

/**
 * Created by ronaldgarcia on 2017-01-12.
 */
public class HzFolder implements Folder<Boolean> {
    @Override
    public Boolean forNum(int n) {
        return (n == 0);
    }

    @Override
    public Boolean forAdd(Boolean n1, Boolean n2) {
        return n1 || n2;
    }

    @Override
    public Boolean forSub(Boolean n1, Boolean n2) {
        return n1 || n2;
    }
}
