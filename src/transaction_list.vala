// modules: libxml-2.0 Transaction

using Xml;
using Gee;

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

  public HashMap<string, string> total_amounts () {
    var cents = new HashMap<string, int> ();
    foreach (Transaction transaction in load ()) {
      var currency = transaction.instructed_amount_currency;
      cents[currency] = cents[currency] + amount_to_cents (transaction.instructed_amount);
    }
    var amounts = new HashMap<string, string> ();
    foreach (var entry in cents.entries) {
      amounts[entry.key] = cents_to_amount (entry.value);
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
