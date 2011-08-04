(function () {

  var circles = {}; // Root object

  this.circles = circles; // Add to global namespace

        var c = new timber.Canvas("circles");
        var e = new timber.Environment();

        var engine = new timber.Engine(c, e);

        var p = new timber.Point(0, 0);
        var d = new timber.Vector(1, 1).normalize();
        var circle = new timber.Circle(p, d, 0.4, 100);
        c.add(circle);

        engine.run()
 
















})();
