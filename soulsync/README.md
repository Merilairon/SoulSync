# SoulSync — Home Assistant Addon

Intelligent music discovery and automation platform that bridges Spotify to your local media server (Plex, Jellyfin, Navidrome).

## Features

- **Discovery**: Release Radar, Discovery Weekly, seasonal playlists, 12+ personalised playlists
- **Downloads**: 6 sources — Soulseek, Deezer, Tidal, Qobuz, HiFi, YouTube — with automatic quality fallback
- **Audio Verification**: AcoustID fingerprinting
- **Metadata Enrichment**: 10 workers (Spotify, MusicBrainz, iTunes, Deezer, Discogs, AudioDB, Last.fm, Genius, Tidal, Qobuz)
- **Automation Engine**: Visual drag-and-drop workflow builder
- **Media Server Sync**: Plex, Jellyfin, Navidrome
- **Listening Stats**: Dashboard with charts, Last.fm / ListenBrainz scrobbling
- **Built-in Player**: Queue system, smart radio mode, ambient visualiser

## Installation

1. In Home Assistant, go to **Settings → Add-ons → Add-on Store**.
2. Click the three-dot menu (⋮) → **Repositories**.
3. Add the URL of this repository and click **Add**.
4. The **SoulSync** addon will appear — click **Install**.

## Configuration

| Option      | Default           | Description                               |
| ----------- | ----------------- | ----------------------------------------- |
| `timezone`  | `Europe/Brussels` | System timezone (e.g. `America/New_York`) |
| `log_level` | `info`            | Logging verbosity                         |

All other settings (Spotify API keys, download sources, media server URLs, etc.) are configured through SoulSync's own web UI after the addon starts.

## Storage layout

| Path inside addon            | HA mapping    | Contents                           |
| ---------------------------- | ------------- | ---------------------------------- |
| `/data/config/config.json`   | addon-private | SoulSync configuration             |
| `/data/music_library.db`     | addon-private | Music library database             |
| `/data/logs/`                | addon-private | Application logs                   |
| `/share/soulsync/downloads/` | `/share`      | Raw downloads from Soulseek / etc. |
| `/share/soulsync/staging/`   | `/share`      | Import staging folder              |
| `/media/soulsync/`           | `/media`      | Organised music destination        |

## OAuth callbacks (Spotify & Tidal)

Spotify and Tidal redirect users back to SoulSync after authentication.  
Enable the optional ports in the addon's **Network** tab:

| Port | Service                |
| ---- | ---------------------- |
| 8888 | Spotify OAuth callback |
| 8889 | Tidal OAuth callback   |

Then make sure these ports are reachable from the internet (port-forward on your router, or use Nabu Casa remote access).

In the Spotify Developer Dashboard, set the redirect URI to:  
`http://<your-ha-ip>:8888/callback`

## Using slskd (Soulseek) alongside SoulSync

Install the **slskd** addon from this same repository.  
Once it's running, go to **SoulSync → Settings → Soulseek** and set:

| Field     | Value                                          |
| --------- | ---------------------------------------------- |
| slskd URL | `http://localhost:5030`                        |
| API key   | _(the key you set in the slskd addon options)_ |

Downloads land in `/share/soulsync/downloads/`, which SoulSync reads automatically.

## Support

- [GitHub repository](https://github.com/baetensjan/SoulSync)
- Open an issue for bug reports or feature requests
