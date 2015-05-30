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
	private Label entry_label_error;
	private Entry entry;
	private Box content;
	private Grid grid;
	private Entry description;
	private Label description_label;
	private Button button_add;
	private Button cancel_button;
	private Label image_label;
	private Button image_button;
	private Image image_iso;
	private Iso iso;
	private bool error;
	//private string image_file;

	public string iso_name {
        get { return _iso_name; }
        set { _iso_name = value; }
    }

	public string file {
        get { return _file; }
        set { _file = value; }
    }

	public NewIsoDialog(Display d) {
		this.error = false;
		this.iso = new Iso();
		this.set_transient_for(d);
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
		//entry.set_halign(Align.END);

		this.entry_label_error = new Label("Name is already taken !");
		entry_label_error.set_margin_end(10);
		entry_label_error.set_hexpand(true);
		entry_label_error.visible = false;
		//entry_label.set_halign(Align.START);

		
		this.description_label = new Label("Description : ");
		description_label.set_margin_start(10);
		description_label.set_hexpand(true);
		description_label.set_halign(Align.START);

		this.description = new Entry();
		description.set_margin_end(10);
		description.set_hexpand(true);
		//description.set_halign(Align.END);
		

		this.image_label = new Label("Icon : ");
		image_label.set_margin_start(10);
		image_label.set_hexpand(true);
		image_label.set_halign(Align.START);
		
		this.image_iso = new Image.from_icon_name("zoom-in-symbolic.symbolic", IconSize.DIALOG);
		
		this.image_button = new Button();
		image_button.set_image(image_iso);
		image_button.set_margin_end(10);
		image_button.set_hexpand(false);
		image_button.set_halign(Align.END);
		

		
		this.grid = new Grid();
		grid.row_spacing = 5;
		grid.attach(new_file_label, 0, 0, 1, 1);
		grid.attach(new_file_button, 1, 0, 1, 1);
		grid.attach(entry_label, 0, 1, 1, 1);
		grid.attach(entry, 1, 1, 1, 1);
		grid.attach(entry_label_error, 1, 2, 1, 1);
		grid.attach(description_label, 0, 3, 1, 1);
		grid.attach(description, 1, 3, 1, 1);
		grid.attach(image_label, 0, 4, 1, 1);
		grid.attach(image_button, 1, 4, 1, 1);		
		//grid.attach(image_list, 0, 5, 2, 2);
		content.pack_start (grid, false, true, 0);

		this.cancel_button = add_button ("Close", Gtk.ResponseType.CLOSE) as Button;
		this.button_add = add_button("Add", Gtk.ResponseType.APPLY) as Button;
		this.button_add.sensitive=false;
	}

	private void connect_signals () {
		this.response.connect(on_response);
		this.new_file_button.selection_changed.connect(on_file_button_clicked);
		this.image_button.clicked.connect(on_image_button_clicked);
		this.entry.changed.connect(on_name_edited);
		this.show.connect(on_show);
	}

	private void on_name_edited(){
		this.choose_image( this.entry.get_text ());
		this.image_iso.set_from_file(this.iso.image_path);
		this.image_button.set_image(image_iso);
		if(this.display.iso_manager.name_is_unique(this.entry.get_text())){
			this.entry_label_error.visible = false;
			if(this.new_file_button.get_filename() != null){
				this.button_add.sensitive=true;
			}
		}
		else {
			this.entry_label_error.visible = true;
		}
	}

	private void on_file_button_clicked(){
		this._file = new_file_button.get_filename ();
		this.choose_image(new_file_button.get_filename());
		this.image_iso.set_from_file(this.iso.image_path);
		if((this.entry.get_text() != null)&&
		   (this.entry.get_text() != "")){
			this.button_add.sensitive=true;
		}
	}

	private void on_image_button_clicked(){
		var ofd = new FileChooserDialog ("choose a file (not,too big!)", this, FileChooserAction.OPEN,
										 "Cancel", ResponseType.CANCEL,
										 "Open", ResponseType.ACCEPT);
        ofd.set_default_response (ResponseType.ACCEPT);
		if (ofd.run () == ResponseType.ACCEPT) {
			var image_file = ofd.get_filename();
			this.image_iso.set_from_file(image_file);
		}
		ofd.destroy();
	}
	
	private void on_response (Gtk.Dialog source, int response_id) {
		switch (response_id) {
		case Gtk.ResponseType.APPLY:
			iso.name =  this.entry.get_text ();
			iso.description = this.description.buffer.text;
			iso.path = this.file;
			//iso.image_path = "gloupti.png";
			display.iso_manager.add_iso(iso);
			display.iso_manager.move_iso(iso);
			display.iso_manager.save_iso();
			display.add_content(iso);
			destroy();
			break;
		case Gtk.ResponseType.CLOSE:
		 	destroy ();
		 	break;
		}
	}

	public void choose_image(string filename){
		try{

			Regex fedora = new Regex ("(\\s*[fF][eE][dD][oO][rR][aA]\\s*)");
			Regex opensuse = new Regex ("(\\s*[oO][pP][eE][nN][sS][uU][sS][eE]\\s*)");
			Regex gentoo = new Regex ("(\\s*[gG][eE][nN][tT][oO][oO]\\s*)");
			Regex debian = new Regex ("(\\s*[dD][eE][bB][iI][aA][nN]\\s*)");
			Regex ubuntu = new Regex ("(\\s*[uU][bB][uU][nN][tT][uU]\\s*)");
			Regex rhel = new Regex ("(\\s*[rR][hH][eE][lL]\\s*)|(\\s*[rR][eE][dD]\\s*[hH][aA][tT]\\s*)");
			Regex manjaro = new Regex ("(\\s*[mM][aA][nN][jJ][aA][rR][oO]\\s*)");
			Regex archlinux = new Regex ("(\\s*[aA][rR][cC][hH]\\s*)");
			Regex linuxmint = new Regex ("(\\s*[mM][iI][nN][tT]\\s*)");
			Regex centos = new Regex ("(\\s*[cC][eE][nN][tT][oO][sS]\\s*)");
			Regex elementary = new Regex ("(\\s*[eEéÉ][lL][eEéÉ][mM][eE][nN][tT][aA][rR][yY]\\s*)");
			Regex mageia = new Regex ("(\\s*[mM][aA][gG][eE][iI][aA]\\s*)");
			Regex gloupti = new Regex ("\\s*gloupti\\s*");

			string stock = "/usr/share/isomanager/icons/";
		
			if(fedora.match(filename)){
				iso.image_path = stock+"fedora.png";
			} else if(opensuse.match(filename)){
				iso.image_path =  stock+"opensuse.png";
			} else if(gentoo.match(filename)){
				iso.image_path = stock+"gentoo.png";
			} else if(debian.match(filename)){
				iso.image_path = stock+"debian.png";
			} else if(ubuntu.match(filename)){
				iso.image_path = stock+"ubuntu.png";
			} else if(rhel.match(filename)){
				iso.image_path = stock+"rhel.png";
			} else if(manjaro.match(filename)){
				iso.image_path = stock+"manjaro.png";
			} else if(archlinux.match(filename)){
				iso.image_path = stock+"archlinux.png";
			} else if(linuxmint.match(filename)){
				iso.image_path = stock+"linuxmint.png";
			} else if(centos.match(filename)){
				iso.image_path = stock+"centos.png";
			} else if(elementary.match(filename)){
				iso.image_path = stock+"elementary.png";
			} else if(mageia.match(filename)){
				iso.image_path = stock+"mageia.png";
			} else if(gloupti.match(filename)){
				iso.image_path = "gloupti.png";
			} else{
				iso.image_path = stock+"default.png";
			}
		} catch (RegexError e) {
			stdout.printf("%s", e.message);
		}
	}

	public void on_show(){
		this.entry_label_error.visible = false;
	}
	
}
