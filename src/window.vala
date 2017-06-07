// modules: gtk+-3.0 TransactionList GroupHeader

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
    CODE,
    ISSUER,
    REFERENCE
  }

  private Gtk.ListStore list_store;
  private Gtk.HeaderBar header_bar;
  private Gtk.Button group_header_button;
  private GroupHeader group_header;
  private TransactionList transaction_list;

  private const GLib.ActionEntry[] actions = {
    { "open", open_cb }
  };

  internal MyWindow (MyApplication app) {
    // CODA uses American decimal marks so let's be coherent
    Intl.setlocale(LocaleCategory.NUMERIC, "C");
    Object (application: app);
    this.set_default_size (900, 500);
    this.window_position = Gtk.WindowPosition.CENTER;

    this.add_action_entries (actions, this);

    // HEADER
    header_bar = new Gtk.HeaderBar ();
    header_bar.show_close_button = true;
    header_bar.title = "CODAv";
    this.set_titlebar (header_bar);

    group_header_button = new Gtk.MenuButton ();
    group_header_button.margin = 5;
    header_bar.pack_end (group_header_button);
    group_header_button.set_sensitive (false);
    group_header_button.clicked.connect (() => {
      group_header_cb (group_header_button);
    });

    // BODY
    var tree_view = new Gtk.TreeView ();
    list_store = new Gtk.ListStore (13, typeof (string),
                                        typeof (string),
                                        typeof (string),
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
    tree_view.insert_column_with_attributes (-1, "Code", cell, "text", Column.CODE);
    tree_view.insert_column_with_attributes (-1, "Issuer", cell, "text", Column.ISSUER);
    tree_view.insert_column_with_attributes (-1, "Reference", cell, "text", Column.REFERENCE);
    tree_view.set_model (list_store);

    var scroll = new Gtk.ScrolledWindow (null, null);
    scroll.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
    scroll.add (tree_view);
    this.add (scroll);
  }

  private void group_header_cb (Gtk.Button button) {
    var grid = new Gtk.Grid ();
    grid.margin = 5;

    var label = new Gtk.Label ("ID");
    label.xalign = 0;
    grid.attach (label, 0, 0, 1, 2);
    grid.attach (new Gtk.Label (group_header.message_identification), 3, 0, 1, 2);

    label = new Gtk.Label ("Created");
    label.xalign = 0;
    grid.attach (label, 0, 2, 1, 2);
    grid.attach (new Gtk.Label (group_header.creation_date_time), 3, 2, 1, 2);

    label = new Gtk.Label ("Transactions");
    label.xalign = 0;
    grid.attach (label, 0, 4, 1, 2);
    grid.attach (new Gtk.Label (group_header.number_of_transactions), 3, 4, 1, 2);

    label = new Gtk.Label ("Total EUR");
    label.xalign = 0;
    grid.attach (label, 0, 6, 1, 2);
    grid.attach (new Gtk.Label (transaction_list.total_amount("EUR")), 3, 6, 1, 2);

    var group_header_popover = new Gtk.Popover (button);
    group_header_popover.add (grid);
    group_header_popover.show_all ();
  }

  private void open_cb (SimpleAction action, Variant? parameter) {
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
    group_header = new GroupHeader (filename);
    transaction_list = new TransactionList (filename);
    var transactions = transaction_list.load ();

    header_bar.subtitle = filename;
    list_store.clear ();
    group_header_button.set_sensitive (true);

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
                            Column.CODE, t.code,
                            Column.ISSUER, t.issuer,
                            Column.REFERENCE, t.reference);
    }
  }
}
