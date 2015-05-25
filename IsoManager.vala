using Gtk;
using Notify;
using Gee;
using GLib;
using Json;

public class IsoManager{

	public ArrayList<Iso> _list_iso;
	public string home_path = GLib.Environment.get_home_dir();
	public string stock_path = GLib.Environment.get_home_dir()+"/Documents/IsoManager/";
	public string save_path = GLib.Environment.get_home_dir()+"/.local/share/isomanager/";
	public string save_file = "iso.json";
	
	public ArrayList<Iso> list_iso {
		get { return _list_iso; }
        set { _list_iso = value; }
    }
	

	public IsoManager() {
		this._list_iso = new ArrayList<Iso>();
		this.setup();
		
	}

	public void setup(){
		var file = File.new_for_path(stock_path);
		var save_f = File.new_for_path(save_path+save_file);
		try {
			if(!file.query_exists()){
				file.make_directory_with_parents();
			}
			if(!save_f.query_exists()){
			 	save_f.create(FileCreateFlags.NONE);
			 }
		} catch (Error e) {
			stdout.printf ("Error: %s\n", e.message);
		}
	}
	
	public void add_iso(Iso i){
		this._list_iso.add(i);
	}

	public void load_iso(){
		var parser = new Parser();
		try{
			parser.load_from_file(this.save_path+save_file);
			var root = parser.get_root();
			unowned Json.Object obj_root = root.get_object ();

			unowned Json.Node iso = obj_root.get_member ("iso");
			unowned Json.Object obj_iso = iso.get_object ();
			foreach (unowned string iso_name in obj_iso.get_members ()) {
				unowned Json.Node property = obj_iso.get_member (iso_name);
				unowned Json.Object obj_property = property.get_object ();
				var i = new Iso();
				i.name = obj_property.get_string_member("name");
				i.description = obj_property.get_string_member("description");
				i.path = obj_property.get_string_member("path");
				i.image_path = obj_property.get_string_member("image_path");
				this.add_iso(i);
			}

			this.save_iso();
		} catch(Error e){
			stdout.printf ("Unable to parse : %s\n ", e.message);
		}
	}

	public void save_iso(){
		try{
			var save_f = File.new_for_path(save_path+save_file);
			if (save_f.query_exists ()) {
				save_f.delete ();
			}

			var builder = new Json.Builder();
			builder.begin_object ();
			
			builder.set_member_name ("iso");			
			builder.begin_object();
			
			
			foreach(Iso iso in this.list_iso){
				builder.set_member_name(iso.name);
				builder.begin_object();
			
				builder.set_member_name ("name");
				builder.add_string_value (iso.name);
				builder.set_member_name ("description");
				builder.add_string_value (iso.description);
				builder.set_member_name ("path");
				builder.add_string_value (iso.path);
				builder.set_member_name ("image_path");
				builder.add_string_value (iso.image_path);
				builder.end_object ();
			}
			builder.end_object ();
			builder.end_object ();

			var generator = new Generator ();
			var root = builder.get_root ();
			generator.set_root (root);

			var str = generator.to_data (null);
			var dos = new DataOutputStream (save_f.create (FileCreateFlags.REPLACE_DESTINATION));
			
			assert (dos != null);
			dos.put_string(str);
		} catch (Error e) {
			stdout.printf ("Error: %s\n", e.message);
		}
	}
	
	public void move_iso(Iso i){
		var src = File.new_for_path(i.path);
		var dest = File.new_for_path(stock_path+i.name+".iso");
		i.path = stock_path+i.name+".iso";
		stdout.printf ("%s\n", i.path);
		try {
			src.move (dest, FileCopyFlags.NONE, null, null);
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