/// Stores the current user session in memory.
/// No localStorage — all in-app state only.
class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  // Student session
  String? studentId;
  String? studentFirstName;
  String? studentLastName;
  bool studentHasApproved = false;

  // Counselor session
  int? counselorId;
  String? counselorFirstName;
  String? counselorLastName;

  // Current role
  String? role; // 'student' or 'guidance_counselor'

  // Current assessment flow
  int? currentPiId;
  int? currentAssessmentId;
  int? currentResultId;

  String get fullName {
    if (role == 'student') {
      return '${studentFirstName ?? ''} ${studentLastName ?? ''}'.trim();
    } else {
      return '${counselorFirstName ?? ''} ${counselorLastName ?? ''}'.trim();
    }
  }

  void setStudent(Map<String, dynamic> data) {
    role                = 'student';
    studentId           = data['studentId'].toString();
    studentFirstName    = data['firstName'];
    studentLastName     = data['lastName'];
    studentHasApproved  = data['hasApproved'] ?? false;
  }

  void setCounselor(Map<String, dynamic> data) {
    role                 = 'guidance_counselor';
    counselorId          = data['counselorId'];
    counselorFirstName   = data['firstName'];
    counselorLastName    = data['lastName'];
  }

  void clearAssessmentFlow() {
    currentPiId          = null;
    currentAssessmentId  = null;
    currentResultId      = null;
  }

  void logout() {
    studentId            = null;
    studentFirstName     = null;
    studentLastName      = null;
    studentHasApproved   = false;
    counselorId          = null;
    counselorFirstName   = null;
    counselorLastName    = null;
    role                 = null;
    clearAssessmentFlow();
  }
}