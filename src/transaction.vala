// modules: libxml-2.0

using Xml;

public class Transaction {
  private const string NSPACE = "urn:iso:std:iso:20022:tech:xsd:pain.001.001.03";
  private Xml.Doc* _node;
  private string _name;
  private string _currency;
  private string _amount;
  private string _bic;
  private string _iban;
  private string _unstructured;
  private string _end_to_end;
  private string _country;

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

  public string currency {
    get {
      var results = search ("/c:Amt/c:InstdAmt");
      var attr = results->item (0)->properties;
      while (attr != null) {
        if (attr->name == "Ccy") {
          _currency = attr->children->content;
          break;
        }
        attr = attr->next;
      }
      return _currency;
    }
  }

  public string amount {
    get {
      var results = search ("/c:Amt/c:InstdAmt");
      _amount = results->item (0)->get_content ();
      return _amount;
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

  public string unstructured {
    get {
      var results = search ("/c:RmtInf/c:Ustrd");
      _unstructured = results->item (0)->get_content ();
      return _unstructured;
    }
  }

  public string end_to_end {
    get {
      var results = search ("/c:PmtId/c:EndToEndId");
      _end_to_end = results->item (0)->get_content ();
      return _end_to_end;
    }
  }

  public string country {
    get {
      var results = search ("/c:Cdtr/c:PstlAdr/c:Ctry");
      _country = results->item (0)->get_content ();
      return _country;
    }
  }

  private XPath.NodeSet* search (string xpath) {
    var context = new XPath.Context (_node);
    context.register_ns ("c", NSPACE);
    var result = context.eval_expression (xpath);
    return result->nodesetval;
  }
}
