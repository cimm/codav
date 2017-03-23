// modules: libxml-2.0

using Xml;

public class GroupHeader {
  private const string NSPACE = "urn:iso:std:iso:20022:tech:xsd:pain.001.001.03";
  private Xml.Doc* _doc;
  private string _message_identification;
  private string _creation_date_time;
  private string _number_of_transactions;

  public GroupHeader (string filename) {
    _doc = Parser.parse_file (filename);
  }

  public string message_identification {
    get {
      var results = search ("/c:Document/c:CstmrCdtTrfInitn/c:GrpHdr/c:MsgId");
      _message_identification = results->item (0)->get_content ();
      return _message_identification;
    }
  }

  public string creation_date_time {
    get {
      var results = search ("/c:Document/c:CstmrCdtTrfInitn/c:GrpHdr/c:CreDtTm");
      _creation_date_time = results->item (0)->get_content ();
      return _creation_date_time;
    }
  }

  public string number_of_transactions {
    get {
      var results = search ("/c:Document/c:CstmrCdtTrfInitn/c:GrpHdr/c:NbOfTxs");
      _number_of_transactions = results->item (0)->get_content ();
      return _number_of_transactions;
    }
  }

  private XPath.NodeSet* search (string xpath) {
    var context = new XPath.Context (_doc);
    context.register_ns ("c", NSPACE);
    var result = context.eval_expression (xpath);
    return result->nodesetval;
  }

  ~GroupHeader () {
    delete _doc;
  }
}
