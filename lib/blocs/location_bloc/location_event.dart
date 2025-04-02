import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable{
  const LocationEvent();
}

class GetListProvinceLocationEvent extends LocationEvent{
  @override
  List get props => [];
}

class GetListDistrictLocationEvent extends LocationEvent{
  final int provinceId;

  const GetListDistrictLocationEvent({required this.provinceId});
  @override
  List get props => [];
}
