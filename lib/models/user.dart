import 'package:sublin/models/address.dart';

class User {
  final bool streamingOn;
  final String email;
  final String firstName;
  final String secondName;
  final String homeAddress;
  final List<Address> requestedAddresses;

  User({
    this.streamingOn,
    this.email = '',
    this.firstName = '',
    this.secondName = '',
    this.homeAddress = '',
    this.requestedAddresses = const [],
  });

  factory User.initialData() {
    return User(
      streamingOn: false,
    );
  }

  factory User.fromMap(Map data) {
    final User defaultValues = User();
    final Address defaultValuesAddress = Address();
    data = data ?? {};
    return User(
        streamingOn: true,
        email: data['email'] ?? defaultValues.email,
        firstName: data['firstName'] ?? defaultValues.firstName,
        secondName: data['secondName'] ?? defaultValues.secondName,
        homeAddress: data['homeAddress'] ?? defaultValues.homeAddress,
        requestedAddresses: (data['requestedAddresses'] == null)
            ? defaultValues.requestedAddresses
            : data['requestedAddresses'].map<Address>((address) {
                return Address(
                  name: address['name'] ?? defaultValuesAddress.name,
                  id: address['id'] ?? defaultValuesAddress.id,
                );
              }).toList());
  }

  Map<String, dynamic> toMap(User data) {
    User defaultValues = User();
    return {
      'email': data.email ?? defaultValues.email,
      'firstName': data.firstName ?? defaultValues.firstName,
      'secondName': data.secondName ?? defaultValues.secondName,
      'homeAddress': data.homeAddress ?? defaultValues.homeAddress,
      'requestAddresses':
          data.requestedAddresses ?? defaultValues.requestedAddresses
    };
  }
}
