## Device Tree Runtime Overlay

onion-dt-overlay provides device tree runtime overlay without rebuilding firmware image giving flexibility to the user for easy customization of device tree.

### Add custom device tree package.

Onion Omega2 package onion-dt-overlay has a wrapper to build a device tree overlay package. Here are the steps that can be performed to add a custom device tree overlay.

1. Add a custom `.dts` file into the `src` directory. Make sure the file extension is `.dts` only.
2. Edit Makefile and add a new line after the last line

```bash
$(eval $(call BuildDtbo,<dtbo src file without ext>,<list of dependency packages>,<package description>))
```
### Example Dtbo

Assume, the user wants to add a custom device tree runtime overlay package named `example`.
- Create a file `src/example.dts`
- Edit the Makefile of the onion-dt-overlay package and add a new line after the last line that looks like

```bash
$(eval $(call BuildDtbo,example,,Example DTBO))
```

It will create a new package named `onion-dt-overlay-example`.

- After package is compiled and installed on omega2, it will install a `dtbo` file on location `/lib/firmware/device-tree/overlays/example.dtbo`.
- reboot omega2.

### Validate Runtime Dtbo

- The status of `dtbo` can be check from a file `/sys/kernel/config/device-tree/overlays/<dtbo>/status`
- In the case of `example.dtbo`, If would show its `status` as `applied`

```bash
# cat /sys/kernel/config/device-tree/overlays/example/status
applied
```
