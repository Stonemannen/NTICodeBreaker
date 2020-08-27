const fs = require('fs');

var express = require("express");
var app = express();
app.listen(3050, () => {
 console.log("Server running on port 3050");
});


let rawdata = fs.readFileSync('data.txt');
let data= JSON.parse(rawdata);

var roundRobin = 0

app.get("/start", (req, res, next) => {
    
    res.json([data[roundRobin]])
    roundRobin+=1
    if(roundRobin == 10){
        roundRobin = 0
    }
}   );

app.get("/increment", (req, res, next) => {
    var code = req.query.code

    data[code.toString()[0]]++
    
    fs.writeFile("data.txt", JSON.stringify(data), ()=>{})

    res.sendStatus(200);
}   );


app.get("/code", (req, res, next) => {


    data[roundRobin]++
    
    roundRobin+=1
    if(roundRobin == 10){
        roundRobin = 0
    }

    fs.writeFile("data.txt", JSON.stringify(data), ()=>{})

    res.send("<html>\n    <head>\n    </head>\n <body>\n      <h1>" + data[roundRobin] + "</h1>\n  <button onClick=\"window.location.reload();\">Next</button> </body>\n</html>");
}   );