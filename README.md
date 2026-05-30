# Docker Subversion

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
