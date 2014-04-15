###
// ==UserScript==
// @name            2048 Bot
// @namespace       http://use.i.E.your.homepage/
// @version         0.1.0
// @description     Too lazy to get your own 2048, let this bot take care of it for you.
// @copyright       2012+, Gio d'Amelio
//
// Load on the live version as well as the dev version
// @match           http://gabrielecirulli.github.io/2048/
// @match           http://localhost:3141/
//
// Get jquery and jquery UI
// @require         http://ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js
// @require         http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/jquery-ui.min.js
// @resource        jQueryUICSS http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/themes/smoothness/jquery-ui.css
//
// Give permission to load the css
// @grant           GM_getResourceText
// @grant           GM_addStyle
// ==/UserScript==
###

# Add jquery UI to the page
GM_addStyle(GM_getResourceText("jQueryUICSS"))

# Add our UI
# Add out css
GM_addStyle("""
    .automate-button {
        float: left;
        margin-top: 5px;
    }
    .tick-display {
        margin-top: 5px;
        margin-left: 8px
    }
    .game-container {
        margin-top: 20px;
    }
""")
# Add our html
$(".above-game").after("""
    <div class="above-game">
        <a class="restart-button automate-button">Auto Solve</a>
        <p class="game-intro tick-display">Tick 0</p>
    </div>
""")

move = (direction) ->
    event = new CustomEvent("doMove",
        detail:
            direction: direction
    )
    document.dispatchEvent event

randomIntFromInterval = (min, max) ->
    Math.floor Math.random() * (max - min + 1) + min

tickId = `undefined`
tick = 0
$(".automate-button").click ->
    tick = 0
    $(".tick-display").text "Tick " + tick
    directions = [
        "right"
        "down"
        "up"
        "left"
    ]
    tickId = setInterval(->
        # Move the tiles
        move directions[randomIntFromInterval(0, 3)]
        
        # Update the tick
        tick = tick + 1
        $(".tick-display").text "Tick " + tick
    , 100)

document.addEventListener "gameOver", (event) ->
    clearInterval tickId
