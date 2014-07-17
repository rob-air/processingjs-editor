define(function(require, exports, module) {
"use strict";

var oop = require("../lib/oop");
var JavaScriptMode = require("./javascript").Mode;
var JavaprocessingHighlightRules = require("./javaprocessing_highlight_rules").JavaHighlightRules;

var Mode = function() {
    JavaScriptMode.call(this);
    this.HighlightRules = JavaprocessingHighlightRules;
};
oop.inherits(Mode, JavaScriptMode);

(function() {
    
    this.createWorker = function(session) {
        return null;
    };

    this.$id = "ace/mode/javaprocessing";
}).call(Mode.prototype);

exports.Mode = Mode;
});
