import 'package:Sublin/models/auth.dart';
import 'package:Sublin/models/delimiter.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user.dart';
import 'package:Sublin/screens/address_input_screen.dart';
import 'package:Sublin/services/provider_user_service.dart';
import 'package:Sublin/services/user_service.dart';
import 'package:Sublin/utils/get_part_of_formatted_address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CitySelector extends StatefulWidget {
  bool providerAddress = false;
  String station = '';
  CitySelector({
    this.providerAddress,
    this.station,
  });
  @override
  _CitySelectorState createState() => _CitySelectorState();
}

class _CitySelectorState extends State<CitySelector> {
  User _user;
  bool _isLoading = false;

  @override
  void initState() {
    // _addresses = widget.addresses;
    // _stations = widget.stations;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context);
    return FutureBuilder(
        future: widget.providerAddress == true
            ? ProviderUserService().getProviderUserData(auth.uid)
            : UserService().getUser(auth.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && !_isLoading) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  snapshot.data.communes.length != 0
                      ? Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 10.0,
                          children:
                              snapshot.data.communes.map<Widget>((address) {
                            String city = getPartOfFormattedAddress(
                                address, Delimiter.city);
                            return Chip(
                                padding: EdgeInsets.all(8.0),
                                label: Text(city),
                                onDeleted: () {
                                  _removeCityFromCommunes(auth.uid, address);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                          }).toList())
                      : Center(
                          child: Text('Noch keine Orte hinzugefügt'),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RaisedButton(
                          child: Text('Ort hinzufügen'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddressInputScreen(
                                          addressInputFunction:
                                              _addCityToCommunesSelectionFunction,
                                          userUid: snapshot.data.uid,
                                          isEndAddress: false,
                                          isStartAddress: false,
                                          cityOnly: true,
                                          title: 'Ortschaft hinzufügen',
                                        )));
                            setState(() {
                              _isLoading = true;
                            });
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  void _addCityToCommunesSelectionFunction({
    String userUid,
    String input,
    String id,
    bool isCompany,
    bool isStartAddress,
    bool isEndAddress,
  }) async {
    dynamic _data;
    User _userData;
    ProviderUser _providerUserData;
    if (widget.providerAddress == true) {
      _providerUserData =
          await ProviderUserService().getProviderUserData(userUid);
      _data = _providerUserData;
    } else if (widget.providerAddress == false) {
      _userData = await UserService().getUser(userUid);

      _data = _userData;
      if (!_data.communes.contains(input)) {
        _data.communes.add(input);
      }
    }
    if (widget.providerAddress == true) {
      await ProviderUserService()
          .setProviderUserData(uid: userUid, data: _providerUserData);
      // For providers we nee also to add the addresses as station address

    } else if (widget.providerAddress == false) {
      print(userUid);
      print(_data);

      await UserService().writeUserData(uid: userUid, data: _data);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _removeCityFromCommunes(String userUid, String address) async {
    dynamic _data;
    User _userData;
    ProviderUser _providerUserData;
    if (widget.providerAddress == true) {
      _providerUserData =
          await ProviderUserService().getProviderUserData(userUid);
      _data = _providerUserData;
    } else if (widget.providerAddress == false) {
      _userData = await UserService().getUser(userUid);
      _data = _userData;
    }
    if (_data.communes.contains(address)) {
      _data.communes.remove(address);
      (widget.providerAddress == true)
          ? await ProviderUserService()
              .setProviderUserData(uid: userUid, data: _providerUserData)
          : await UserService().writeUserData(uid: userUid, data: _userData);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _addCityToStations(ProviderUser providerUser, String formattedAddress) {
    bool cityExists = false;
    providerUser.stations.map((station) {
      String cityFromFormattedAddress =
          getPartOfFormattedAddress(formattedAddress, Delimiter.city);
      String cityFromStation =
          getPartOfFormattedAddress(station, Delimiter.city);

      if (cityFromFormattedAddress == cityFromStation) {
        cityExists = true;
      }
    }).toList();
    if (cityExists == false) {
      setState(() {
        providerUser.stations.add(formattedAddress + widget.station);
        providerUser.communes.add(formattedAddress);
      });
    }
  }
}
