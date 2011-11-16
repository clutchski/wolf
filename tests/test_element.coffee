#
# Tests for the Element class.
#


module "Element"


test "mass", () ->
    e = new timber.Rectangle()
    ok(e.mass, "mass has a default value")
    e.mass = 10
    equals(e.mass, 10, "mass is settable")
    equals(e.getInverseMass(), 1/10, "inverse mass works")

