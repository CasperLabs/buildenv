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
- This needs metapackages (of the same version supplied as input) to be present under `$BINTRAY_HOME` as configured in `./release_downloader.sh`:

```
BINTRAY_HOME=/opt/bintray
DEB_META_PATH="${BINTRAY_HOME%/}/artifacts/casperlabs_${DEB_META_VERSION}_all.deb"
RPM_META_PATH="${BINTRAY_HOME%/}/artifacts/rpmbuild/RPMS/x86_64/casperlabs-${RPM_META_VERSION}.x86_64.rpm"
```

- Run:

```
./release_downloader.sh v0.8.1
```


### Bintray upload

- Set appropriate config in `package_config.yaml`

- Set env vars needed for the script:

```
export BINTRAY_USER=username
export BINTRAY_KEY=your_api_key
export BINTRAY_ADMIN_GPG_PASSPHRASE=your_Gpg_passphrase

export PLUGIN_BINTRAY_CFG=/opt/bintray/package_config.yaml

export SIGN_PACKAGE=false
export UPLOAD_PACKAGE=true
export CALC_META=false
export SHOW_PACKAGE=false

```

- Run `/opt/bintray/bintray` from that bash environment.


- Alternatively, you could store the above environment exports to a `.env` file and run the bintray plugin as:

```
PLUGIN_ENV_FILE=~/.env ./release/linux/amd64/drone-bintray
```


Run script:

```
./bintray package_config_new.yaml

```
