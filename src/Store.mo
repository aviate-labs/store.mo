import Iter "mo:base/Iter";
import List "mo:base/List";
import Text "mo:base/Text";
import Trie "mo:base/Trie";

import Filter "Filter";

module {
    public class Store<T>() {
        private let equal = Text.equal;
        private let hash  = Text.hash;
        private var data  = Trie.empty<Text, T>();
        private var key   = func (k : Text) : Trie.Key<Text> {
            { key = k; hash = hash(k) };
        };

        public func put(k : Text, v : T) : ?T {
            let (d, t) = Trie.replace(data, key(k), equal, ?v);
            data := d; t;
        };

        public func get(k : Text) : ?T {
            Trie.get(data, key(k), equal);
        };

        public func delete(k : Text) : ?T {
            let (d, t) = Trie.replace(data, key(k), equal, null);
            data := d; t;
        };

        public func list(f : ?Filter.Filter<T>) : Iter.Iter<(Text, T)> {
            switch (f) {
                case (null) Trie.iter(data);
                case (? f) {
                    object {
                        var stack : List.List<Trie.Trie<Text, T>> = ?(data, null);
                        public func next() : ?(Text, T) {
                            switch (stack) {
                                case (null) null;
                                case (? (t, s)) {
                                    switch (t) {
                                        case (#empty) {
                                            stack := s;
                                            next();
                                        };
                                        case (#branch(b)) {
                                            stack := ?(b.left, ?(b.right, s));
                                            next();
                                        };
                                        case (#leaf({ keyvals = null})) {
                                            stack := s;
                                            next();
                                        };
                                        case (#leaf({
                                            size;
                                            keyvals = ?((k, v), kvs);
                                        })) {
                                            stack := ?(#leaf({
                                                size = size - 1;
                                                keyvals = kvs;
                                            }), s);
                                        
                                            // Filtering.
                                            if (Filter.filter(k.key, v, f)) {
                                                ?(k.key, v);
                                            } else {
                                                next();
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        };
    };
};
