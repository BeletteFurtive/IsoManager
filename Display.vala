using Gtk;
using Notify;

public class Display : Window {


	private IsoManager _im;
	private ListBox _list;
	public int count;
	
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

		
		var scrolled_window = new ScrolledWindow(null, null);
		var view_port = new Viewport(null, null);

		this.list = new ListBox();
		list.selection_mode = SelectionMode.SINGLE;

		foreach(Iso iso in this._im.list_iso){
			var e = new Etiquette(iso);
			this.list.insert(e, count);
			count++;
		}
		//var box = new Etiquette();
		
		view_port.add(this.list);
		scrolled_window.add(view_port);

		var headerbar = new TopBar();

		this.set_titlebar(headerbar);
		this.add(scrolled_window);
	}

	public void update(){
		var iso = this._im.list_iso.get(count);
		var e = new Etiquette(iso);
		this.list.insert(e, count);
		count++;
		show_all();
	}
}