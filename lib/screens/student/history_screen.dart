import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../models/riasec_models.dart';
import '../../widgets/student_sidebar.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample history data for demo
    final historyItems = [
      AssessmentResult(
        id: '1',
        studentId: 'student123',
        completedAt: DateTime.now().subtract(const Duration(days: 5)),
        scores: [],
        primaryType: RIASECType.investigative,
        secondaryType: RIASECType.artistic,
        recommendedCourses: ['Computer Science', 'Data Science', 'Research Methods'],
        status: 'approved',
      ),
      AssessmentResult(
        id: '2',
        studentId: 'student123',
        completedAt: DateTime.now().subtract(const Duration(days: 30)),
        scores: [],
        primaryType: RIASECType.social,
        secondaryType: RIASECType.enterprising,
        recommendedCourses: ['Psychology', 'Education', 'Business'],
        status: 'approved',
      ),
      AssessmentResult(
        id: '3',
        studentId: 'student123',
        completedAt: DateTime.now().subtract(const Duration(days: 60)),
        scores: [],
        primaryType: RIASECType.artistic,
        secondaryType: RIASECType.investigative,
        recommendedCourses: ['Graphic Design', 'Fine Arts', 'Media Studies'],
        status: 'approved',
      ),
    ];

    return Scaffold(
      drawer: StudentSidebar(currentRoute: '/student/history'),
      appBar: AppBar(
        title: const Text('Assessment History'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Return to Main Menu',
            onPressed: () => context.go('/student/dashboard'),
          ),
        ],
      ),
      body: historyItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Assessment History',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete your first assessment to see your history here',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/student/assessment'),
                    icon: const Icon(Icons.quiz),
                    label: const Text('Take Assessment'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Overview Card
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: AppTheme.backgroundWhite,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Total Assessments',
                          historyItems.length.toString(),
                          Icons.assessment,
                          AppTheme.primaryPurple,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Approved',
                          historyItems.where((item) => item.status == 'approved').length.toString(),
                          Icons.check_circle,
                          const Color.fromARGB(255, 53, 245, 11),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // History List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: historyItems.length,
                    itemBuilder: (context, index) {
                      final item = historyItems[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            _showAssessmentDetails(context, item);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: _getStatusColor(item.status).withOpacity(0.1),
                                          child: Icon(
                                            _getStatusIcon(item.status),
                                            color: _getStatusColor(item.status),
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Assessment #${item.id}',
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              DateFormat('MMM dd, yyyy • hh:mm a').format(item.completedAt),
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: AppTheme.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Chip(
                                      label: Text(
                                        item.status?.toUpperCase() ?? 'PENDING',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      backgroundColor: _getStatusColor(item.status).withOpacity(0.1),
                                      labelStyle: TextStyle(
                                        color: _getStatusColor(item.status),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    _buildTypeChip(item.primaryType, isPrimary: true),
                                    const SizedBox(width: 8),
                                    const Text('+'),
                                    const SizedBox(width: 8),
                                    _buildTypeChip(item.secondaryType, isPrimary: false),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Recommended Courses:',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: item.recommendedCourses.take(3).map((course) {
                                    return Chip(
                                      label: Text(
                                        course,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                      backgroundColor: const Color.fromARGB(255, 53, 88, 243).withOpacity(0.1),
                                      labelStyle: TextStyle(
                                        color: const Color.fromARGB(255, 53, 88, 243),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                if (item.recommendedCourses.length > 3)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      '+${item.recommendedCourses.length - 3} more',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.textSecondary,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(RIASECType type, {required bool isPrimary}) {
    return Chip(
      label: Text(
        '${type.code} - ${type.name}',
        style: TextStyle(
          fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
      backgroundColor: isPrimary
          ? const Color.fromARGB(255, 53, 88, 243).withOpacity(0.2)
          : const Color.fromARGB(255, 15, 244, 80).withOpacity(0.2),
      avatar: CircleAvatar(
        backgroundColor: isPrimary ? const Color.fromARGB(255, 53, 88, 243) : const Color.fromARGB(255, 15, 244, 80),
        radius: 10,
        child: Text(
          type.code,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'approved':
        return const Color.fromARGB(255, 15, 244, 80);
      case 'rejected':
        return const Color(0xFFE53E3E);
      case 'pending':
      default:
        return const Color.fromARGB(255, 240, 155, 8);
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'pending':
      default:
        return Icons.pending;
    }
  }

  void _showAssessmentDetails(BuildContext context, AssessmentResult result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Assessment Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailRow('Date Completed', DateFormat('MMMM dd, yyyy • hh:mm a').format(result.completedAt)),
              _buildDetailRow('Status', result.status?.toUpperCase() ?? 'PENDING'),
              _buildDetailRow('Primary Type', '${result.primaryType.code} - ${result.primaryType.name}'),
              _buildDetailRow('Secondary Type', '${result.secondaryType.code} - ${result.secondaryType.name}'),
              const SizedBox(height: 16),
              Text(
                'Recommended Courses',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...result.recommendedCourses.take(3).map((course) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(Icons.school, color: AppTheme.primaryPurple),
                  title: Text(course),
                ),
              )),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/student/results');
                  },
                  child: const Text('View Full Results'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
