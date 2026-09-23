# openwrt-steam++

OpenWrt 固件 GitHub Actions 构建工程，覆盖：

- x86_64：`x86/64`
- ARM64：`armsr/armv8`
- ARMv7：`armsr/armv7`

## 云端构建

推送到 `main`、推送 `v*` 标签，或在 Actions 页面手动运行 `Build OpenWrt`。编译成功后在该次运行的 Artifacts 下载固件。

默认基于 OpenWrt `23.05.5`，手动运行时可指定其他正式版本与额外软件包。

## 本地构建

```bash
TARGET=x86/64 ARCHIVE_TARGET=x86-64 OPENWRT_VERSION=23.05.5 bash scripts/build-imagebuilder.sh
```

构建结果写入 `artifacts/`。
