// First line must be a comment.
// https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig

// Unbind annoying default keyboard shortcuts.
// http://forums.mozillazine.org/viewtopic.php?f=38&t=3037369
// https://developer.mozilla.org/en-US/docs/Mozilla/JavaScript_code_modules/Services.jsm
// https://developer.mozilla.org/en-US/docs/Mozilla/Tech/XPCOM/Reference/Interface/nsIObserverService
Components.utils.import("resource://gre/modules/Services.jsm");
Services.obs.addObserver(function (aSubject, aTopic, aData) {
  var chromeWindow = aSubject;
  chromeWindow.document.getElementById("key_newNavigator").remove();
  chromeWindow.document.getElementById("key_search").remove();
  chromeWindow.document.getElementById("key_search2").remove();
}, "browser-delayed-startup-finished", false);

// Disable telemetry.
// https://github.com/The-OP/Fox/issues/156
// https://bugzilla.mozilla.org/show_bug.cgi?id=1422689
lockPref("toolkit.telemetry.enabled", false);
