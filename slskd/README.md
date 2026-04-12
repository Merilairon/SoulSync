# slskd — Home Assistant Addon

[slskd](https://github.com/slskd/slskd) is a modern, web-based Soulseek client.  
This addon pairs with the **SoulSync** addon — downloads are written to the shared path `/share/soulsync/downloads`, which SoulSync reads automatically.

## Installation

Install the **SoulSync** addon repository first (see the SoulSync README), then install this addon from the same store entry.

## Configuration

| Option                 | Default                     | Description                                         |
| ---------------------- | --------------------------- | --------------------------------------------------- |
| `api_key`              | `change-me-to-a-secret-key` | API key for slskd. **Change this before starting!** |
| `timezone`             | `Europe/Brussels`           | System timezone (e.g. `America/New_York`)           |
| `remote_configuration` | `true`                      | Allow configuration changes via the slskd Web UI    |

## Connecting SoulSync to slskd

Once both addons are running, open the **SoulSync** Web UI and go to **Settings → Soulseek**.  
Set the slskd URL to:

```
http://localhost:5030
```

> `localhost` works because both addons run in the same HA network.

Set the **API key** to the value you configured above, then click **Test Connection**.

## Storage layout

| Path inside addon            | Contents                                     |
| ---------------------------- | -------------------------------------------- |
| `/data/slskd/`               | slskd config, database, incomplete downloads |
| `/share/soulsync/downloads/` | Completed downloads — shared with SoulSync   |
