# Wake Lock

A minimal, single-file example of the [Screen Wake Lock API](https://developer.mozilla.org/en-US/docs/Web/API/Screen_Wake_Lock_API). It requests a screen wake lock to keep the display from sleeping while a continuous `requestAnimationFrame` animation runs in the page.

## Why use a wake lock

By default, browsers and operating systems aggressively dim and sleep the display to save power. That's the right default for reading a static page — but it's the wrong default for a page that the user is actively *watching* without touching the keyboard or mouse. When the screen sleeps:

- `requestAnimationFrame` is throttled or paused, so animations stutter or stop.
- `<video>` and `<canvas>` rendering halts.
- Background audio may continue, but the visual output the user came for is gone.
- Long-running flows (timers, presentations, recipes, dashboards) get interrupted, forcing the user to wake the device and re-orient.

The Screen Wake Lock API lets a page tell the OS "keep the screen on while I'm visible." It's scoped to the tab, automatically released when the tab is hidden, and respects user/system power policies — so it's a much safer alternative to legacy hacks like playing a silent video loop or jiggling the mouse cursor.

## When to use it

Good fits:

- **Continuous rendering** — animations, simulations, generative art, live charts/dashboards, real-time data viz.
- **Media playback that isn't `<video>`** — `<video>` already keeps the screen awake; canvas/WebGL/WebGPU playback does not.
- **Hands-free reading** — recipes, sheet music, lyrics, teleprompters, workout timers, exercise/yoga guides.
- **Presentations & kiosks** — slide decks, signage, status boards, retail displays.
- **Navigation & tracking** — maps, GPS-driven views, run/ride tracking where the user glances at the screen but doesn't tap.
- **Long-running operations with visible progress** — uploads, exports, builds, or scans where the user wants to watch progress without touching the device.
- **Video calls and conferencing UIs** built on canvas/WebRTC custom rendering surfaces.

When **not** to reach for it:

- Passive reading of static content — let the screen sleep; that's what the user expects.
- Background work with no visible UI — use a Service Worker, `Web Workers`, or `navigator.locks` instead. Wake Lock keeps the *screen* on, not the page running.
- As a substitute for `<video>`'s built-in behavior — native video already prevents sleep during playback.
- Anything that should run while the tab is hidden — wake locks are released the moment visibility is lost.

## What this page does

- Requests a `'screen'` wake lock via `navigator.wakeLock.request()` when the user clicks **Enable Wake Lock**.
- Releases the lock on demand via **Release Wake Lock**.
- Re-acquires the lock automatically when the page becomes visible again (locks are released by the browser when the tab is hidden).
- Renders a moving dot driven by `requestAnimationFrame` so you can visually confirm the page is still rendering.
- Surfaces wake-lock state and errors in a status panel.

## Files

- [src/wake_lock.html](src/wake_lock.html) — the entire example (HTML, CSS, and JS in one file).

## Running it

The Wake Lock API requires a **secure context** — either `https://` or `http://localhost`. Opening the file directly via `file://` will not work in most browsers.

The quickest path:

```bash
./start.sh
```

That serves `src/` over `http://localhost:8000` with Python's built-in HTTP server and opens [http://localhost:8000/wake_lock.html](http://localhost:8000/wake_lock.html) in your default browser. Press `Ctrl+C` to stop.

Or run a server manually:

```bash
# Python 3
python3 -m http.server 8000 --directory src

# Node (npx, no install)
npx --yes http-server src -p 8000

# PHP
php -S localhost:8000 -t src
```

Then open <http://localhost:8000/wake_lock.html>.

Click **Enable Wake Lock**. The status panel should read `Wake lock is active.` Your screen should stay awake as long as the tab is visible.

## Browser support

`navigator.wakeLock` is available in modern Chromium-based browsers, Safari 16.4+, and Firefox 126+. The page falls back to a status message (`Wake Lock API is not supported in this browser.`) on unsupported browsers.

## Notes & caveats

- A wake lock is automatically released when the tab is hidden, the browser is minimized, or the device's power state changes. The page re-acquires the lock on `visibilitychange` when it becomes visible.
- Some platforms ignore wake locks under low battery or power-saver mode.
- Drop the script into your own page and adapt as needed.

## License

[MIT](LICENSE) © Srini Karlekar
