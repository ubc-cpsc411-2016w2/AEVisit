package ca.ubc.cs411.aevisit;

/**
 * Created by ronaldgarcia on 2017-01-12.
 */
public interface Visitor<X> {
    X visit(Num nm);
    X visit(Add ad);
    X visit(Sub sb);
}
