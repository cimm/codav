// modules: gtk+-3.0 MyWindow

class MyApplication : Gtk.Application {
  const ActionEntry[] actions = {
    { "quit", quit_cb }
  };

  public MyApplication () {
    flags |= GLib.ApplicationFlags.HANDLES_OPEN;
  }

  protected override void activate () {
    new MyWindow (this).show_all ();
  }

  public override void open (GLib.File[] files, string hint) {
    var window = new MyWindow (this);

    foreach (var file in files) { // currently only works for one file
      window.open_file (file.get_path ());
    }

    window.show_all ();
  }

  void quit_cb (SimpleAction action, Variant? parameter) {
    this.quit ();
  }

  protected override void startup () {
    base.startup ();

    this.add_action_entries (actions, this);

    var builder = new Gtk.Builder ();
    try {
      var ui_file = GLib.Path.build_filename (Config.PKGDATADIR, "appmenu.ui");
      builder.add_from_file (ui_file);
    } catch (Error e) {
      error ("Unable to load file: %s", e.message);
    }

    this.app_menu = builder.get_object ("appmenu") as MenuModel;
  }
}

public int main (string[] args) {
  return new MyApplication ().run (args);
}
