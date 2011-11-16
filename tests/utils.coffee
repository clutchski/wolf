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

