class MockKtdsData {
  static const admin = {
    'id': 'admin-001',
    'name': 'Kageyo TSS Admin',
    'email': 'kageyotss@gmail.com',
    'role': 'ADMIN',
    'mustChangePassword': true,
  };

  static const manager = {
    'id': 'manager-001',
    'name': 'Jane Mukamana',
    'email': 'manager@ktds.test',
    'role': 'SCHOOL_MANAGER',
    'status': 'ACTIVE',
  };

  static const staff = [
    {
      'id': 'teacher-001',
      'name': 'Aline Nshimiyimana',
      'email': 'teacher@ktds.test',
      'role': 'TEACHER',
      'status': 'ACTIVE',
      'className': 'S5 Software Development',
    },
    {
      'id': 'dod-001',
      'name': 'Caleb Mugenzi',
      'email': 'dod@ktds.test',
      'role': 'DOD',
      'status': 'ACTIVE',
      'className': 'S4 Electronics',
    },
    {
      'id': 'patron-001',
      'name': 'Grace Uwimana',
      'email': 'patron@ktds.test',
      'role': 'PATRON',
      'status': 'ACTIVE',
      'className': 'S3 Business Studies',
    },
    {
      'id': 'matron-001',
      'name': 'Diane Kamanzi',
      'email': 'matron@ktds.test',
      'role': 'MATRON',
      'status': 'ACTIVE',
      'className': 'S2 Geography',
    },
  ];

  static const students = [
    {
      'id': 'ST-1001',
      'firstName': 'Patrick',
      'lastName': 'N.',
      'className': 'S5 Software Development',
      'status': 'ACTIVE',
      'score': 32,
      'maxScore': 40,
      'disciplineThreshold': 18,
      'parentName': 'N. Patrick',
      'parentPhone': '+250788000001',
      'whatsappEnabled': true,
    },
    {
      'id': 'ST-1002',
      'firstName': 'Amina',
      'lastName': 'K.',
      'className': 'S3 Business Studies',
      'status': 'UNDER_REVIEW',
      'score': 21,
      'maxScore': 40,
      'disciplineThreshold': 18,
      'parentName': 'K. Amina',
      'parentPhone': '+250788000002',
      'whatsappEnabled': true,
    },
    {
      'id': 'ST-1003',
      'firstName': 'Joel',
      'lastName': 'M.',
      'className': 'S2 Geography',
      'status': 'DISCIPLINARY_CASE',
      'score': 17,
      'maxScore': 40,
      'disciplineThreshold': 18,
      'parentName': 'M. Joel',
      'parentPhone': '+250788000003',
      'whatsappEnabled': true,
    },
  ];

  static const incidents = [
    {
      'id': 'INC-001',
      'studentId': 'ST-1001',
      'category': 'Late to class',
      'points': 2,
      'status': 'PENDING_APPROVAL',
      'staffRole': 'TEACHER',
      'createdAt': '2026-09-20T08:00:00Z',
    },
    {
      'id': 'INC-002',
      'studentId': 'ST-1002',
      'category': 'Disrespect',
      'points': 5,
      'status': 'APPROVED',
      'staffRole': 'DOD',
      'createdAt': '2026-09-22T09:30:00Z',
    },
    {
      'id': 'INC-003',
      'studentId': 'ST-1003',
      'category': 'Uniform violation',
      'points': 7,
      'status': 'AUTO_ESCALATED',
      'staffRole': 'MATRON',
      'createdAt': '2026-09-23T11:00:00Z',
    },
  ];

  static const notifications = [
    {
      'id': 'NOT-001',
      'type': 'THRESHOLD',
      'title': 'Student reached 18/40',
      'message': 'Patrick N. crossed the threshold and a parent notification was queued.',
      'read': false,
    },
    {
      'id': 'NOT-002',
      'type': 'APPROVAL',
      'title': 'Teacher deduction approved',
      'message': 'Aline Nshimiyimana submitted a deduction that is now approved.',
      'read': false,
    },
    {
      'id': 'NOT-003',
      'type': 'WHATSAPP',
      'title': 'WhatsApp delivery status',
      'message': 'Parent notification sent and attachment status is pending confirmation.',
      'read': true,
    },
  ];

  static const announcements = [
    {
      'id': 'ANN-001',
      'title': 'School assembly',
      'message': 'Friday assembly will start at 9:00 AM in the main hall.',
      'audience': 'ALL_STAFF',
    },
    {
      'id': 'ANN-002',
      'title': 'Discipline meeting notice',
      'message': 'Students at 18/40 or below will be reviewed by the management team.',
      'audience': 'MANAGERS',
    },
  ];
}
