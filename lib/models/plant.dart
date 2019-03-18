class Plant {
	String type;
	String description;
	String phase;
	bool watered;
	bool diseased;

	Plant({this.description,this.type,this.phase});

	Plant.fromMap(Map<String, dynamic> data) {
		this.type = data["type"];
		this.phase = data["phase"];
		this.watered = data["watered"];
		this.diseased = data["diseased"];

	}

	Map<String, dynamic> toMap() {
		Map<String, dynamic> data =  {
			"name" : type,
			"description" : description,
			"phase": phase,
			"watered": watered,
			"diseased": diseased

		};

		return data;
	}
}