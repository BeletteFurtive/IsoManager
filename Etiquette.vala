using Gtk;
using Notify;

public class Etiquette : Grid {


	public Iso _iso;
	public string title="Description : \n";
	public string description="Virtuellement, le corps de GLOUPTI n'est qu'un estomac. Il est capable d'avaler des objets aussi gros que lui. L'estomac de ce POKéMON contient un fluide spécial qui lui permet de digérer n'importe quoi.\n";

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
		button.clicked.connect(on_clicked);

		
	}

	private void on_clicked(){
		var summary = this.title;
		var body = this.description;
		var icon = "dialog-information";
		
		try {
			var notif = new Notify.Notification(summary, body, icon);
			notif.show();
		} catch (Error e) {
			error ("Error: %s", e.message);
		}
	}
}