using Gtk;
using Notify;
using Posix;

public class Etiquette : Grid {


	public Iso _iso;
	
	private Image image;
	private Button button;
	private Label label;
	
    public Iso iso {
        get { return _iso; }
        set { _iso = value; }
    }

	public Etiquette(Iso i) {

		this._iso = i;
		this.create_widgets();
		this.connect_signals();		
	}


	public void create_widgets(){
		this.image = new Image();
		image.set_from_file (this._iso.image_path);
		image.set_halign(Align.START);
		
		this.button = new Button();
		button.label = "Launch";
		button.set_halign(Align.END);
		button.set_valign(Align.CENTER);
		button.set_hexpand(true);
		button.set_margin_end(15);
		button.set_margin_start(15);
		
		this.label = new Label(""+
							   this._iso.name +
							   "\n"+
							   this._iso.description);
		label.set_line_wrap(true);
		label.set_use_markup (true);

		this.attach(image, 0, 0, 1, 1);
		this.attach(label, 1, 0, 1, 1);
		this.attach(button, 2, 0, 1, 1);
	   
	}

	public void connect_signals(){
		button.clicked.connect(on_button_launch_clicked);
	}

	private void on_button_launch_clicked(){
		execlp("/bin/gnome-boxes", "gnome-boxes", this.iso.path);
	}

}