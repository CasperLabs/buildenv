# Usage

### Metapackager

Inside the buildenv container:

```
cd /opt/bintray/artifacts

# edit configs for latest versions

# build RPM metapackages
rpmbuild -bb rpmbuild/SPECS/casperlabs-all.spec -D "_topdir $(pwd)/rpmbuild"  -D "SRC $(pwd)"

# build Debian metapackages
equivs-build  deb_build/casperlabs_all.cfg
```


### Github Release download

- This downloads packages to `./upload` in CWD.
- This needs metapackages (of the same version supplied as input) to be present in `$BINTRAY_HOME` as configurable in the script itself.

```
./release_downloader.sh v0.8.1
```


### Bintray upload

Set config in `package_config_new.yaml`

Set env vars needed for the script:

```
export BINTRAY_USER=username
export BINTRAY_KEY=your_api_key
export BINTRAY_ADMIN_GPG_PASSPHRASE=your_Gpg_passphrase
```

Run script:

```
./bintray package_config_new.yaml

```
