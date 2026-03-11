import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../models/riasec_models.dart';
import '../../widgets/counselor_sidebar.dart';

class AIFeedbackScreen extends StatefulWidget {
  final Map<String, dynamic>? extraData;

  const AIFeedbackScreen({super.key, this.extraData});

  @override
  State<AIFeedbackScreen> createState() => _AIFeedbackScreenState();
}

class _AIFeedbackScreenState extends State<AIFeedbackScreen> {
  int _rating = 0;
  final _commentController = TextEditingController();
  final List<String> _selectedCourses = [];
  String _action = 'approved'; // 'approved', 'rejected', 'modified'
  bool _showHistory = false;

  // Sample feedback history
  final List<FeedbackData> _feedbackHistory = [
    FeedbackData(
      id: '1',
      assessmentId: 'assess001',
      counselorId: 'counselor001',
      action: 'approved',
      rating: 5,
      comment: 'Excellent recommendations that matched the student\'s profile perfectly.',
      feedbackDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    FeedbackData(
      id: '2',
      assessmentId: 'assess002',
      counselorId: 'counselor001',
      action: 'modified',
      rating: 4,
      comment: 'Good recommendations, but added one more course option.',
      correctedCourses: ['Business Administration'],
      feedbackDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
    FeedbackData(
      id: '3',
      assessmentId: 'assess003',
      counselorId: 'counselor001',
      action: 'rejected',
      rating: 2,
      comment: 'Courses were not suitable for the student\'s current academic level.',
      feedbackDate: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.extraData != null) {
      _action = widget.extraData!['action'] ?? 'approved';
      final approval = widget.extraData!['approval'] as PendingApproval?;
      if (approval != null && _action == 'modified') {
        _selectedCourses.addAll(approval.recommendations.map((r) => r.courseName));
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final approval = widget.extraData?['approval'] as PendingApproval?;

    return Scaffold(
      drawer: CounselorSidebar(currentRoute: '/guidance-counselor/ai-feedback'),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('AI Supervised Feedback Learning'),
            Text(
              _getActionTitle(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
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
            onPressed: () => context.go('/guidance-counselor/dashboard'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Card
            Card(
              color: AppTheme.primaryPurple.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.psychology,
                      color: AppTheme.primaryPurple,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Help Improve AI Recommendations',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your feedback helps the AI learn and provide better course recommendations for future students.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Feedback Statistics
            Card(
              color: AppTheme.primaryPurple.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Feedback Statistics',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _showHistory = !_showHistory;
                            });
                          },
                          icon: Icon(_showHistory ? Icons.expand_less : Icons.expand_more),
                          label: Text(_showHistory ? 'Hide History' : 'Show History'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Feedback',
                            '${_feedbackHistory.length}',
                            AppTheme.primaryPurple,
                            Icons.feedback,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Avg. Rating',
                            '${(_feedbackHistory.map((f) => f.rating ?? 0).reduce((a, b) => a + b) / _feedbackHistory.length).toStringAsFixed(1)}',
                            AppTheme.primaryPurple,
                            Icons.star,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Approved',
                            '${_feedbackHistory.where((f) => f.action == 'approved').length}',
                            AppTheme.primaryPurple,
                            Icons.check_circle,
                          ),
                        ),
                      ],
                    ),
                    if (_showHistory) ...[
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(
                        'Feedback History',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._feedbackHistory.map((feedback) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getActionColor(feedback.action).withOpacity(0.1),
                            child: Icon(
                              _getActionIcon(feedback.action),
                              color: _getActionColor(feedback.action),
                            ),
                          ),
                          title: Text(
                            '${feedback.action.toUpperCase()} - ${DateFormat('MMM dd, yyyy').format(feedback.feedbackDate)}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (feedback.rating != null)
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < feedback.rating! ? Icons.star : Icons.star_border,
                                      size: 16,
                                      color: AppTheme.primaryYellow,
                                    );
                                  }),
                                ),
                              if (feedback.comment != null && feedback.comment!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    feedback.comment!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      )),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Student Info
            if (approval != null) ...[
              Text(
                'Student Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryPurple.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                  title: Text(approval.student.name),
                  subtitle: Text('ID: ${approval.student.studentNumber}'),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Action Selection
            Text(
              'Your Action',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'approved',
                  label: Text('Approved'),
                  icon: Icon(Icons.check),
                ),
                ButtonSegment(
                  value: 'rejected',
                  label: Text('Rejected'),
                  icon: Icon(Icons.close),
                ),
                ButtonSegment(
                  value: 'modified',
                  label: Text('Modified'),
                  icon: Icon(Icons.edit),
                ),
              ],
              selected: {_action},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _action = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 24),

            // Rating
            Text(
              'Rate the AI Recommendation Quality',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    size: 40,
                    color: AppTheme.primaryYellow,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            if (_rating > 0)
              Center(
                child: Text(
                  '$_rating out of 5 stars',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Comment/Feedback
            Text(
              'Provide Detailed Feedback',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: _getCommentHint(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.comment),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 24),

            // Course Modifications (if modified)
            if (_action == 'modified' && approval != null) ...[
              Text(
                'Corrected Course Recommendations',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Recommended:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...approval.recommendations.map((rec) => Chip(
                        label: Text(rec.courseName),
                        backgroundColor: AppTheme.primaryPurple.withOpacity(0.1),
                      )),
                      const SizedBox(height: 16),
                      Text(
                        'Your Corrected Recommendations:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Enter corrected courses (comma-separated)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedCourses.clear();
                            _selectedCourses.addAll(
                              value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty),
                            );
                          });
                        },
                      ),
                      if (_selectedCourses.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedCourses.map((course) {
                            return Chip(
                              label: Text(course),
                              backgroundColor: AppTheme.primaryPurple.withOpacity(0.1),
                              onDeleted: () {
                                setState(() {
                                  _selectedCourses.remove(course);
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Learning Impact Info
            Card(
              color: AppTheme.primaryPurple.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: AppTheme.primaryPurple,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How Your Feedback Helps',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'This feedback will be used to train the AI model, improving future recommendations for all students.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitFeedback,
                icon: const Icon(Icons.send),
                label: const Text('Submit Feedback to AI Learning System'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.go('/guidance-counselor/dashboard'),
                child: const Text('Skip Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getActionTitle() {
    switch (_action) {
      case 'approved':
        return 'Providing feedback on approved recommendation';
      case 'rejected':
        return 'Providing feedback on rejected recommendation';
      case 'modified':
        return 'Providing feedback on modified recommendation';
      default:
        return 'Providing feedback';
    }
  }

  String _getCommentHint() {
    switch (_action) {
      case 'approved':
        return 'Why did you approve these recommendations? What made them suitable?';
      case 'rejected':
        return 'Why did you reject these recommendations? What was wrong with them?';
      case 'modified':
        return 'Why did you modify the recommendations? What changes did you make and why?';
      default:
        return 'Provide your feedback here...';
    }
  }

  void _submitFeedback() {
    if (_rating == 0 && _commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide at least a rating or comment'),
          backgroundColor: AppTheme.primaryYellow,
        ),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Feedback'),
        content: const Text(
          'Your feedback will be sent to the AI learning system. This will help improve future recommendations.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processFeedback();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _processFeedback() {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Sending feedback to AI learning system...'),
              ],
            ),
          ),
        ),
      ),
    );

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close loading dialog
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback submitted successfully! The AI will learn from your input.'),
          backgroundColor: AppTheme.primaryPurple,
          duration: Duration(seconds: 3),
        ),
      );

      // Navigate back
      context.go('/guidance-counselor/dashboard');
    });
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getActionColor(String action) {
    switch (action) {
      case 'approved':
        return AppTheme.primaryPurple;
      case 'rejected':
        return const Color(0xFFE53E3E);
      case 'modified':
        return AppTheme.primaryYellow;
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _getActionIcon(String action) {
    switch (action) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'modified':
        return Icons.edit;
      default:
        return Icons.info;
    }
  }
}
