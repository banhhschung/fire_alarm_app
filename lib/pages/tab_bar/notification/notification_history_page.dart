import 'package:fire_alarm_app/blocs/notification_bloc/notification_bloc.dart';
import 'package:fire_alarm_app/blocs/notification_bloc/notification_event.dart';
import 'package:fire_alarm_app/blocs/notification_bloc/notification_state.dart';
import 'package:fire_alarm_app/generated/l10n.dart';
import 'package:fire_alarm_app/model/notification_model.dart';
import 'package:fire_alarm_app/res/app_colors/app_colors.dart';
import 'package:fire_alarm_app/res/app_padding/app_padding.dart';
import 'package:fire_alarm_app/res/app_size/app_size.dart';
import 'package:fire_alarm_app/res/fonts/app_fonts.dart';
import 'package:fire_alarm_app/utils/common_utils.dart';
import 'package:fire_alarm_app/widget_element/custom_app_bar/custom_app_bar_widget.dart';
import 'package:fire_alarm_app/widget_element/empty_layout/empty_device_widget.dart';
import 'package:fire_alarm_app/widget_element/loading_custom/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NotificationHistoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotificationHistoryPageState();
}

class _NotificationHistoryPageState extends State<NotificationHistoryPage> {

  static const START = 0;
  static const PER_PAGE = 20;
  final int _notifyStart = START;
  final PagingController<int, int> _pagingController = PagingController(firstPageKey: START);

  late List<NotificationModel> _listNotification = [];
  late NotificationBloc _notificationBloc;

  late bool _isShowProcess = false;

  @override
  void initState() {
    // _isShowProcess = true;
    _notificationBloc = NotificationBloc()..add(GetListNotificationEvent(null, _notifyStart, PER_PAGE));
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      _toggleProcess(true);
      await Future.delayed(Duration(seconds: 2));
      _toggleProcess(false);
      final newItems = List.generate(PER_PAGE, (index) => pageKey + index);
      final isLastPage = newItems.length < PER_PAGE;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        _pagingController.appendPage(newItems, pageKey + newItems.length);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        isShowBackButton: false,
        title: S.current.warning_history,
      ),
      body: CustomLoadingWidget(
        showLoading: _isShowProcess,
        child: MultiBlocListener(
          listeners: [
            BlocListener<NotificationBloc, NotificationState>(
              bloc: _notificationBloc,
              listener: (context, state) {
                if (state is GetListNotificationSuccessState) {
                  if (!Common.checkNullOrEmpty(state.listNotification)) {
                    _listNotification += state.listNotification;
                    setState(() {});
                  } else {

                  }

                  _toggleProcess(false);
                } else if (state is GetListNotificationFailedState) {
                  _notificationBloc.add(GetListNotificationEvent(null, _notifyStart, PER_PAGE));
                }
              },
            ),
          ],
          child: Padding(padding: const EdgeInsets.all(AppPadding.p16),
          child: _buildHistoryNotificationLayout(),),
        )
      ),
    );
  }

  Widget _buildHistoryNotificationLayout(){
    return _listNotification != null && _listNotification.length != 0 ? Column(
      children: [
        _buildSearchNotificationByTimeLayout(),
        Expanded(
          child: PagedListView(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<int>(
                itemBuilder: (context, item, index) => _notifyItem(_listNotification[0])
            ),
          ),
        )
      ],
    ) : _emptyNotificationHistory();
  }

  Widget _emptyNotificationHistory(){
    return EmptyDeviceWidget(
      title: "Chưa có thông báo nào",
      onPress: (){

      },
    );
  }

  _notifyItem(NotificationModel notify) {
    return Padding(
      padding: const EdgeInsets.only(top: AppPadding.p12),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
          decoration: new BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSize.a6),
            boxShadow: [BoxShadow(color: Color(0x1a000000), offset: Offset(0, 1), blurRadius: 1, spreadRadius: 0)],
          ),
          padding: const EdgeInsets.all(AppPadding.p12),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(notify.title ?? '',
                      style: AppFonts.title()),
                  SizedBox(height: AppSize.a6),
                  Text("Tầng B1-Phòng bếp",
                      style: AppFonts.subTitle(color: AppColors.primaryText)),
                  SizedBox(height: AppSize.a6),
                  Text('09:49',
                      style: AppFonts.subTitle2()),
                ],
              ),
            ),
          ]),
        ),
        onTap: () async {
          if (await Common.isConnectToServer()) {

          } else {
            Common.showSnackBarMessage(context , S.current.can_not_connect_to_server, isError: true);
          }
        }
      ),
    );
  }

  Widget _buildSearchNotificationByTimeLayout(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,                                           
        children: [
          Text("dd/mm/yyyy"),
          Row(
            children: [
              Icon(Icons.arrow_forward, size: AppSize.a16,),
              Text("dd/mm/yyyy")
            ],
          ),
          Icon(Icons.calendar_month),
        ],
      ),
    );
  }



  void _toggleProcess(bool isShow) {
    setState(() {
      _isShowProcess = isShow;
    });
  }
}
