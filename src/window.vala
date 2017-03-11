// modules: gtk+-3.0 TransactionList

public class MyWindow : Gtk.ApplicationWindow {
  enum Column {
    NAME,
    CURRENCY,
    AMOUNT,
    BIC,
    IBAN,
    UNSTRUCTURED,
    END_TO_END
  }

  Gtk.ListStore list_store;

  const GLib.ActionEntry[] actions = {
    { "open", open_cb }
  };

  internal MyWindow (MyApplication app) {
    Object (application: app, title: "CODAv");
    this.set_default_size (700, 500);
    this.window_position = Gtk.WindowPosition.CENTER;

    this.add_action_entries (actions, this);

    var tree_view = new Gtk.TreeView ();
    list_store = new Gtk.ListStore (7, typeof (string),
                                       typeof (string),
                                       typeof (string),
                                       typeof (string),
                                       typeof (string),
                                       typeof (string),
                                       typeof (string));
    var cell = new Gtk.CellRendererText ();
    tree_view.insert_column_with_attributes (-1, "Name", cell, "text", Column.NAME);
    tree_view.insert_column_with_attributes (-1, "Currency", cell, "text", Column.CURRENCY);
    tree_view.insert_column_with_attributes (-1, "Amount", cell, "text", Column.AMOUNT);
    tree_view.insert_column_with_attributes (-1, "BIC", cell, "text", Column.BIC);
    tree_view.insert_column_with_attributes (-1, "IBAN", cell, "text", Column.IBAN);
    tree_view.insert_column_with_attributes (-1, "Unstructured", cell, "text", Column.UNSTRUCTURED);
    tree_view.insert_column_with_attributes (-1, "End to end", cell, "text", Column.END_TO_END);
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

    Gtk.TreeIter iter;
    foreach (Transaction t in transactions) {
      list_store.append (out iter);
      list_store.set (iter, Column.NAME, t.name,
                            Column.CURRENCY, t.currency,
                            Column.AMOUNT, t.amount,
                            Column.BIC, t.bic,
                            Column.IBAN, t.iban,
                            Column.UNSTRUCTURED, t.unstructured,
                            Column.END_TO_END, t.end_to_end);
    }
  }
}
