# CODAv

An "XML message for Credit Transfer Initiation" (ISO 20022 XML) file encodes European credit transfers (SEPA) in a standard way. It's often refered to as a "CODA (Coded Statement of Account) file". It requests the movement of funds from the debtor account to a creditor.

CODAv is a desktop application that understands these electronic messages and serves as a viewer to verify the contents of these files. CODAv follows the [Belgian implementation guidelines](https://www.febelfin.be/sites/default/files/files/standard-credit_transfer-xml-v31-en_0.pdf) as defined by the Belgian sector federation [Febelfin](https://www.febelfin.be).

![Screenshot](data/Screenshot.png)

The current itteration shows all fields from the CODA XML in a table view like one would expect on a spreadsheet. A sperate panel shows the header fields and the sum of all transactions per currency.

## Install

CODAv is tested on Ubuntu 16.04 and macOS Sierra. It's written in Vala and depends on GTK 3 and libxml 2. [Download](https://github.com/cimm/codav/archive/master.zip) or [clone](https://github.com/cimm/codav.git) the repository and run the following from within its root directory.

### Linux

Install the dpendencies first, we use the Vala repository for a more recent Vala version.

```
sudo add-apt-repository ppa:vala-team
sudo apt update
apt install valac libgtk-3-dev libxml2-dev
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
