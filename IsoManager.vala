using Gtk;
using Notify;
using Gee;

public class IsoManager{

	public ArrayList<Iso> _list_iso;

	
	public ArrayList<Iso> list_iso {
		get { return _list_iso; }
        set { _list_iso = value; }
    }
	

	public IsoManager() {
		this._list_iso = new ArrayList<Iso>();
	}
	
	public void add_iso(Iso i){
		this._list_iso.add(i);
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