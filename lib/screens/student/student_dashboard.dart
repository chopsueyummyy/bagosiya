import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/student_sidebar.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  void _showRecentActivityMenu(BuildContext context) {
    final RenderBox? button = context.findRenderObject() as RenderBox?;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button!.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        const PopupMenuItem(
          value: 'assessment',
          child: Row(
            children: [
              Icon(Icons.check_circle, size: 20, color: Color.fromARGB(255, 23, 233, 89)),
              SizedBox(width: 8),
              Text('Assessment Completed'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'results',
          child: Row(
            children: [
              Icon(Icons.assessment, size: 20, color: Color.fromARGB(255, 17, 139, 240)),
              SizedBox(width: 8),
              Text('Results Available'),
            ],
          ),
        ),
      ],
    );
  }

  void _showNotificationsMenu(BuildContext context) {
    final RenderBox? button = context.findRenderObject() as RenderBox?;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button!.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        const PopupMenuItem(
          value: 'notification1',
          child: Row(
            children: [
              Icon(Icons.email, size: 20, color: Color.fromARGB(255, 215, 238, 8)),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Assessment Results Ready', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('Your RIASEC results have been sent to your email', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'notification2',
          child: Row(
            children: [
              Icon(Icons.info, size: 20, color: AppTheme.lilac),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Assessment Under Review', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('Your assessment is being reviewed by your counselor', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: StudentSidebar(currentRoute: '/student/dashboard'),
      appBar: AppBar(
        title: const Text('Student Portal'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          // Recent Activity Dropdown
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.history),
              tooltip: 'Recent Activity',
              onPressed: () => _showRecentActivityMenu(context),
            ),
          ),
          // Notification Bell Dropdown
          Builder(
            builder: (context) => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  tooltip: 'Notifications',
                  onPressed: () => _showNotificationsMenu(context),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: const Color(0xFFE53E3E),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: const Text(
                      '2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              context.go('/login');
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Encouraging Title
                Text(
                  'Start your Course Assessment today!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryPurple,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Descriptive Text
                Text(
                  'Kickstart your journey by taking our Course Assessment to discover the best course path for you today!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 48),
                
                // Start RIASEC Test Button
                SizedBox(
                  width: 280,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/student/student-details');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryYellow,
                      foregroundColor: AppTheme.primaryPurple,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.quiz,
                          size: 28,
                          color: AppTheme.primaryPurple,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Start RIASEC Test',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
