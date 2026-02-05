import 'package:lms/features/parent_flow/data/models/child_model.dart';
import 'package:lms/features/parent_flow/data/models/parent_profile_model.dart';
import 'package:lms/features/parent_flow/data/models/parent_payment_model.dart';
import 'package:lms/features/son_flow/home/data/model/my_courses_response_model.dart';

import 'package:lms/features/parent_flow/data/models/parent_notification_model.dart';

enum ParentStatus { initial, loading, success, error, childAdded, childUpdated, childDeleted, paymentSuccess }

class ParentState {
  final ParentStatus status;
  final List<ChildModel> children;
  final ChildModel? selectedChild;
  final ParentProfileModel? profile;
  final List<ParentPaymentModel> payments;
  final List<ParentNotificationModel> notifications;
  final List<MyCourseItemModel> courses;
  final List<dynamic> examResults;
  final List<dynamic> liveSessions;
  final String? errorMessage;

  const ParentState({
    this.status = ParentStatus.initial,
    this.children = const [],
    this.selectedChild,
    this.profile,
    this.payments = const [],
    this.courses = const [],
    this.examResults = const [],
    this.liveSessions = const [],
    this.notifications = const [],
    this.errorMessage,
  });

  ParentState copyWith({
    ParentStatus? status,
    List<ChildModel>? children,
    ChildModel? selectedChild,
    ParentProfileModel? profile,
    List<ParentPaymentModel>? payments,
    List<MyCourseItemModel>? courses,
    List<dynamic>? examResults,
    List<dynamic>? liveSessions,
    List<ParentNotificationModel>? notifications,
    String? errorMessage,
  }) {
    return ParentState(
      status: status ?? this.status,
      children: children ?? this.children,
      selectedChild: selectedChild ?? this.selectedChild,
      profile: profile ?? this.profile,
      payments: payments ?? this.payments,
      courses: courses ?? this.courses,
      examResults: examResults ?? this.examResults,
      liveSessions: liveSessions ?? this.liveSessions,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
