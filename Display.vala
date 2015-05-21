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

		foreach(Iso iso in this._im.list_iso){
			var e = new Etiquette(iso);
			this.list.insert(e, count);
			count++;
		}
		
		view_port.add(this.list);
		scrolled_window.add(view_port);

		this.headerbar = new TopBar();
		
		this.set_titlebar(headerbar);
		this.add(scrolled_window);
	}

	public void connect_signals(){
		
	}
	
	public void update(){
		var iso = this._im.list_iso.get(count);
		var e = new Etiquette(iso);
		this.list.insert(e, count);
		this.count++;
		show_all();
	}
}