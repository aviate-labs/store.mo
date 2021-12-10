import Iter "mo:base/Iter";

import Filter "../src/Filter";
import Store "../src/Store";

type Beer = {
    // Name;
    name  : Text;
    // Alochol by volume.
    abv   : Float;
};

let store = Store.Store<Beer>();

let stella : Beer = {
    name = "Stella Artois";
    abv  = 5.2;
};

let vedett : Beer = {
    name = "Vedett IPA";
    abv  = 5.5;
};

ignore store.put(stella.name, stella);
assert(store.delete(stella.name) == ?stella);
assert(store.put(stella.name, stella) == null);
assert(store.put(vedett.name, vedett) == null);
assert(store.get(stella.name) == ?stella);
assert(Iter.toArray(store.list(null)) == [
    (stella.name, stella),
    (vedett.name, vedett),
]);
assert(Iter.toArray(store.list(?Filter.Key.contains("Vedett"))) == [
    (vedett.name, vedett),
]);

assert(Iter.toArray(store.list(?Filter.Value.filter(
    func (b : Beer) : Bool {
        b.abv >= 5.5;
    }
))) == [
    (vedett.name, vedett),
]);
