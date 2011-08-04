(function () {

    var circles = {}; // Root object

    this.circles = circles; // Add to global namespace


    var engine = new timber.Engine("circles");
    var logger = new timber.Logger("app");

    circles.addNew = function () {
        var p = new timber.Point(0, 0);
        var d = new timber.Vector(1, 1).normalize();
        var circle = new timber.Circle(p, d, 1, 100);
        engine.add(circle);
    };

    circles.handleKeypress = function (event) {
        var key = (event.which) ? event.which : e.keyCode;
        logger.debug("keypress: " + event.which);

        if (key === 78) {
           circles.addNew();
        } else {
            var x, y;
            for (var i=0; i<engine.elements.length; i++) {
              do {
                x = Math.random() * 2 - 1;
                y = Math.random() * 2 - 1;
              } while (x === 0 || y === 0);
              engine.elements[i].direction = new timber.Vector(x,
                  y).normalize();
            }
        }
    };

    circles.run = function () {
        $(document).keydown(circles.handleKeypress);
        engine.run();
    };

})();
