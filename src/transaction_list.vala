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

  private XPath.NodeSet* search (string xpath) {
    var context = new XPath.Context (_doc);
    context.register_ns ("c", NSPACE);
    var result = context.eval_expression (xpath);
    return result->nodesetval;
  }

  ~TransactionList () {
    delete _doc;
  }
}
