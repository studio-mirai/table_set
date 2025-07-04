module table_set::table_set;

use sui::table::{Self, Table};

public struct TableSet<phantom K: copy + drop + store> has store {
    contents: Table<K, bool>,
}

const EKeyAlreadyExists: u64 = 0;
const EKeyDoesNotExist: u64 = 1;

public fun empty<K: copy + drop + store>(ctx: &mut TxContext): TableSet<K> {
    TableSet {
        contents: table::new(ctx),
    }
}

public fun singleton<K: copy + drop + store>(key: K, ctx: &mut TxContext): TableSet<K> {
    let mut contents = table::new(ctx);
    contents.add(key, true);
    TableSet { contents }
}

public fun insert<K: copy + drop + store>(self: &mut TableSet<K>, key: K) {
    assert!(!self.contents.contains(key), EKeyAlreadyExists);
    self.contents.add(key, true);
}

public fun insert_bulk<K: copy + drop + store>(self: &mut TableSet<K>, keys: vector<K>) {
    keys.destroy!(|key| self.insert(key));
}

public fun remove<K: copy + drop + store>(self: &mut TableSet<K>, key: K) {
    assert!(self.contents.contains(key), EKeyDoesNotExist);
    self.contents.remove(key);
}

public fun remove_bulk<K: copy + drop + store>(self: &mut TableSet<K>, keys: vector<K>) {
    keys.destroy!(|key| self.remove(key));
}

public fun contains<K: copy + drop + store>(self: &TableSet<K>, key: K): bool {
    self.contents.contains(key)
}

public fun size<K: copy + drop + store>(self: &TableSet<K>): u64 {
    self.contents.length()
}

public fun is_empty<K: copy + drop + store>(self: &TableSet<K>): bool {
    self.contents.is_empty()
}

public fun destroy<K: copy + drop + store>(self: TableSet<K>) {
    let TableSet { contents } = self;
    contents.drop();
}
