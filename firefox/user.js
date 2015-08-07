// to be symlinked to ~/.mozilla/firefox/*/

// disable pdf.js
user_pref("pdfjs.disabled", true);

// suppress fullscreen notification
user_pref("full-screen-api.approval-required", false);

// enhance privacy/security
user_pref("privacy.donottrackheader.enabled", true);
user_pref("beacon.enabled", false);
user_pref("geo.enabled", false);
user_pref("loop.enabled", false);
user_pref("browser.pocket.enabled", false);
user_pref("browser.formfill.enable", false);
user_pref("browser.cache.disk.enable", false);
user_pref("network.prefetch-next", false);
user_pref("network.dns.disablePrefetch", true);
