using Gtk;
using Notify;

public class TopBar : HeaderBar {

	private Button button_new;
	private Button button_remove;
	private NewIsoDialog dialog;

	
	public TopBar() {
		this.title = "IsoManager";
		this.show_close_button = true;
		
		this.create_widgets();
		this.connect_signals();
		
	}

	private void create_widgets(){
		this.button_new = new Button();
		button_new.label = "New";

		this.button_remove = new Button();
		button_remove.label = "Remove";
		this.button_remove.sensitive = false;
		
		this.add(button_new);		
		this.add(button_remove);		
	}
	
	private void connect_signals () {
		this.button_new.clicked.connect (on_button_new_clicked);
		this.button_remove.clicked.connect(on_button_remove_clicked);
	}

	public void activate_remove_button(){
		this.button_remove.sensitive = true;
	}

	public void disable_remove_button(){
		this.button_remove.sensitive = false;
	}

	private void on_button_new_clicked(){
		dialog = new NewIsoDialog(this.get_parent() as Display);
		dialog.show_all();
		
	}

	private void on_button_remove_clicked(){
		Display d = this.get_parent() as Display;
		//d.iso_manager.remove_iso(this.iso);
		d.remove_content();
		d.iso_manager.save_iso();		
	}
}
