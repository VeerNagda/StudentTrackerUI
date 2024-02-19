import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:ui/services/shared_service.dart';

class NetworkService extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult){
    if(connectivityResult == ConnectivityResult.none){
      SharedService.networkConnected = false;
    }
    else{
      SharedService.networkConnected = true;
    }
  }
}

class DependencyInjection{
  static void init(){
    Get.put<NetworkService>(NetworkService(),permanent: true);
  }
}