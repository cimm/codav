// modules: libxml-2.0 Transaction

using Xml;

public class TransactionList {
  private const string NSPACE = "urn:iso:std:iso:20022:tech:xsd:pain.001.001.03"; 
  private Doc* _doc = null;

  public TransactionList (string filename) {
    _doc = Parser.parse_file (filename);
  }

  public Transaction[] load () {
    Transaction[] transactions = {};
    var results = search ("/c:Document/c:CstmrCdtTrfInitn/c:PmtInf/c:CdtTrfTxInf");
    for (int i = 0; i < results->length (); i++) {
      var node = results->item (i);
      transactions += new Transaction.from_xml_node (node);
    }
    return transactions;
  }

  public GLib.HashTable<string, string> total_amounts () {
    var cents = new GLib.HashTable<string, int> (str_hash, str_equal);
    foreach (Transaction transaction in load ()) {
      var currency = transaction.instructed_amount_currency;
      cents.insert (currency, cents.get (currency) + amount_to_cents (transaction.instructed_amount));
    }
    var amounts = new GLib.HashTable<string, string> (str_hash, str_equal);
    foreach (var key in cents.get_keys ()) {
      var val = cents.get (key);
      amounts.insert (key, cents_to_amount (val));
    }
    return amounts;
  }

  private XPath.NodeSet* search (string xpath) {
    var context = new XPath.Context (_doc);
    context.register_ns ("c", NSPACE);
    var result = context.eval_expression (xpath);
    return result->nodesetval;
  }

  private int amount_to_cents (string amount) {
    return (int) (double.parse (amount) * 100);
  }

  private string cents_to_amount (int cents) {
    return "%.2f".printf (cents / 100.0);
  }

  ~TransactionList () {
    delete _doc;
  }
}
