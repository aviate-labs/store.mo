import Text "mo:base/Text";

module {
    public type Filter<T> = {
        key   : ?((k : Text) -> Bool);
        value : ?((t : T) -> Bool);
    };

    public module Key {
        public func contains<T>(t : Text) : Filter<T> {
            {
                key = ?(func (k : Text) : Bool {
                    Text.contains(k, #text(t));
                });
                value = null;
            };
        };
    };

    public module Value {
        public func filter<T>(value : (t : T) -> Bool) : Filter<T> {
            {
                key   = null;
                value = ?value;
            };
        };
    };

    public func filter<T>(k : Text, t: T, f : Filter<T>) : Bool {
        if (not key(k, f.key))     return false;
        if (not value(t, f.value)) return false;
        true;
    };

    private func key(k : Text, matches : ?((k : Text) -> Bool)) : Bool {
        switch (matches) {
            case (null) true;
            case (? f)  f(k);
        };
    };

    private func value<T>(t : T, matches : ?((t : T) -> Bool)) : Bool {
        switch (matches) {
            case (null) true;
            case (? f)  f(t);
        };
    }
};
