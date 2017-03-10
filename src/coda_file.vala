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
      transactions += new Transaction.from_xml (node);
    }
    return transactions;
  }

  ~CodaFile () {
    delete doc;
  }
}
