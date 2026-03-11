import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/shared/login_screen.dart';
import '../screens/student/student_dashboard.dart';
import '../screens/student/student_details_form.dart';
import '../screens/student/assessment_instructions.dart';
import '../screens/student/assessment_screen.dart';
import '../screens/student/results_screen.dart';
import '../screens/student/history_screen.dart';
import '../screens/guidance_counselor/counselor_dashboard.dart';
import '../screens/guidance_counselor/monitoring_screen.dart';
import '../screens/guidance_counselor/pending_approvals_screen.dart';
import '../screens/guidance_counselor/student_records_screen.dart';
import '../screens/guidance_counselor/ai_feedback_screen.dart';
import '../models/riasec_models.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    // Student Routes
    GoRoute(
      path: '/student/dashboard',
      builder: (context, state) => const StudentDashboard(),
    ),
    GoRoute(
      path: '/student/student-details',
      builder: (context, state) => const StudentDetailsForm(),
    ),
    GoRoute(
      path: '/student/assessment-instructions',
      builder: (context, state) {
        final studentDetails = state.extra as StudentDetails?;
        return AssessmentInstructionsScreen(studentDetails: studentDetails);
      },
    ),
    GoRoute(
      path: '/student/assessment',
      builder: (context, state) => const AssessmentScreen(),
    ),
    GoRoute(
      path: '/student/results',
      builder: (context, state) => const ResultsScreen(),
    ),
    GoRoute(
      path: '/student/history',
      builder: (context, state) => const HistoryScreen(),
    ),
    // Guidance Counselor Routes
    GoRoute(
      path: '/guidance-counselor/dashboard',
      builder: (context, state) => const CounselorDashboard(),
    ),
    GoRoute(
      path: '/guidance-counselor/monitoring',
      builder: (context, state) => const MonitoringScreen(),
    ),
    GoRoute(
      path: '/guidance-counselor/pending-approvals',
      builder: (context, state) => const PendingApprovalsScreen(),
    ),
    GoRoute(
      path: '/guidance-counselor/student-records',
      builder: (context, state) => const StudentRecordsScreen(),
    ),
    GoRoute(
      path: '/guidance-counselor/ai-feedback',
      builder: (context, state) {
        final extraData = state.extra as Map<String, dynamic>?;
        return AIFeedbackScreen(extraData: extraData);
      },
    ),
  ],
);
