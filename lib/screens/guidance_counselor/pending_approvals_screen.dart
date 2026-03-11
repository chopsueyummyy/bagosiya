import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../models/riasec_models.dart';
import '../../widgets/counselor_sidebar.dart';

class PendingApprovalsScreen extends StatefulWidget {
  const PendingApprovalsScreen({super.key});

  @override
  State<PendingApprovalsScreen> createState() => _PendingApprovalsScreenState();
}

class _PendingApprovalsScreenState extends State<PendingApprovalsScreen> {
  // Bulk selection
  final Set<String> _selectedApprovals = {};
  bool _isSelectionMode = false;
  String _sortBy = 'date'; // 'date', 'name', 'priority'
  bool _sortAscending = false;
  final TextEditingController _searchController = TextEditingController();
  String _filterStatus = 'all'; // 'all', 'pending', 'recent'

  // Sample pending approvals data
  List<PendingApproval> _pendingApprovals = [
    PendingApproval(
      assessment: AssessmentResult(
        id: '1',
        studentId: 'student001',
        completedAt: DateTime.now().subtract(const Duration(hours: 2)),
        scores: [
          RIASECScore(type: RIASECType.investigative, score: 85, percentage: 85.0),
          RIASECScore(type: RIASECType.artistic, score: 72, percentage: 72.0),
          RIASECScore(type: RIASECType.social, score: 65, percentage: 65.0),
          RIASECScore(type: RIASECType.enterprising, score: 58, percentage: 58.0),
          RIASECScore(type: RIASECType.realistic, score: 45, percentage: 45.0),
          RIASECScore(type: RIASECType.conventional, score: 40, percentage: 40.0),
        ],
        primaryType: RIASECType.investigative,
        secondaryType: RIASECType.artistic,
        recommendedCourses: ['Computer Science', 'Data Science', 'Research Methods'],
        status: 'pending',
      ),
      student: Student(
        id: 'student001',
        name: 'John Doe',
        email: 'john.doe@university.edu',
        studentNumber: '2024-001',
        course: 'Undecided',
        yearLevel: 1,
      ),
      recommendations: [
        CourseRecommendation(
          id: '1',
          courseName: 'Computer Science',
          courseCode: 'CS101',
          description: 'Introduction to programming and computer systems',
          matchingTypes: [RIASECType.investigative, RIASECType.artistic],
          matchScore: 0.92,
        ),
        CourseRecommendation(
          id: '2',
          courseName: 'Data Science',
          courseCode: 'DS201',
          description: 'Data analysis and machine learning fundamentals',
          matchingTypes: [RIASECType.investigative],
          matchScore: 0.88,
        ),
        CourseRecommendation(
          id: '3',
          courseName: 'Research Methods',
          courseCode: 'RM301',
          description: 'Advanced research techniques and methodologies',
          matchingTypes: [RIASECType.investigative, RIASECType.artistic],
          matchScore: 0.85,
        ),
      ],
      submittedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    PendingApproval(
      assessment: AssessmentResult(
        id: '2',
        studentId: 'student002',
        completedAt: DateTime.now().subtract(const Duration(hours: 5)),
        scores: [
          RIASECScore(type: RIASECType.social, score: 90, percentage: 90.0),
          RIASECScore(type: RIASECType.enterprising, score: 75, percentage: 75.0),
          RIASECScore(type: RIASECType.artistic, score: 60, percentage: 60.0),
          RIASECScore(type: RIASECType.investigative, score: 50, percentage: 50.0),
          RIASECScore(type: RIASECType.realistic, score: 40, percentage: 40.0),
          RIASECScore(type: RIASECType.conventional, score: 35, percentage: 35.0),
        ],
        primaryType: RIASECType.social,
        secondaryType: RIASECType.enterprising,
        recommendedCourses: ['Psychology', 'Education', 'Business Administration'],
        status: 'pending',
      ),
      student: Student(
        id: 'student002',
        name: 'Jane Smith',
        email: 'jane.smith@university.edu',
        studentNumber: '2024-002',
        course: 'Undecided',
        yearLevel: 1,
      ),
      recommendations: [
        CourseRecommendation(
          id: '3',
          courseName: 'Psychology',
          courseCode: 'PSY101',
          description: 'Introduction to psychological principles',
          matchingTypes: [RIASECType.social],
          matchScore: 0.95,
        ),
      ],
      submittedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PendingApproval> get _filteredAndSortedApprovals {
    var filtered = _pendingApprovals.where((approval) {
      // Search filter
      if (_searchController.text.isNotEmpty) {
        final searchTerm = _searchController.text.toLowerCase();
        final matchesSearch = approval.student.name.toLowerCase().contains(searchTerm) ||
            approval.student.studentNumber.toLowerCase().contains(searchTerm) ||
            approval.student.email.toLowerCase().contains(searchTerm);
        if (!matchesSearch) return false;
      }

      // Status filter
      if (_filterStatus == 'recent') {
        final hoursSinceSubmission = DateTime.now().difference(approval.submittedAt).inHours;
        return hoursSinceSubmission <= 24;
      }
      return true;
    }).toList();

    // Sorting
    filtered.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'name':
          comparison = a.student.name.compareTo(b.student.name);
          break;
        case 'date':
          comparison = a.submittedAt.compareTo(b.submittedAt);
          break;
        case 'priority':
          // Priority based on time since submission (newer = higher priority)
          comparison = b.submittedAt.compareTo(a.submittedAt);
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedApprovals.clear();
      }
    });
  }

  void _toggleSelection(String approvalId) {
    setState(() {
      if (_selectedApprovals.contains(approvalId)) {
        _selectedApprovals.remove(approvalId);
      } else {
        _selectedApprovals.add(approvalId);
      }
    });
  }

  void _selectAll() {
    setState(() {
      if (_selectedApprovals.length == _filteredAndSortedApprovals.length) {
        _selectedApprovals.clear();
      } else {
        _selectedApprovals.clear();
        _selectedApprovals.addAll(_filteredAndSortedApprovals.map((a) => a.assessment.id));
      }
    });
  }

  void _bulkApprove() {
    if (_selectedApprovals.isEmpty) return;
    
    final count = _selectedApprovals.length;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Approve'),
        content: Text('Approve $count recommendation(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _pendingApprovals.removeWhere((a) => _selectedApprovals.contains(a.assessment.id));
                _selectedApprovals.clear();
                _isSelectionMode = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$count recommendation(s) approved'),
                  backgroundColor: AppTheme.primaryPurple,
                ),
              );
            },
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _bulkReject() {
    if (_selectedApprovals.isEmpty) return;
    
    final count = _selectedApprovals.length;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Reject'),
        content: Text('Reject $count recommendation(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _pendingApprovals.removeWhere((a) => _selectedApprovals.contains(a.assessment.id));
                _selectedApprovals.clear();
                _isSelectionMode = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$count recommendation(s) rejected'),
                  backgroundColor: const Color(0xFFE53E3E),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53E3E),
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredApprovals = _filteredAndSortedApprovals;
    
    return Scaffold(
      drawer: CounselorSidebar(currentRoute: '/guidance-counselor/pending-approvals'),
      appBar: AppBar(
        title: _isSelectionMode
            ? Text('${_selectedApprovals.length} selected')
            : const Text('Pending Course Recommendations'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          if (_isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.select_all),
              tooltip: 'Select All',
              onPressed: _selectAll,
            ),
            if (_selectedApprovals.isNotEmpty) ...[
              IconButton(
                icon: const Icon(Icons.check),
                tooltip: 'Bulk Approve',
                onPressed: _bulkApprove,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Bulk Reject',
                onPressed: _bulkReject,
              ),
            ],
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Cancel Selection',
              onPressed: _toggleSelectionMode,
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'Return to Main Menu',
              onPressed: () => context.go('/guidance-counselor/dashboard'),
            ),
            IconButton(
              icon: const Icon(Icons.checklist),
              tooltip: 'Bulk Actions',
              onPressed: _toggleSelectionMode,
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            padding: const EdgeInsets.all(16.0),
            color: AppTheme.backgroundWhite,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by student name, ID, or email...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _sortBy,
                        decoration: const InputDecoration(
                          labelText: 'Sort By',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'date', child: Text('Date')),
                          DropdownMenuItem(value: 'name', child: Text('Student Name')),
                          DropdownMenuItem(value: 'priority', child: Text('Priority')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _sortBy = value ?? 'date';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: Icon(_sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
                      onPressed: () {
                        setState(() {
                          _sortAscending = !_sortAscending;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _filterStatus,
                        decoration: const InputDecoration(
                          labelText: 'Filter',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All')),
                          DropdownMenuItem(value: 'recent', child: Text('Recent (24h)')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _filterStatus = value ?? 'all';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bulk Actions Bar (when in selection mode)
          if (_isSelectionMode && _selectedApprovals.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppTheme.primaryPurple.withOpacity(0.1),
              child: Row(
                children: [
                  Text(
                    '${_selectedApprovals.length} selected',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _bulkApprove,
                    icon: const Icon(Icons.check),
                    label: const Text('Approve'),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: _bulkReject,
                    icon: const Icon(Icons.close),
                    label: const Text('Reject'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFE53E3E),
                    ),
                  ),
                ],
              ),
            ),

          // Approvals List
          Expanded(
            child: filteredApprovals.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: AppTheme.primaryPurple,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Pending Approvals',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'All course recommendations have been reviewed',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: filteredApprovals.length,
              itemBuilder: (context, index) {
                final approval = filteredApprovals[index];
                final isSelected = _selectedApprovals.contains(approval.assessment.id);
                
                final cardContent = Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: isSelected ? 4 : 2,
                  color: isSelected ? AppTheme.primaryPurple.withOpacity(0.05) : null,
                  child: ExpansionTile(
                    initiallyExpanded: index == 0 && !_isSelectionMode,
                    leading: _isSelectionMode
                        ? Checkbox(
                            value: isSelected,
                            onChanged: (value) => _toggleSelection(approval.assessment.id),
                          )
                        : CircleAvatar(
                            backgroundColor: const Color.fromARGB(255, 238, 140, 11).withOpacity(0.1),
                            child: Icon(
                              Icons.pending,
                              color: const Color.fromARGB(255, 238, 140, 11),
                            ),
                          ),
                    title: Text(
                      approval.student.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${approval.student.studentNumber}'),
                        Text(
                          'Submitted: ${DateFormat('MMM dd, yyyy • hh:mm a').format(approval.submittedAt)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        if (_isSelectionMode && isSelected)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Chip(
                              label: const Text('Selected', style: TextStyle(fontSize: 10)),
                              backgroundColor: AppTheme.primaryPurple.withOpacity(0.2),
                              labelStyle: TextStyle(
                                color: AppTheme.primaryPurple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // RIASEC Assessment Overview
                            _buildRIASECOverview(approval.assessment),
                            const SizedBox(height: 24),
                            
                            // Recommended Courses (Top 3)
                            Text(
                              'Top 3 AI Recommended Courses',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...approval.recommendations.take(3).map((rec) => _buildCourseCard(rec, approval.assessment)),
                            const SizedBox(height: 16),
                            
                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _showRejectDialog(context, approval),
                                    icon: const Icon(Icons.close),
                                    label: const Text('Reject'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFFE53E3E),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _approveRecommendation(approval),
                                    icon: const Icon(Icons.check),
                                    label: const Text('Approve'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => _showModifyDialog(context, approval),
                                icon: const Icon(Icons.edit),
                                label: const Text('Modify & Provide Feedback'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.primaryPurple,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );

                // Wrap in GestureDetector if in selection mode
                return _isSelectionMode
                    ? GestureDetector(
                        onTap: () => _toggleSelection(approval.assessment.id),
                        child: cardContent,
                      )
                    : cardContent;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRIASECOverview(AssessmentResult assessment) {
    return Card(
      color: AppTheme.primaryPurple.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assessment, color: AppTheme.primaryPurple),
                const SizedBox(width: 8),
                Text(
                  'RIASEC Assessment Overview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTypeScore(assessment.primaryType, assessment.scores.firstWhere((s) => s.type == assessment.primaryType)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTypeScore(assessment.secondaryType, assessment.scores.firstWhere((s) => s.type == assessment.secondaryType)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'All RIASEC Scores',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            ...assessment.scores.map((score) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      '${score.type.code} - ${score.type.name}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: score.percentage / 100,
                      backgroundColor: AppTheme.dividerColor,
                      valueColor: AlwaysStoppedAnimation<Color>(_getTypeColor(score.type)),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${score.score}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getTypeColor(score.type),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeScore(RIASECType type, RIASECScore score) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: _getTypeColor(type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            type.code,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _getTypeColor(type),
            ),
          ),
          Text(
            type.name,
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            '${score.score}%',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _getTypeColor(type),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(CourseRecommendation recommendation, AssessmentResult assessment) {
    final matchingTypesList = recommendation.matchingTypes;
    final primaryMatch = matchingTypesList.contains(assessment.primaryType);
    final secondaryMatch = matchingTypesList.contains(assessment.secondaryType);
    
    String reason;
    if (primaryMatch && secondaryMatch) {
      reason = 'This course matches both your primary (${assessment.primaryType.name}) and secondary (${assessment.secondaryType.name}) RIASEC types, making it an excellent fit for your interests and personality.';
    } else if (primaryMatch) {
      reason = 'This course aligns with your primary RIASEC type (${assessment.primaryType.name}), which indicates strong compatibility with your core interests and strengths.';
    } else if (secondaryMatch) {
      reason = 'This course corresponds to your secondary RIASEC type (${assessment.secondaryType.name}), complementing your primary interests.';
    } else {
      reason = 'This course matches your RIASEC profile through ${matchingTypesList.map((t) => t.name).join(", ")} types.';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryPurple.withOpacity(0.1),
          child: Icon(
            Icons.school,
            color: AppTheme.primaryPurple,
          ),
        ),
        title: Text(
          recommendation.courseName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recommendation.courseCode),
            Text(
              recommendation.description,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Chip(
                  label: Text(
                    'Match: ${(recommendation.matchScore * 100).toInt()}%',
                    style: const TextStyle(fontSize: 10),
                  ),
                  backgroundColor: const Color.fromARGB(255, 62, 229, 70).withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: const Color.fromARGB(255, 62, 229, 70),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                ...recommendation.matchingTypes.map((type) => Chip(
                  label: Text(
                    type.code,
                    style: const TextStyle(fontSize: 10),
                  ),
                  backgroundColor: _getTypeColor(type).withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: _getTypeColor(type),
                  ),
                )),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why this course matches:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  reason,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(RIASECType type) {
    switch (type) {
      case RIASECType.realistic:
        return const Color(0xFFE53E3E);
      case RIASECType.investigative:
        return const Color.fromARGB(255, 32, 81, 230);
      case RIASECType.artistic:
        return AppTheme.primaryPurple;
      case RIASECType.social:
        return const Color.fromARGB(255, 33, 212, 17);
      case RIASECType.enterprising:
        return AppTheme.primaryYellow;
      case RIASECType.conventional:
        return const Color.fromARGB(255, 244, 133, 6);
    }
  }

  void _approveRecommendation(PendingApproval approval) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Recommendation'),
        content: const Text('This will approve the course recommendations and send them to the student. Would you like to provide feedback to improve the AI?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Approve Only'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to AI feedback screen
              context.go('/guidance-counselor/ai-feedback', extra: {
                'approval': approval,
                'action': 'approved',
              });
            },
            child: const Text('Approve & Give Feedback'),
          ),
        ],
      ),
    ).then((value) {
      if (value == true || value == null) {
        setState(() {
          _pendingApprovals.remove(approval);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Recommendation approved successfully'),
            backgroundColor: Color.fromARGB(255, 28, 230, 45),
          ),
        );
      }
    });
  }

  void _showRejectDialog(BuildContext context, PendingApproval approval) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Recommendation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for rejection. This feedback will help improve the AI.'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for Rejection',
                hintText: 'e.g., Courses not suitable for student\'s current level...',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to AI feedback screen
              context.go('/guidance-counselor/ai-feedback', extra: {
                'approval': approval,
                'action': 'rejected',
                'reason': reasonController.text,
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53E3E),
            ),
            child: const Text('Reject & Give Feedback'),
          ),
        ],
      ),
    );
  }

  void _showModifyDialog(BuildContext context, PendingApproval approval) {
    context.go('/guidance-counselor/ai-feedback', extra: {
      'approval': approval,
      'action': 'modified',
    });
  }
}
