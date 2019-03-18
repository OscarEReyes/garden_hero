class Plant {
	String name;
	String description;
	int planted;
	int dead; 
	String user;
	String id;


	Plant(this.name, this.description, this.user) {
		this.count = 0;
	}

	Plant.fromMap(Map<String, dynamic> data) {
		this.name = data["name"];
		this.description = data["description"];
		this.count = data["count"];
		this.user = data["user"];
		if (data["id"] != null) {
			this.id = data["id"];
		}
	}

	Map<String, dynamic> toMap() {
		Map<String, dynamic> data =  {
			"name" : name,
			"description" : description,
			"count" : count,
			"user" : user
		};

		if (id != null) {
			data["id"] = id;
		}

		return data;
	}
}