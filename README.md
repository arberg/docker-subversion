# Docker Subversion

## Compose Manager Plus

Copy `.env.example` to `.env`, review the existing Unraid paths and isolated
subnet, then deploy `compose.yaml` through Compose Manager Plus. The stack
publishes the Subversion protocol at `svn://<unraid-host>:3690` by default; it
does not provide a web interface.

The Compose stack preserves the isolated deployment used by
`run-isolated.sh`. Run `install-network-isolation.sh` once after deployment and
again after every Unraid reboot because Unraid does not preserve those firewall
rules.

Build and release new image and rerun updated isolated version:
```bash
./release.sh
./run-isolated.sh
```

Build and run normal image:

```bash
./build.sh
./run.sh
```

Build and run isolated image:

```bash
./build.sh
./run-isolated.sh
```

Run this once, and rerun after UnRaid reboot, as unRaid does not preserve docker rules across reboots:
```bash
./install-network-isolation.sh
```

`build.sh` produces these tags:

- `arberg/subversion:latest`
- `arberg/subversion:<svn-version>`
- `arberg/subversion:latest-isolated`
- `arberg/subversion:<svn-version>-isolated`

The isolated image is built from `arberg/subversion:latest` and adds the network-checking entrypoint plus the required network tools.
