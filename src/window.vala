// modules: gtk+-3.0 TransactionList

public class MyWindow : Gtk.ApplicationWindow {
  enum Column {
    NAME,
    BIC,
    IBAN
  }

  Gtk.ListStore list_store;

  const GLib.ActionEntry[] actions = {
    { "open", open_cb }
  };

  internal MyWindow (MyApplication app) {
    Object (application: app, title: "CODAv");
    this.set_default_size (400, 300);
    this.window_position = Gtk.WindowPosition.CENTER;

    this.add_action_entries (actions, this);

    var tree_view = new Gtk.TreeView ();
    list_store = new Gtk.ListStore (3, typeof (string), typeof (string), typeof (string));
    tree_view.insert_column_with_attributes (-1, "Name", new Gtk.CellRendererText (), "text", Column.NAME);
    tree_view.insert_column_with_attributes (-1, "BIC", new Gtk.CellRendererText (), "text", Column.BIC);
    tree_view.insert_column_with_attributes (-1, "IBAN", new Gtk.CellRendererText (), "text", Column.IBAN);
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
    TransactionList list = new TransactionList(filename);
    var transactions = list.load ();

    Gtk.TreeIter iter;
    for (int i = 0; i < transactions.length; i++) {
      list_store.append (out iter);
      list_store.set (iter, Column.NAME, transactions[i].name, Column.BIC, transactions[i].bic, Column.IBAN, transactions[i].iban);
    }
  }
}
