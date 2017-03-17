// modules: gtk+-3.0 TransactionList

public class MyWindow : Gtk.ApplicationWindow {
  private enum Column {
    NAME,
    INSTRUCTED_AMOUNT_CURRENCY,
    INSTRUCTED_AMOUNT,
    BIC,
    IBAN,
    UNSTRUCTURED,
    INSTRUCTION_IDENTIFICATION,
    END_TO_END_IDENTIFICATION,
    COUNTRY,
    ADDRESS_LINES,
    REFERENCE
  }

  private Gtk.ListStore list_store;
  private Gtk.HeaderBar header_bar;

  private const GLib.ActionEntry[] actions = {
    { "open", open_cb }
  };

  internal MyWindow (MyApplication app) {
    Object (application: app);
    this.set_default_size (700, 500);
    this.window_position = Gtk.WindowPosition.CENTER;

    this.add_action_entries (actions, this);

    header_bar = new Gtk.HeaderBar ();
    header_bar.show_close_button = true;
    header_bar.title = "CODAv";
    this.set_titlebar (header_bar);

    var tree_view = new Gtk.TreeView ();
    list_store = new Gtk.ListStore (11, typeof (string),
                                        typeof (string),
                                        typeof (string),
                                        typeof (string),
                                        typeof (string),
                                        typeof (string),
                                        typeof (string),
                                        typeof (string),
                                        typeof (string),
                                        typeof (string),
                                        typeof (string));
    var cell = new Gtk.CellRendererText ();
    tree_view.insert_column_with_attributes (-1, "Name", cell, "text", Column.NAME);
    tree_view.insert_column_with_attributes (-1, "Instructed amount currency", cell, "text", Column.INSTRUCTED_AMOUNT_CURRENCY);
    tree_view.insert_column_with_attributes (-1, "Instructed amount", cell, "text", Column.INSTRUCTED_AMOUNT);
    tree_view.insert_column_with_attributes (-1, "BIC", cell, "text", Column.BIC);
    tree_view.insert_column_with_attributes (-1, "IBAN", cell, "text", Column.IBAN);
    tree_view.insert_column_with_attributes (-1, "Unstructured", cell, "text", Column.UNSTRUCTURED);
    tree_view.insert_column_with_attributes (-1, "Instruction identification", cell, "text", Column.INSTRUCTION_IDENTIFICATION);
    tree_view.insert_column_with_attributes (-1, "End to end", cell, "text", Column.END_TO_END_IDENTIFICATION);
    tree_view.insert_column_with_attributes (-1, "Country", cell, "text", Column.COUNTRY);
    tree_view.insert_column_with_attributes (-1, "Address lines", cell, "text", Column.ADDRESS_LINES);
    tree_view.insert_column_with_attributes (-1, "Reference", cell, "text", Column.REFERENCE);
    tree_view.set_model (list_store);

    var scroll = new Gtk.ScrolledWindow (null, null);
    scroll.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
    scroll.add (tree_view);

    this.add (scroll);
  }

  void open_cb (SimpleAction action, Variant? parameter) {
    var file_chooser = new Gtk.FileChooserDialog ("Select CODA XML file", this,
                                                 Gtk.FileChooserAction.OPEN,
                                                 "_Cancel", Gtk.ResponseType.CANCEL,
                                                 "_Open", Gtk.ResponseType.ACCEPT);
    file_chooser.local_only = false;
    file_chooser.set_modal (true);
    if (file_chooser.run () == Gtk.ResponseType.ACCEPT) {
      open_file (file_chooser.get_filename ());
    }
    file_chooser.destroy ();
  }

  private void open_file (string filename) {
    TransactionList list = new TransactionList (filename);
    var transactions = list.load ();

    header_bar.subtitle = filename;
    list_store.clear ();

    Gtk.TreeIter iter;
    foreach (Transaction t in transactions) {
      list_store.append (out iter);
      list_store.set (iter, Column.NAME, t.name,
                            Column.INSTRUCTED_AMOUNT_CURRENCY, t.instructed_amount_currency,
                            Column.INSTRUCTED_AMOUNT, t.instructed_amount,
                            Column.BIC, t.bic,
                            Column.IBAN, t.iban,
                            Column.UNSTRUCTURED, t.unstructured,
                            Column.INSTRUCTION_IDENTIFICATION, t.instruction_identification,
                            Column.END_TO_END_IDENTIFICATION, t.end_to_end_identification,
                            Column.COUNTRY, t.country,
                            Column.ADDRESS_LINES, string.joinv(", ", t.address_lines),
                            Column.REFERENCE, t.reference);
    }
  }
}
