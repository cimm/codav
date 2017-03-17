// modules: libxml-2.0

using Xml;

public class Transaction {
  private const string NSPACE = "urn:iso:std:iso:20022:tech:xsd:pain.001.001.03";
  private Xml.Doc* _node;
  private string _name;
  private string _instructed_amount_currency;
  private string _instructed_amount;
  private string _bic;
  private string _iban;
  private string _unstructured;
  private string _instruction_identification;
  private string _end_to_end_identification;
  private string[] _address_lines;
  private string _country;
  private string _issuer;
  private string _reference;

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

  public string instructed_amount_currency {
    get {
      var results = search ("/c:Amt/c:InstdAmt");
      var attr = results->item (0)->properties;
      while (attr != null) {
        if (attr->name == "Ccy") {
          _instructed_amount_currency = attr->children->content;
          break;
        }
        attr = attr->next;
      }
      return _instructed_amount_currency;
    }
  }

  public string instructed_amount {
    get {
      var results = search ("/c:Amt/c:InstdAmt");
      _instructed_amount = results->item (0)->get_content ();
      return _instructed_amount;
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

  public string instruction_identification {
    get {
      var results = search ("/c:PmtId/c:InstrId");
      _instruction_identification = results->item (0)->get_content ();
      return _instruction_identification;
    }
  }

  public string end_to_end_identification {
    get {
      var results = search ("/c:PmtId/c:EndToEndId");
      _end_to_end_identification = results->item (0)->get_content ();
      return _end_to_end_identification;
    }
  }

  public string country {
    get {
      var results = search ("/c:Cdtr/c:PstlAdr/c:Ctry");
      _country = results->item (0)->get_content ();
      return _country;
    }
  }

  public string[] address_lines {
    get {
      var results = search ("/c:Cdtr/c:PstlAdr/c:AdrLine");
      for (int i = 0; i < results->length (); i++) {
        var node = results->item (i);
        _address_lines += node->get_content ();
      }
      return _address_lines;
    }
  }

  public string issuer {
    get {
      var results = search ("/c:RmtInf/c:Strd/c:CdtrRefInf/c:Tp/c:Issr");
      _issuer = results->item (0)->get_content ();
      return _issuer;
    }
  }

  public string reference {
    get {
      var results = search ("/c:RmtInf/c:Strd/c:CdtrRefInf/c:Ref");
      _reference = results->item (0)->get_content ();
      return _reference;
    }
  }

  private XPath.NodeSet* search (string xpath) {
    var context = new XPath.Context (_node);
    context.register_ns ("c", NSPACE);
    var result = context.eval_expression (xpath);
    return result->nodesetval;
  }
}
