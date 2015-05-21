using Gtk;
using Notify;
using Gee;
using GLib;

public class IsoManager{

	public ArrayList<Iso> _list_iso;
	public string stock_path = "Documents/IsoManager/";
	
	public ArrayList<Iso> list_iso {
		get { return _list_iso; }
        set { _list_iso = value; }
    }
	

	public IsoManager() {
		this._list_iso = new ArrayList<Iso>();
		var file = File.new_for_path(stock_path);
		try {
			if (!file.query_exists()){
				file.make_directory_with_parents();
			}
		} catch (Error e) {
			stdout.printf ("Error: %s\n", e.message);
		}
	}
	
	public void add_iso(Iso i){
		this._list_iso.add(i);
	}

	public void move_iso(Iso i){
		var src = File.new_for_path(i.path);
		var dest = File.new_for_path(stock_path+i.name);
		try {
			src.move (dest, FileCopyFlags.NONE, null, (current_num_bytes, total_num_bytes) => {
					stdout.printf ("%" + int64.FORMAT + " %" + int64.FORMAT + "\n", current_num_bytes, total_num_bytes);
				});
		} catch (Error e) {
			stdout.printf ("Error: %s\n", e.message);
		}
	}
	
	public Iso get_iso(int i){
		return this._list_iso.get(i);
	}

	public void remove_iso_id(int i){
		this._list_iso.remove_at(i);
	}

	public void remove_iso(Iso iso){
		this._list_iso.remove(iso);
	}

}