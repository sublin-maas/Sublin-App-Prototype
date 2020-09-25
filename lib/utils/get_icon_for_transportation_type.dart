import 'package:Sublin/models/transportation_type_enum.dart';
import 'package:flutter/material.dart';

Icon getIconForTransportationType(TransportationType transportationType) {
  switch (transportationType) {
    case TransportationType.public:
      return Icon(
        Icons.train,
        color: Colors.white,
      );
      break;
    case TransportationType.walking:
      return Icon(
        Icons.transfer_within_a_station,
        color: Colors.white,
      );
      break;
    case TransportationType.sublin:
      return Icon(
        Icons.local_taxi,
        color: Colors.white,
      );
      break;
  }
}