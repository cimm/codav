public class Transaction {
  public string name;
  public string bic;
  public string iban;

  public Transaction (string name, string bic, string iban) {
    this.name = name;
    this.bic = bic;
    this.iban = iban;
  }
}
