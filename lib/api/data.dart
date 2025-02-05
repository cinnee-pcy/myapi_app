import 'dart:convert';

class Data {
  final String name;
  final int pm;
  final dynamic temp;
  final String time;
  Data(this.name, this.pm, this.temp,this.time);

  Data.fromJson(Map<String, dynamic> json)
      : name = json['data']['city']['name'],
        pm = json['data']['iaqi']['pm25']['v'],
        temp = json['data']['iaqi']['t']['v'],
        time = json['data']['time']['s'];
}
