# CODAv

An "XML message for Credit Transfer Initiation" (ISO 20022 XML) file encodes European credit transfers (SEPA) in a standard way. It's often refered to as a "CODA (Coded Statement of Account) file". It requests the movement of funds from the debtor account to a creditor.

CODAv is a desktop application that understands these electronic messages and serves as a viewer to verify the contents of these files. CODAv follows the [Belgian implementation guidelines](https://www.febelfin.be/sites/default/files/files/standard-credit_transfer-xml-v31-en_0.pdf) as defined by the Belgian sector federation [Febelfin](https://www.febelfin.be).

![Screenshot](data/Screenshot.png)

The current itteration shows all fields from the CODA XML in a table view like one would expect on a spreadsheet. A sperate panel shows the header fields and the sum of all transactions per currency.

## Install

CODAv is tested on Ubuntu 16.04, 17.10, 18.04, and macOS Sierra. It's written in Vala and depends on GTK 3 and libxml 2. [Download](https://github.com/cimm/codav/archive/master.zip) or [clone](https://github.com/cimm/codav.git) the repository and run the following from within its root directory.

### Linux

Install the dpendencies first, we use the Vala repository for a more recent Vala version.

```
sudo add-apt-repository -yu ppa:vala-team
sudo apt install valac libgtk-3-dev libxml2-dev cmake
```

Now build and install CODAv:

```
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
sudo make install
```

### macOS

Make sure you have [Homebrew](https://brew.sh/) to install the dependencies:

```
brew install gtk+3 adwaita-icon-theme vala cmake
```

Now build and install CODAv:

```
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
sudo make install
```

## Development

Some useful notes for the development of this application, not needed to actually run it.

### Snapcraft

You'll need [snapcraft](https://snapcraft.io/) to build the snap yourself, the `snapcraft.yaml` file contains the snap build instructions and can be found in the `/snap` directory. Run `snapcraft cleanbuild` from the project's root directory of the project, not from within the `/snap` directory, it will download the necessary dependencies and spit out the snap package. You'll need [LXD](https://docs.snapcraft.io/build-snaps/build-on-lxd-docker) to build the snap with cleanbuild (it uses a container).

You can try out the local snap with:

```bash
snap install codav_0.1_*.snap --dangerous
```
