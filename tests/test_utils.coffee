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
    timber.extend(dest, source)
    equals(dest.one, 1, "one property was copied")
    equals(dest.two, 2, "two property was copied")

test "uniqueId", () ->

    prefixes = [null, '', undefined, 'asdf', '', '', 'asdf', 'test']

    idmap = {}
    success = true
    for id in (timber.getUniqueId(p) for p in prefixes)
        success = success and not idmap[id]?
        idmap[id] = true
    ok(success, "unique ids were generated successfully")

