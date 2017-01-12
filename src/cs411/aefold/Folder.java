package cs411.aefold;

/**
 * Created by ronaldgarcia on 2017-01-10.
 */
public interface Folder<X> {
    X forNum(int n);
    X forAdd(X n1, X n2);
    X forSub(X n1, X n2);
}
