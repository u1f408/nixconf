# nixconf

## update existing machine

```
nixos-rebuild switch --flake .#hostname --target-host root@hostname --build-host root@hostname --use-remote-sudo --substitute-on-destination 
```

## install new machine

* boot into NixOS install media, configure networking, set a password for `root`
* set up partitioning, mount everything under `/mnt` as normal
* on the new machine, run `nixos-generate-config --root /mnt` and copy the resulting `/mnt/etc/nixos/hardware-configuration.nix` into the system dir in this repo

then, to run the install:

```
nix run github:nix-community/nixos-anywhere -- --flake .#hostname --phases install root@ipaddress
```

check everything looks good, then reboot
