class Stadium {
  String? key;
  StadiumData? stadiumData;

  Stadium(this.key, this.stadiumData);
}

class StadiumData {
  String? imagePath;
  String? name;
  String? place;
  int? playersNumber;
  double? ticketPrice;
  double? latitude;
  double? longitude;
  double? starRating;

  StadiumData(this.imagePath, this.name, this.place, this.playersNumber,
      this.ticketPrice, this.latitude, this.longitude, this.starRating);

  Map<String, dynamic> toJson() {
    return {
      "image": imagePath,
      "name": name,
      "place": place,
      "players": playersNumber,
      "ticket_price": ticketPrice,
      'latitude': latitude,
      'longitude': longitude,
      'starRating': starRating,

    };
  }

  StadiumData.fromJson(Map<dynamic, dynamic> json) {
    imagePath = json["image"];
    name = json["name"];
    place = json["place"];
    playersNumber = checkInteger(json["players"]);
    ticketPrice = checkDouble(json["ticket_price"]);
    latitude = checkDouble(json['latitude']);
    longitude = checkDouble(json['longitude']);
    starRating = checkDouble(json['starRating']);
  }

  double? checkDouble(value) {
    if (value is String) {
      return double.parse(value);
    } else if (value is double) {
      return value;
    } else if (value is int) {
      return double.parse(value.toString());
    } else {
      return 0.0;
    }
  }

  int? checkInteger(players) {
    if (players is String) {
      return int.parse(players);
    } else if (players is double) {
      return int.parse(players.toString());
    } else if (players is int) {
      return players;
    } else {
      return 0;
    }
  }


}
