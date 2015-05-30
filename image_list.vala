using Gtk;
using Gdk;

public class ImageList : IconView{

	private Image image_iso;
	private Gtk.ListStore model;
	
	public ImageList() {
		
		this.create_widgets();
		this.set_model(model);
		this.connect_signals();
		this.show_all();
	}


	private void create_widgets (){
		Gtk.IconTheme icon_theme = Gtk.IconTheme.get_default ();
		
		this.model = new Gtk.ListStore(2, typeof(Gdk.Pixbuf), typeof(string));		
		TreeIter iter;

		set_pixbuf_column(0);
		//set_text_column (1);
		
		try {
			model.append (out iter);
			var pixbuf = new Pixbuf.from_file("gloupti.png");
			model.set (iter, 0, pixbuf);
		} catch (Error e) {
			stdout.printf ("Error: %s\n", e.message);
		}


	}

	private void connect_signals () {
	}
}
