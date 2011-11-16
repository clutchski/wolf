#
# Tests for the Element class.
#


module "Element"


class TestElement extends timber.Element

    @key = 'TestElement'


test "mass", () ->
    e = new TestElement()
    ok(e.mass, "mass has a default value")
    e.mass = 10
    equals(e.mass, 10, "mass is settable")
    equals(e.getInverseMass(), 1/10, "inverse mass works")



