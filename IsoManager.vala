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
		var save_p = File.new_for_path(save_path);
		try {
			if(!file.query_exists()){
				file.make_directory_with_parents();
			}
			if(!save_f.query_exists()){
				stdout.printf("plop1");
				save_p.make_directory_with_parents();
				save_f.create(FileCreateFlags.NONE);
				stdout.printf("plop2");
			}
		} catch (Error e) {
			stdout.printf ("Error: %s\n", e.message);
		}
	}
	
	public void add_iso(Iso i){
		this._list_iso.add(i);
		this.save_iso(i);
	}

	public void load_iso(){
		var parser = new Parser();
		try{
			parser.load_from_file(this.save_path);
			var root = parser.get_root();
			unowned Json.Object obj = root.get_object ();

			foreach (unowned string name in obj.get_members ()) {
				stdout.printf("%s", name);
			}
		} catch(Error e){
				stdout.printf ("Unable to parse ");
			}
		}

		public void save_iso(Iso i){
			var builder = new Json.Builder();
			builder.begin_object ();
			builder.set_member_name ("iso");
			builder.begin_object ();
			builder.set_member_name (i.name);

			builder.begin_object();
			builder.set_member_name ("name");
			builder.add_string_value (i.name);
			builder.set_member_name ("description");
			builder.add_string_value (i.description);
			builder.set_member_name ("path");
			builder.add_string_value (i.path);
			builder.set_member_name ("image_path");
			builder.add_string_value (i.image_path);
			builder.end_array ();			
			builder.end_object ();

			builder.end_object ();

			builder.end_object ();

			var generator = new Generator ();
			var root = builder.get_root ();
			generator.set_root (root);

			var str = generator.to_data (null);

			FileStream stream = FileStream.open (this.save_path+this.save_file, "a");
			assert (stream != null);
			//stdout.printf("%s", str);
			stream.puts(str);
			
		}
	
		public void move_iso(Iso i){
			var src = File.new_for_path(i.path);
			var dest = File.new_for_path(stock_path+i.name+".iso");
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