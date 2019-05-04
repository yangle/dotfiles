# Firefox customizations

To enable the customizations, make symlinks to `chrome/` and `user.js` under
`~/.mozilla/firefox/*/`.

To unbind annoying [default shortcuts][shortcuts] in the current window, press
<kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>J</kbd> to open a Browser Console and
execute

```javascript
document.getElementById("key_newNavigator").remove();  // Ctrl-N
document.getElementById("key_search").remove();        // Ctrl-K
document.getElementById("key_search2").remove();       // Ctrl-J
```

To permanently disable these shortcuts (if you have root access), copy the
files under `autoconfig/` to `$(dirname $(realpath $(which firefox-nightly)))`.
This also [disables telemetry][telemetry],
which [cannot be done][telemetry-lock] through `user_pref`.

[shortcuts]: https://searchfox.org/mozilla-central/source/browser/base/content/browser-sets.inc
[telemetry]: https://github.com/The-OP/Fox/issues/156
[telemetry-lock]: https://bugzilla.mozilla.org/show_bug.cgi?id=1422689
