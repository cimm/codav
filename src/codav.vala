// valac --pkg gtk+-3.0 --pkg libxml-2.0 -o codav src/*.vala

// modules: gtk+-3.0 MyWindow

class MyApplication : Gtk.Application {
  const ActionEntry[] actions = {
    { "quit", quit_cb }
  };

  protected override void activate () {
    new MyWindow (this).show_all ();
  }

  void quit_cb (SimpleAction action, Variant? parameter) {
    this.quit ();
  }

  protected override void startup () {
    base.startup ();

    this.add_action_entries (actions, this);

    var builder = new Gtk.Builder ();
    try {
      builder.add_from_file ("data/appmenu.ui");
    } catch (Error e) {
      error ("Unable to load file: %s", e.message);
    }

    this.app_menu = builder.get_object ("appmenu") as MenuModel;
  }
}

public int main (string[] args) {
  return new MyApplication ().run (args);
}
