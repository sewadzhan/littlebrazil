// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:littlebrazil/logic/cubits/bottom_sheet/bottom_sheet_cubit.dart';
// import 'package:new_version_plus/new_version_plus.dart';

// part 'update_app_state.dart';

// //Cubit for checking new updates of app
// class UpdateAppCubit extends Cubit<UpdateAppState> {
//   final BottomSheetCubit bottomSheetCubit;
//   final newVersionPlus = NewVersionPlus();
//   UpdateAppCubit(this.bottomSheetCubit) : super(UpdateAppInitial());

//   //Checking new versions of app
//   checkNewVersion(String playMarketUrl, String appStoreUrl) async {
//     if (playMarketUrl.isNotEmpty && appStoreUrl.isNotEmpty) {
//       final status = await newVersionPlus.getVersionStatus();
//       if (status != null && status.canUpdate) {
//         bottomSheetCubit.showUpdateAppBottomSheet(playMarketUrl, appStoreUrl);
//       }
//     }
//   }
// }
