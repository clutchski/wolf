var page = new WebPage();

page.onConsoleMessage = function (msg) {
    console.log(msg);
};

page.open(phantom.args[0], function (status) {
    
    var timer = setTimeout(function() {
        page.evaluate(function () {
            var result_el = document.getElementById('qunit-testresult');
            if(typeof result_el !== 'undefined' && result_el !== null) {
              try {
                var passed = result_el.getElementsByClassName('passed')[0].innerHTML;
                var total = result_el.getElementsByClassName('total')[0].innerHTML;
                var failed = result_el.getElementsByClassName('failed')[0].innerHTML;
                console.log(" ");
                console.log(" ");
                console.log(" ");
                console.log("Failures");
                
                console.log(" ");
                var listItems = $(".fail").each(function() {
                    
                    console.log($(this).text());
                    console.log(" ");
                });
              } catch(e) {
                console.info("Errors: ");
                console.error(e);
              }
              
              console.log('Passed: '+passed + ', Failed: '+ failed + ' Total: '+ total);

            } 
        });
        

        phantom.exit();
    
    }, 500);
});
