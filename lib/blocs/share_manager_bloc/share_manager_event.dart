
import 'package:equatable/equatable.dart';

class ShareManagerEvent extends Equatable{
  @override
  List get props => [];
}

class GetListOfSharedAccountsEvent extends ShareManagerEvent{}

class AddShareAccountEvent extends ShareManagerEvent{
  final String uuid;
  final int type;

  AddShareAccountEvent({required this.uuid, required this.type});
}

class RemoveBuildingShareAccountEvent extends ShareManagerEvent{
  final int userId;

  RemoveBuildingShareAccountEvent({required this.userId});
}

class UpdateBuildingShareAccountEvent extends ShareManagerEvent{
  final int id;
  final int? expiredTime;
  final int type;

  UpdateBuildingShareAccountEvent({required this.id, required this.expiredTime, required this.type});
}