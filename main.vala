using Gtk;

public static int main(string[] args){
	Gtk.init(ref args);
	Notify.init("IsoManager");
	Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = true;

	var im = new IsoManager();
	im.load_iso();
	
	var window = new Display(im);
	
	window.destroy.connect(Gtk.main_quit);
	window.show_all();
	
	Gtk.main();
	return 0;
	
	
}
