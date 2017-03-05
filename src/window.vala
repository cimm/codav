// modules: gtk+-3.0 CodaFile

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

    var view = new Gtk.TreeView ();
    list_store = new Gtk.ListStore (3, typeof (string), typeof (string), typeof (string));
    view.insert_column_with_attributes (-1, "Name", new Gtk.CellRendererText (), "text", Column.NAME);
    view.insert_column_with_attributes (-1, "BIC", new Gtk.CellRendererText (), "text", Column.BIC);
    view.insert_column_with_attributes (-1, "IBAN", new Gtk.CellRendererText (), "text", Column.IBAN);
    view.set_model (list_store);
    this.add (view);
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
    CodaFile coda_file = new CodaFile(filename);
    var transactions = coda_file.get_transactions ();

    Gtk.TreeIter iter;
    for (int i = 0; i < transactions.length; i++) {
      list_store.append (out iter);
      list_store.set (iter, Column.NAME, transactions[i].name, Column.BIC, transactions[i].bic, Column.IBAN, transactions[i].iban);
    }
  }
}
