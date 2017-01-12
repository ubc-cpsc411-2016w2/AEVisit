package cs411.aefold;

/**
 * Created by ronaldgarcia on 2017-01-05.
 */
public abstract class AE {
    public abstract int interp();
    public abstract <R> R fold(Folder<R> fr);
}