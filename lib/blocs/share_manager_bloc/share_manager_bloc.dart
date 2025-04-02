import 'dart:async';

import 'package:fire_alarm_app/blocs/share_manager_bloc/share_manager_event.dart';
import 'package:fire_alarm_app/blocs/share_manager_bloc/share_manager_state.dart';
import 'package:fire_alarm_app/commons/error.dart';
import 'package:fire_alarm_app/model/share_building_model.dart';
import 'package:fire_alarm_app/provides/database_provider.dart';
import 'package:fire_alarm_app/repositories/share_manager_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShareManagerBloc extends Bloc<ShareManagerEvent, ShareManagerState> {
  final ShareManagerRepo _shareManagerRepo = ShareManagerRepoImpl();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  ShareManagerBloc() : super(InitialShareManagerState()) {
    on<GetListOfSharedAccountsEvent>(_onGetListOfSharedAccountsEvent);
    on<AddShareAccountEvent>(_onAddShareAccountEvent);
    on<RemoveBuildingShareAccountEvent>(_onRemoveBuildingShareAccountEvent);
    on<UpdateBuildingShareAccountEvent>(_onUpdateBuildingShareAccountEvent);
  }

  void _onGetListOfSharedAccountsEvent(GetListOfSharedAccountsEvent event, Emitter<ShareManagerState> emit) async {
    final response = await _shareManagerRepo.getListOfSharedAccounts();
    if (response.isLeft) {
      emit(GetListOfSharedAccountsFailState());
      return;
    }
    final data = response.right;
    if (data != null && data['data'] != null && data['code'] == StatusCode.SUCCESS) {
      final listShareBuildingModels = List<ShareBuildingModel>.from(data['data'].map((x) => ShareBuildingModel.fromJson(x)));
      await _databaseHelper.addOrUpdateListShareBuilding(listShareBuildingModels);
      emit(GetListOfSharedAccountsSuccessState(listShareBuildingModel: listShareBuildingModels));
    } else {
      emit(GetListOfSharedAccountsFailState());
    }
  }

  void _onAddShareAccountEvent(AddShareAccountEvent event, Emitter<ShareManagerState> emit) async {
    final response = await _shareManagerRepo.addShareAccount(uuid: event.uuid, type: event.type);
    if (response.isLeft) {
      emit(AddShareAccountFailState(errorCode: -1));
      return;
    }
    final data = response.right;
    if (data != null && data['data'] != null && data['code'] == StatusCode.SUCCESS) {
      final homeShared = ShareBuildingModel.fromJson(data['data']);
      await _databaseHelper.addOrUpdateShareBuilding(homeShared);
      emit(AddShareAccountSuccessState());
    } else {
      emit(AddShareAccountFailState(errorCode: data?['code'] ?? -1));
    }
  }

  void _onRemoveBuildingShareAccountEvent(RemoveBuildingShareAccountEvent event, Emitter<ShareManagerState> emit) async {
    final response = await _shareManagerRepo.removeBuildingShareAccount(userId: event.userId);
    if (response.isLeft) {
      emit(RemoveBuildingShareAccountFailState());
      return;
    }
    final data = response.right;
    if (data != null && data['code'] == StatusCode.SUCCESS) {
      await _databaseHelper.removeBuildingShareAccount(event.userId);
      emit(RemoveBuildingShareAccountSuccessState());
    } else {
      emit(RemoveBuildingShareAccountFailState());
    }
  }

  void _onUpdateBuildingShareAccountEvent(UpdateBuildingShareAccountEvent event, Emitter<ShareManagerState> emit) async {
    final response = await _shareManagerRepo.updateBuildingShareAccount(sharedId: event.id, expiredTime: event.expiredTime, type: event.type);
    if (response.isLeft) {
      emit(UpdateBuildingShareAccountFailState());
      return;
    }
    final data = response.right;
    if (data != null && data['data'] != null && data['code'] == StatusCode.SUCCESS) {
      // final homeShared = HomeSharedModel.fromJson(data['data']);
      // await _databaseHelper.addOrUpdateHomeShare(homeShared);
      emit(UpdateBuildingShareAccountSuccessState());
    } else {
      emit(UpdateBuildingShareAccountFailState());
    }
  }
}
