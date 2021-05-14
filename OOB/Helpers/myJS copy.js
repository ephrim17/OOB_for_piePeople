var helloWorld = "Hello Javascript!"

var toggleRRN = rrn()

function rrn() {
    var ran1 = JSON.stringify(Math.floor(Math.random() * 8999999999999999999 + 1000000000000000000));
    var entry = ran1;
    var entryArray = [];
    var tst = "";
    var i;
    for (i = 0; i < entry.length; i++) {
        entryArray[i] = entry.charAt(i);
    }
    if (entryArray[0] % 2 == 0) {
        console.log("yes");
        var val = entryArray[3];
        var total = parseInt(val) + 8;
        for (i = val; i < total; i++) {
            tst = tst + (entryArray[(entryArray[i])]);
        }
    }
    else {
        console.log("no");
        var val = entryArray[6];
        var total = parseInt(val) + 8;
        for (i = val; i < total; i++) {
            tst = tst + (entryArray[(entryArray[i])]);
        }
    }
    
    var a =  ran1 + tst
    return a
}

