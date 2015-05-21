using Gtk;
using Notify;

public class TopBar : HeaderBar {

	private Button button_new;
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
		
		this.add(button_new);		
	}
	
	private void connect_signals () {
		this.button_new.clicked.connect (on_button_new_clicked);
	}

	private void on_button_new_clicked(){
		dialog = new NewIsoDialog(this.get_parent() as Display);
		dialog.show_all();
		
	}
}