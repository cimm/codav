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

  public string total_amount(string currency) {
    var total_cents = 0;
    foreach (Transaction transaction in load ()) {
      if (transaction.instructed_amount_currency.casefold() == currency.casefold()) {
        total_cents += amount_to_cents(transaction.instructed_amount);
      }
    }
    return cents_to_amount(total_cents);
  }

  private XPath.NodeSet* search (string xpath) {
    var context = new XPath.Context (_doc);
    context.register_ns ("c", NSPACE);
    var result = context.eval_expression (xpath);
    return result->nodesetval;
  }

  private int amount_to_cents(string amount) {
    var parts = amount.split(".");
    var amount_cents = int.parse(parts[0]) * 100;
    if (parts.length == 2) {
      amount_cents += int.parse(parts[1]);
    }
    return amount_cents;
  }

  private string cents_to_amount(int cents) {
    return "%.2f".printf (cents / 100.0);
  }

  ~TransactionList () {
    delete _doc;
  }
}
