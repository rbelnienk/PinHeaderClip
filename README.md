# PinHeaderClip

A little bridge/staple clip for the 2.54&nbsp;mm (0.1&quot;) pin-header grid,
reverse-engineered from `clipsingle.3mf` into a parametric OpenSCAD model plus a
browser configurator.

## Files

| File | What |
|------|------|
| `clipsingle.scad` | The parametric model (OpenSCAD). |
| `clipsingle.3mf`  | The original mesh it was reverse-engineered from. |
| `docs/index.html` | Web configurator (Three.js) with live 3D preview + STL download. |

## Parameters (`clipsingle.scad`)

| Name | Meaning | Default |
|------|---------|---------|
| `count` | Number of channels side-by-side (2.54 mm pitch, walls touching). | `1` |
| `span` | Clear length between the two feet (mm). | `17.80` |
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
