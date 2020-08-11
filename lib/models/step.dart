import 'package:Sublin/models/provider_user.dart';

class Step {
  bool isSublin;
  bool isStart;
  bool isEnd;
  String startAddress;
  String startName;
  String startId;
  String endAddress;
  String endName;
  String endId;
  String stationAddress;
  String stationName;
  ProviderUser provider;
  int startTime;
  int endTime;
  int duration;
  int distance;

  Step({
    this.isSublin = false,
    this.isStart = false,
    this.isEnd = false,
    this.startAddress = '',
    this.startName = '',
    this.startId = '',
    this.endAddress = '',
    this.endName = '',
    this.endId = '',
    this.stationAddress = '',
    this.stationName = '',
    this.provider,
    this.startTime = 0,
    this.endTime = 0,
    this.duration = 0,
    this.distance = 0,
  });
}
