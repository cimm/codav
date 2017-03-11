// modules: libxml-2.0

using Xml;

public class Transaction {
  const string NSPACE = "urn:iso:std:iso:20022:tech:xsd:pain.001.001.03";
  Xml.Doc* _node;
  string _name;
  string _bic;
  string _iban;

  public Transaction.from_xml_node (Xml.Node node) {
    _node = node;
  }

  public string name {
    get {
      var results = search ("/c:Cdtr/c:Nm");
      _name = results->item (0)->get_content ();
      return _name;
    }
  }

  public string bic {
    get {
      var results = search ("/c:CdtrAgt/c:FinInstnId/c:BIC");
      _bic = results->item (0)->get_content ();
      return _bic;
    }
  }

  public string iban {
    get {
      var results = search ("/c:CdtrAcct/c:Id/c:IBAN");
      _iban = results->item (0)->get_content ();
      return _iban;
    }
  }

  private XPath.NodeSet* search (string xpath) {
    var context = new XPath.Context (_node);
    context.register_ns ("c", NSPACE);
    var result = context.eval_expression (xpath);
    return result->nodesetval;
  }
}
