<div align="center">

<img src="logo.png" alt="VEX" width="120" />

# VEX

### Roblox AI Agent — think, plan, execute.

<p>
  <img alt="version" src="https://img.shields.io/badge/version-1.0.0-D97757?style=for-the-badge&labelColor=1a1918" />
  <img alt="platform" src="https://img.shields.io/badge/platform-Roblox-1a1918?style=for-the-badge&labelColor=1a1918" />
  <img alt="license" src="https://img.shields.io/badge/license-MIT-1a1918?style=for-the-badge&labelColor=1a1918" />
  <img alt="status" src="https://img.shields.io/badge/status-active-D97757?style=for-the-badge&labelColor=1a1918" />
</p>

<p><em>An in-game AI agent that reads your world, writes scripts, and runs them — with a UI that feels like home.</em></p>

</div>

---

## ✦ What is VEX

VEX is a lightweight AI agent for Roblox executors. It plugs a language model straight into the running game so it can **inspect the world**, **write Lua**, **run it**, and **report back** — all from a single, Claude-style interface.

No neon. No HUD clutter. Just a quiet, minimal workspace that stays out of your way.

<br/>

## ✦ Features

<table>
<tr>
<td width="50%" valign="top">

**🧠 Smart**
- Persistent chat history per session
- Persona / system prompt you control
- Model selectable from Settings

**🛠 Tools**
- `gameInfo` — PlaceId, JobId, players, children
- `playerCount` — iterates every player in the server
- `writeScript` — saves + optionally autoruns
- `decompile` — reads client scripts (perm-gated)
- `flagSelf` — resolves your LocalPlayer

</td>
<td width="50%" valign="top">

**🎨 Interface**
- Claude-inspired dark theme
- Animated three-dot thinking bubble
- `UIGradient` accent that matches the theme
- Draggable, resizable, mobile-friendly
- Scales to any resolution via `UIScale`

**🔐 Permissions**
- Every dangerous action is opt-in
- `isfile` · `writefile` · `createfolder`
- `read_device_file` · `decompile_toread`
- `AutoRun` toggle for generated scripts

</td>
</tr>
</table>

<br/>

## ✦ Preview

```
┌──────────────────┬───────────────────────────────────────────┐
│  V  VEX    v1.0  │                                           │
│                  │            ✦                              │
│  ＋ New chat      │      Bonjour, Lucas                       │
│                  │                                           │
│  ⌂  Home         │   ┌─────────────────────────────────┐     │
│  💬 Chat         │   │  How can VEX help you today?  ↑ │     │
│  ⚒  Tools        │   └─────────────────────────────────┘     │
│  ⚙  Settings     │      Claude 4.5 Sonnet ▾   + Add context  │
│                  │                                           │
│  Recents         │                                           │
│  ● user          │                                           │
└──────────────────┴───────────────────────────────────────────┘
```

<br/>

## ✦ Install

**1.** Drop this into your executor:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/G4mg1/VexAI/main/main.lua"))()
```

**2.** The loader creates `VexAI/` locally, pulls every module from this repo, and opens the UI.

**3.** Open **Settings** → paste your [HuggingFace](https://huggingface.co/settings/tokens) API key → choose your model → toggle the permissions you're comfortable with.

<br/>

## ✦ Repo Layout

```
VexAI/
├── main.lua                    # entry point — run this
├── logo.png
├── lib/
│   ├── Theme.lua               # colors, fonts
│   ├── Icons.lua               # Remix icon fetcher + glyph fallback
│   └── UI.lua                  # full Claude-style window
├── interaction/
│   ├── AI.lua                  # HuggingFace chat completion
│   ├── Settings.lua            # persistent user config
│   ├── Permissions.lua         # perm gate + guard()
│   ├── Tools.lua               # game/script actions
│   └── Chat.lua                # wires UI ↔ AI ↔ Tools
└── data/
    ├── settings.json           # local-only after first run
    └── history.json
```

<br/>

## ✦ Permissions

VEX never touches anything unless you flip the switch.

| Permission | What it unlocks |
|---|---|
| `isfile` | Check whether a local file exists |
| `writefile` | Save AI-generated scripts to `VexAI/scripts/` |
| `createfolder` | Create folders in the workspace |
| `read_device_file` | Read local files back to the model |
| `decompile_toread` | Decompile in-game scripts for context |
| `autorun` | Automatically execute freshly generated scripts |

> **Tip:** Keep `autorun` off until you trust the model's output. Every generated script is saved to disk first — you can always inspect it before running.

<br/>

## ✦ Configuration

Settings live in `VexAI/data/settings.json` and are editable from the UI:

```json
{
  "apikey": "hf_xxx",
  "model": "openai/gpt-oss-120b:fireworks-ai",
  "persona": "You are VEX, a helpful Roblox AI agent. Be concise.",
  "perms": {
    "isfile": true,
    "writefile": false,
    "createfolder": false,
    "read_device_file": false,
    "decompile_toread": false,
    "autorun": false
  }
}
```

The file is **never overwritten by the loader** once it exists — your key stays yours.

<br/>

## ✦ Contributing

Pull requests are welcome. If you're adding a tool, keep it inside `interaction/Tools.lua` and route it through `Perms.guard(...)` so the toggle shows up automatically in Settings.

<br/>

## ✦ License

MIT — do what you want, keep the copyright notice.

<br/>

<div align="center">

<p>
  <sub>Built for people who like their AI quiet, capable, and out of the way.</sub>
</p>

<p>
  <a href="https://github.com/G4mg1/VexAI"><img alt="stars" src="https://img.shields.io/github/stars/G4mg1/VexAI?style=social" /></a>
  <a href="https://github.com/G4mg1/VexAI/issues"><img alt="issues" src="https://img.shields.io/github/issues/G4mg1/VexAI?style=social" /></a>
</p>

</div>