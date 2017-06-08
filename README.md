# CODAv

An "XML message for Credit Transfer Initiation" (ISO 20022 XML) file encodes European credit transfers (SEPA) in a standard way. It's often refered to as a "CODA (Coded Statement of Account) file". It requests the movement of funds from the debtor account to a creditor.

CODAv is a desktop application that understands these electronic messages and serves as a viewer to verify the contents of these files. CODAv follows the [Belgian implementation guidelines](https://www.febelfin.be/sites/default/files/files/standard-credit_transfer-xml-v31-en_0.pdf) as defined by the Belgian sector federation [Febelfin](https://www.febelfin.be).

WARNING: It's in heavy development right now and is in no way ready to use.

## Installation

CODAv is tested on Ubuntu 16.04 and macOS El Capitan. It's written in Vala and depends on GTK 3 and libxml 2 and libgee 0.8.

```
valac --pkg gtk+-3.0 --pkg libxml-2.0 --pkg gee-0.8 -o codav src/*.vala
```
