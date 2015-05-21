using Gtk;
using Notify;

public class NewIsoDialog : MessageDialog {

	private string _iso_name;
	private string _file;
	private Display display;
	private Label new_file_label;
	private FileChooserButton new_file_button;
	private FileFilter filter;
	private Label entry_label;
	private Entry entry;
	private Box content;
	private Grid grid;
	private TextView description;
	private Label description_label;
	
	public string iso_name {
        get { return _iso_name; }
        set { _iso_name = value; }
    }

	public string file {
        get { return _file; }
        set { _file = value; }
    }

	public NewIsoDialog(Display d) {
		this.display = d;
		this.title = "Add new iso";
		this.set_size_request(450,200);
		this.create_widgets();
		this.connect_signals();
	}

	
	private void create_widgets () {
		this.content = (get_content_area () as Gtk.Box);

		this.new_file_label = new Label("Select new iso :");
		new_file_label.set_margin_start(10);
		new_file_label.set_halign(Align.START);

		this.new_file_button = new FileChooserButton("Choose", Gtk.FileChooserAction.OPEN);
		new_file_button.set_halign(Align.END);
		new_file_button.set_hexpand(true);
		new_file_button.set_margin_end(10);

		this.filter = new FileFilter ();
		new_file_button.set_filter (filter);
		filter.add_mime_type ("application/x-cd-image");

		
		this.entry_label = new Label("Name : ");
		entry_label.set_margin_start(10);
		entry_label.set_hexpand(true);
		entry_label.set_halign(Align.START);
		
		this.entry = new Entry();
		entry.set_margin_end(10);
		entry.set_hexpand(true);
		entry.set_halign(Align.END);

		this.description_label = new Label("Description : ");
		entry_label.set_margin_start(10);
		entry_label.set_hexpand(true);
		entry_label.set_halign(Align.START);
		
		this.description = new TextView();
		description.set_wrap_mode(Gtk.WrapMode.WORD);
				
		this.grid = new Grid();
		grid.attach(new_file_label, 0, 0, 1, 1);
		grid.attach(new_file_button, 1, 0, 1, 1);
		grid.attach(entry_label, 0, 1, 1, 1);
		grid.attach(entry, 1, 1, 1, 1);
		grid.attach(description_label, 0, 2, 1, 1);
		grid.attach(description, 1, 2, 1, 1);
		
		content.pack_start (grid, false, true, 0);

		add_button ("_Close", Gtk.ResponseType.CLOSE);
		add_button ("_Add", Gtk.ResponseType.APPLY);
	}
	
	private void connect_signals () {
		this.response.connect(on_response);
		this.new_file_button.selection_changed.connect (() => {
				var filename = new_file_button.get_filename ();
				this._file = filename;
			});
	}

	
	private void on_response (Gtk.Dialog source, int response_id) {
		switch (response_id) {
		case Gtk.ResponseType.APPLY:
			var iso = new Iso();
			iso.name =  this.entry.get_text ();
			iso.description = this.description.buffer.text;
			iso.path = this.file;
			iso.image_path = "gloupti.png";
			stdout.printf ("%s\n", this.file );			
			display.iso_manager.add_iso(iso);
			display.iso_manager.move_iso(iso);
			display.update();
			destroy ();			
			break;
		case Gtk.ResponseType.CLOSE:
		 	destroy ();
		 	break;
		}
	}
}