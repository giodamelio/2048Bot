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
    .hidden {
        display: none;
    }
    .ui-dialog, .ui-dialog-content, .ui-dialog-buttonpane, .ui-dialog-titlebar-close {
        background-color: #FAF8EF;
        color: #776E65;
    }
    .ui-dialog-titlebar {
        background-color: #8F7A66;
        color: #F9F6F2;
    }
""")
# Add our html
$(".above-game").after("""
    <div class="above-game">
        <a class="restart-button automate-button">Auto Solve</a>
        <p class="game-intro tick-display">Tick 0</p>
    </div>
    <div id="dialog" class="hidden" title="2048 Bot">
        <label for="algorithmPicker">Algorithm</label>
        <select id="algorithmPicker" name="algorithmPicker">
            <option value="random" selected>Random</option>
            <option value="circle">Circle (clockwise)</option>
        </select>
        <br>
        <br>
        <label for="speed">Speed (ms)</label>
        <input type="number" name="speed" id="speed" value="100" step="100">
    </div>
""")

# Handle our button
$(".automate-button").click ->
    $("#dialog").dialog(
        width: 600
        modal: true
        buttons:
            "Go": ->
                $(this).dialog("close")
                switch $("#algorithmPicker").val()
                    when "random"
                        new RandomAlgorithm $("#speed").val()
                    when "circle"
                        new CircleAlgorithm $("#speed").val()
    )

# Tha base class all the algorithms extend
class Algorithm
    constructor: (@speed) ->
        @tickId = setInterval(@tick, @speed)
        @tickCount = 0

        # Stop the algorithm when the game is over
        document.addEventListener "gameOver", (event) =>
            clearInterval(@tickId)

    tick: ->
        @tickCount = @tickCount + 1
        $(".tick-display").text("Tick " + @tickCount)

    move: (direction) ->
        @sendEvent("doMove", { "direction": direction })

    sendEvent: (name, data) ->
        event = new CustomEvent(name, { detail: data })
        document.dispatchEvent event

    randomInt: (min, max) ->
        return Math.floor(Math.random() * (max - min + 1) + min)

# Just move around randomly
class RandomAlgorithm extends Algorithm
    tick: =>
        super()
        directions = ["right", "down", "up", "left"]
        @move(directions[@randomInt(0, 3)])

# Go in a circle clockwise
class CircleAlgorithm extends Algorithm
    tick: =>
        super()
        directions = ["right", "down", "left", "up"]
        if @next?
            @move(@next)
            @next = directions[(directions.indexOf(@next) + 1) % 4]
        else
            @next = "right"
