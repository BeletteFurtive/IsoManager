using Gtk;
using Notify;

public class Display : Window {


	private IsoManager _im;
	private ListBox _list;
	private int count;
	private ScrolledWindow scrolled_window;
	private Viewport view_port;
	private TopBar headerbar;
	
   	public IsoManager iso_manager {
        get { return _im; }
        set { _im = value; }
    }

   	public ListBox list {
        get { return _list; }
        set { _list = value; }
    }

	public Display(IsoManager i) {
		this.count = 0;
		this._im = i;
		this.title = "IsoManager";
		this.window_position = WindowPosition.CENTER;
		this.set_default_size(400, 300);

		this.create_widgets();
		this.connect_signals();		
	}


	public void create_widgets(){
		this.scrolled_window = new ScrolledWindow(null, null);
		this.view_port = new Viewport(null, null);
		
		this.list = new ListBox();
		
		list.selection_mode = SelectionMode.SINGLE;
		view_port.add(this.list);
		scrolled_window.add(view_port);

		this.headerbar = new TopBar();		
		this.set_titlebar(headerbar);

		foreach(Iso iso in this._im.list_iso){
			this.add_content(iso);
		}

		if(this.list.get_selected_row() != null){
			this.list.unselect_row(this.list.get_selected_row());			
		}
		this.add(scrolled_window);
	}

	public void connect_signals(){
		this.list.row_selected.connect(on_row_selected);
	}

	private void on_row_selected(){
	 	if(this.list.get_selected_row() != null){
	 		this.headerbar.activate_remove_button();
		}
	 	else{
			this.headerbar.disable_remove_button();
		}
	}

	public void add_content(Iso iso){
		var e = new Etiquette(iso);
		this.list.add(e);
		show_all();
	}

	public void remove_content(){
		var row = this.list.get_selected_row();
		this.iso_manager.remove_iso((row.get_child() as Etiquette).iso);

		this.list.remove(row);
		show_all();
	}

}
