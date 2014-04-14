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
$(".above-game").after("<div class=\"above-game\"><a class=\"restart-button automate-button\">Auto Solve</a></div>");
$(".automate-button").css("float", "left");
$(".automate-button").css("margin-top", "5px");
$(".game-container").css("margin-top", "20px");

var move = function(direction) {
    var event = new CustomEvent("move", { "detail": { "direction": direction} })
    document.dispatchEvent(event);
}

$(".automate-button").click(function() {
    move("right");
});
