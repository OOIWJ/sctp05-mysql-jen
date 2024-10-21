const express = require('express');
const app = express();
const hbs = require('hbs');

// Inform express that we are using HBS as view engine
// (aka template engine)
app.set("view engine", "hbs");

// ROUTES
app.get('/', function(req,res){
    res.render('hello');
});

app.listen(3000, function(){
    console.log("Server has started");
})