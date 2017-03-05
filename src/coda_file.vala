// modules: libxml-2.0 transaction

using Xml;

public class CodaFile {
  Doc* doc = null;
  XPath.Context ctx = null;

  const string NSPACE = "urn:iso:std:iso:20022:tech:xsd:pain.001.001.03"; 
  //const string MSG_ID_XPATH = "/c:Document/c:CstmrCdtTrfInitn/c:GrpHdr/c:MsgId";
  const string CDT_TRF_TX_INFO_XPATH = "/c:Document/c:CstmrCdtTrfInitn/c:PmtInf/c:CdtTrfTxInf";

  public CodaFile (string filename) {
    doc = Parser.parse_file (filename);
    ctx = new XPath.Context (doc);
    ctx.register_ns ("c", NSPACE);
  }

  //public string get_message_id () {
  //  XPath.Object* res = ctx.eval_expression (MSG_ID_XPATH);
  //  Xml.Node* node = res->nodesetval->item (0);
  //  return node->get_content ();
  //}

  public Transaction[] get_transactions () {
    Transaction[] transactions = {};
    XPath.Object* res = ctx.eval_expression (CDT_TRF_TX_INFO_XPATH);
    unowned Xml.XPath.NodeSet nodes = res->nodesetval;
    for (int i = 0; i < nodes.length (); i++) {
      unowned Xml.Node node = nodes.item (i);
      var name = get_contents_of_node (node, "/c:Cdtr/c:Nm"); 
      var bic = get_contents_of_node (node, "/c:CdtrAgt/c:FinInstnId/c:BIC"); 
      var iban = get_contents_of_node (node, "/c:CdtrAcct/c:Id/c:IBAN"); 
      transactions += new Transaction (name, bic, iban);
    }
    return transactions;
  }

  private string get_contents_of_node(Xml.Node node, string xpath) {
    ctx = new XPath.Context (node);
    ctx.register_ns ("c", NSPACE);
    XPath.Object* result = ctx.eval_expression (xpath); 
    return result->nodesetval->item (0)->get_content ();
  }

  ~CodaFile () {
    delete doc;
  }
}
