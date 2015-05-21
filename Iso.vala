public class Iso {

	private string _name;
	private string _description;
	private string _path;	
	private string _image_path;	

    public string name {
        get { return _name; }
        set { _name = value; }
    }
	
    public string description {
        get { return _description; }
        set { _description = value; }
    }
	
	public string path {
		get { return _path; }
        set { _path = value; }
    }

	public string image_path {
		get { return _image_path; }
        set { _image_path = value; }
    }

	public Iso() {
		
	}

}
