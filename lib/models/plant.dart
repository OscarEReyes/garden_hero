import 'package:flutter/material.dart';

class Plant {
  final String type;
  String description;
  final String phase;
  final bool watered;
  final bool diseased;

  Plant({this.type, this.watered, this.diseased, this.phase});

  String toString() {
    return type +
        "\t" +
        phase +
        "\twatered: " +
        watered.toString() +
        "\tdiseased: " +
        diseased.toString();
  }

  Widget toCard() {
    return Card(
      color: watered ? Color(0xFF0BE3E3) : Color(0xFFBF7F3F),
      elevation: 4.0,
      child: Text(type +
          " " +
          phase +
          "\nw: " +
          watered.toString() +
          " d: " +
          diseased.toString()),
    );
  }

    Map<String, dynamic> toMap() {
      Map<String, dynamic> data = {
        "name": type,
        "description": description,
        "phase": phase,
        "watered": watered,
        "diseased": diseased
      };

      return data;
    }
  }

