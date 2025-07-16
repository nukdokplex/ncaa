{ ... }:
{
  attrsToListRecursive =
    tree:
    let
      # acc - accumulator, it's the result we assemble
      # path - the current path, in result it must end with a tree leaf
      # value - the current value, it can be a leaf, or another tree of trees and leaves.

      # notice that this function doesn't return empty trees without any leaves, if you want them so you can use attrsToListRecursive'

      op =
        acc: path: value:
        # current value is attrset so we recurse into it
        if (builtins.isAttrs value) then
          (recurse acc path value)
        # current value is not an attrset
        # this is a leaf of a tree so we return accumulator + this leaf
        else
          acc ++ [ { inherit path value; } ];

      recurse =
        acc: path: value:
        builtins.foldl' (acc: key: op acc (path ++ [ key ]) value.${key}) acc (builtins.attrNames value);

    in
    recurse [ ] [ ] tree;

  attrsToListRecursive' =
    tree:
    let
      # acc - accumulator, it's the result we assemble
      # path - the current path, in result it must end with a tree leaf
      # value - the current value, it can be a leaf, or another tree of trees and leaves.

      # notice that this function returns empty trees without any leaves, if you don't want them so you can use attrsToListRecursive (without ' at the end)

      op =
        acc: path: value:
        # the current value is leaf or empty tree so we add it to accumulator and return
        if ((!builtins.isAttrs value) || (value == { })) then
          acc ++ [ { inherit path value; } ]
        # this is non-empty tree (negotiation of logic below)
        else
          (recurse acc path value);

      recurse =
        acc: path: value:
        builtins.foldl' (acc: key: op acc (path ++ [ key ]) value.${key}) acc (builtins.attrNames value);

    in
    recurse [ ] [ ] tree;
}
