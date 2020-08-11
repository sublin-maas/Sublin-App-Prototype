import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:Sublin/models/routing.dart';

class BookingService {
  final Firestore _database = Firestore.instance;

  Stream<Routing> streamBooking(uid) {
    try {
      return _database
          .collection('booking')
          .document(uid)
          .collection('open')
          .document()
          .snapshots()
          .map((snap) {
        return Routing.fromMap(snap.data);
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<Routing> streamCheck(uid) {
    try {
      return _database
          .collection('check')
          .document(uid)
          .snapshots()
          .map((snap) {
        return Routing.fromMap(snap.data);
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> requestRoute(
      {uid,
      endAddress,
      endId,
      startAddress,
      startId,
      checkAddress = false,
      timestamp}) async {
    try {
      _database.collection('requests').document(uid).setData({
        'endAddress': endAddress,
        'endId': endId,
        'startAddress': startAddress,
        'startId': startId,
        'checkAddress': checkAddress,
        'timestamp': timestamp,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> bookRoute({uid}) async {
    print(uid);
    try {
      _database.collection('routings').document(uid).setData({
        'booked': true,
      }, merge: true);
    } catch (e) {
      print(e);
    }
  }

  Future<Routing> getRoute(uid) async {
    try {
      _database.collection('routings').document(uid).get().then((value) {
        return Routing.fromMap(value.data);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkIfProviderAvailable(uid) async {
    return _database.collection('check').document(uid).get().then((value) {
      return value.data['providerAvailable'];
    });
  }

  Future<void> deleteCheck(uid) async {
    try {
      _database.collection('check').document(uid).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeProviderFromRoute(uid) async {
    try {
      _database.collection('routings').document(uid).setData({'provider': ''});
    } catch (e) {
      print(e);
    }
  }
}
