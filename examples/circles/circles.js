(function () {

    var circles = {}; // Root object

    this.circles = circles; // Add to global namespace

    circles.run = function () {
        var engine = new timber.Engine("circles");
        var p = new timber.Point(0, 0);
        var d = new timber.Vector(1, 1).normalize();
        var circle = new timber.Circle(p, d, 0.4, 100);
        engine.add(circle);
        engine.run();
    };

})();
