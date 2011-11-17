#
# Tests for utility methods.
#

module "utils"

test "extend", () ->
    source =
        one:1
        two:2

    dest =
        other : () -> false

    ok(not dest.one? and not dest.two?, "source methods don't exist")
    wolf.extend(dest, source)
    equals(dest.one, 1, "one property was copied")
    equals(dest.two, 2, "two property was copied")

test "uniqueId", () ->

    prefixes = [null, '', undefined, 'asdf', '', '', 'asdf', 'test']

    idmap = {}
    success = true
    for id in (wolf.getUniqueId(p) for p in prefixes)
        success = success and not idmap[id]?
        idmap[id] = true
    ok(success, "unique ids were generated successfully")

test "intervalIntersects", () ->

    ii = wolf.intervalIntersects

    ok(not ii([0, 1], [2, 5]), "Doesn't intersect")
    ok(ii([0, 1], [1, 2]), "Adjacent intersect")
    ok(ii([0, 2], [1, 2]), "Overlapping intersect")
    ok(ii([1, 2], [0, 2]), "Overlapping intersect both ways")
    ok(ii([1, 10], [5, 6]),"Containing intervals intersect")
    ok(ii([0, 2], [0, 2]),"Identical intervals intersect")

test "defaults", () ->
    passed = {1:1, 2:2}
    defaults = {2:3, 3:4}

    options = wolf.defaults(passed, defaults)

    equals(options[1], 1, "no default arg is passed")
    equals(options[2], 2, "passed arg isn't overridden")
    equals(options[3], 4, "missing arg has default")


