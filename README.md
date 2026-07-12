# PinHeaderClip

**A free, 3D-printable clip that stops loose female pin-header connectors from
vibrating or pulling off your 2.54&nbsp;mm (0.1&Prime;) male pin headers.**

Female pin-header connectors — the small black plastic housings (often called
Dupont connectors, jumper wire housings, or crimp housings) that plug onto
2.54&nbsp;mm male pin headers — are notoriously loose. There's no real latch
holding them on: a light tug on the wires, vibration from a fan or motor, or
just routing the cable the wrong way is enough for the connector to work
partway off the pins, causing an intermittent or dead connection. That's a
common headache on 3D printers, robots, RC vehicles, drones, and any project
that moves, vibrates, or gets handled.

PinHeaderClip is a small bridge-shaped part with a fork-shaped foot at each
end that snaps around the base of the male pin header, on either side of the
female connector, pinning the whole housing down against the board so it
can't lift, wiggle loose, or get pulled off by wire tension.

**Live configurator:** https://rbelnienk.github.io/PinHeaderClip/

## Files

| File | What |
|------|------|
| `clipsingle.scad` | The parametric model (OpenSCAD). |
| `clipsingle.3mf`  | The original mesh it was reverse-engineered from. |
| `docs/index.html` | Web configurator (Three.js) with live 3D preview + STL download. |

## How to use the generator

1. **Set "Number of Pins"** to match the width of your connector (how many pins across).
2. **Set "Length between PCB bottom and Female Pin Header Top"** — measure this
   on your assembled board (the configurator has a built-in diagram — click the
   **(i)** icon next to the field). This tells the clip how tall it needs to be
   to reach from the underside of the PCB up to the top of your female header.
3. **Optional — "More options"** for less common setups:
   - **Pin-header rows** — switch to 2 rows for a double-row (2×N) header; the fork tines get twice as deep to reach both rows.
   - **Offset** — extra tine length if your pin header sits set back from the PCB edge.
   - **Close one foot** — turns one end into a solid stop instead of an open channel, so the clip only slides on from one side.
   - **Pad outer tines to full width** — keeps the two end tines the same width as the shared middle tines when generating multiple channels side by side.
4. **Click "Download STL"** and slice it.

## Recommended print settings

| Setting | Recommendation |
|---|---|
| Filament | **PETG** — a little more flexible and layer-adhesive than PLA, which matters here: the fork tines need to flex slightly to snap over the header without cracking. PLA is more brittle and more likely to snap a thin tine. |
| Nozzle | **0.4&nbsp;mm works fine**; a smaller 0.2–0.3&nbsp;mm nozzle gives slightly crisper detail on the small fork/slot features. |
| Layer height | 0.1–0.15&nbsp;mm |
| Supports | None needed — it prints flat on its back with the forks facing up. |

## Parameters (`clipsingle.scad`)

| Name | Meaning | Default |
|------|---------|---------|
| `count` | Number of channels side-by-side (2.54 mm pitch, walls touching). | `1` |
| `span` | Clear length between the two feet (mm). | `17.80` |
| `rows` | Pin-header rows to grip; `2` doubles the fork-tine depth for a stacked two-row header. | `1` |
| `offset` | Extra fork-tine length (mm) added on top of `rows`. | `0` |
| `close_foot` | Floor one foot's channels into a stop: `"start"`, `"end"`, `"none"`. | `"start"` |
| `cap_thickness` | Thickness of that floor (mm). | `0.40` |
| `equal_end_tines` | Pad the outer tines to the full (doubled) width of the inner ones. | `true` |

Override on the command line, e.g.:

```bash
openscad -o clip.stl -D 'count=4' -D 'span=25' -D 'close_foot="start"' clipsingle.scad
```

## Web configurator

Open `docs/index.html` locally (just double-click it), or publish it with
**GitHub Pages**:

1. Push this repo to GitHub.
2. **Settings → Pages → Build and deployment**.
3. Source: **Deploy from a branch**. Branch: **main**, folder: **/docs**. Save.
4. After a minute the configurator is live at
   `https://<user>.github.io/<repo>/`.

The page is fully static — it builds the mesh in the browser (Three.js from a
CDN) and exports a binary STL. No server or build step. Verified to produce the
same geometry as `clipsingle.scad`.
