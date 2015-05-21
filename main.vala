using Gtk;

public static int main(string[] args){
	Gtk.init(ref args);
	Notify.init("IsoManager");
	Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = true;
	var i1 = new Iso();
	i1.name = "test";
	i1.description = "test1";
	i1.path = "test2";
	i1.image_path = "gloupti.png";

	var i2 = new Iso();
	i2.name = "test";
	i2.description = "test1";
	i2.path = "test2";
	i2.image_path = "gloupti.png";

	var im = new IsoManager();
	im.add_iso(i1);
	im.add_iso(i2);
	
	var window = new Display(im);
	
	window.destroy.connect(Gtk.main_quit);
	window.show_all();
	
	Gtk.main();
	return 0;
	
	
}
