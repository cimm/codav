// modules: libxml-2.0

using Xml;

public class Transaction {
  const string NSPACE = "urn:iso:std:iso:20022:tech:xsd:pain.001.001.03";
  Xml.Node* _node;
  string _name;
  string _bic;
  string _iban;

  public Transaction.from_xml (Xml.Node node) {
    _node = node;
  }

  public string name {
    get {
      XPath.NodeSet* nodes = search (_node, "/c:Cdtr/c:Nm");
      _name = nodes->item (0)->get_content ();
      return _name;
    }
  }

  public string bic {
    get {
      XPath.NodeSet* nodes = search (_node, "/c:CdtrAgt/c:FinInstnId/c:BIC");
      _bic = nodes->item (0)->get_content ();
      return _bic;
    }
  }

  public string iban {
    get {
      XPath.NodeSet* nodes = search (_node, "/c:CdtrAcct/c:Id/c:IBAN");
      _iban = nodes->item(0)->get_content ();
      return _iban;
    }
  }

  private XPath.NodeSet* search(Xml.Node node, string xpath) {
    var context = new XPath.Context (node);
    context.register_ns ("c", NSPACE);
    XPath.Object* result = context.eval_expression (xpath);
    return result->nodesetval;
  }
}
