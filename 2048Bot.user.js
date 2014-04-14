// ==UserScript==
// @name            2048 Bot
// @namespace       http://use.i.E.your.homepage/
// @version         0.1.0
// @description     Too lazy to get your own 2048, let this bot take care of it for you.
// @match           http://gabrielecirulli.github.io/2048/
// @match           http://localhost:3141/
// @copyright       2012+, Gio d"Amelio
// @require         http://ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js
// ==/UserScript==

// Add our button
$(".above-game").after("<div class=\"above-game\"><a class=\"restart-button automate-button\">Auto Solve</a><p class=\"game-intro tick-display\">Tick 0</p></div>");
$(".automate-button").css("float", "left");
$(".automate-button").css("margin-top", "5px");
$(".tick-display").css("margin-left", "8px");
$(".tick-display").css("margin-top", "5px");
$(".game-container").css("margin-top", "20px");

var move = function(direction) {
    var event = new CustomEvent("move", { "detail": { "direction": direction} })
    document.dispatchEvent(event);
}

var randomIntFromInterval = function randomIntFromInterval(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}

$(".automate-button").click(function() {
    var tick = 1;
    var directions = ["right", "down", "up", "left"];
    setInterval(function() {
        // Move the tiles
        move(directions[randomIntFromInterval(0, 3)]);

        // Update the tick
        $(".tick-display").text("Tick " + tick);
        tick = tick + 1;
    }, 500);
});
