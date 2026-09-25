import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/network/ktds_api.dart';
import '../../../core/widgets/ktds_states.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../announcements/presentation/announcements_page.dart';
import '../../notifications/presentation/notification_center_page.dart';

class KtdsShell extends ConsumerStatefulWidget {
  const KtdsShell({super.key, required this.role});
  final String role;

  @override
  ConsumerState<KtdsShell> createState() => _KtdsShellState();
}

class _KtdsShellState extends ConsumerState<KtdsShell> {
  int _selectedIndex = 0;

  List<_NavItem> _itemsFor(String role) {
    final common = <_NavItem>[
      const _NavItem('Dashboard', Icons.dashboard_outlined),
      const _NavItem('Students', Icons.groups_outlined),
      const _NavItem('Discipline', Icons.shield_outlined),
    ];
    if (role == 'SCHOOL_MANAGER') {
      common.add(const _NavItem('18/40 Cases', Icons.warning_amber_outlined));
    } else if (role == 'ADMIN') {
      common.add(const _NavItem('Invitations', Icons.vpn_key_outlined));
    }
    common.addAll(const [
      _NavItem('Notifications', Icons.notifications_none_rounded),
      _NavItem('Announcements', Icons.campaign_outlined),
    ]);
    return common;
  }

  @override
  Widget build(BuildContext context) {
    final currentRole = ref.watch(authRoleProvider) ?? widget.role;
    final items = _itemsFor(currentRole);
    final compact = MediaQuery.sizeOf(context).width < 700;
    final content = _pageFor(items[_selectedIndex].label, currentRole);
    return Scaffold(
      appBar: compact
          ? AppBar(
              title: const Text('KTDS', style: TextStyle(fontWeight: FontWeight.w800)),
              actions: [_profileButton(context)],
            )
          : null,
      body: Row(
        children: [
          if (!compact) _Sidebar(items: items, selectedIndex: _selectedIndex, onSelected: _select),
          Expanded(
            child: Column(
              children: [
                if (!compact) _TopBar(role: currentRole, onNotifications: () => _selectByLabel('Notifications')),
                Expanded(child: content),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: compact
          ? NavigationBar(
              selectedIndex: _selectedIndex.clamp(0, items.length - 1),
              onDestinationSelected: _select,
              destinations: [
                for (final item in items.take(4))
                  NavigationDestination(icon: Icon(item.icon), label: item.label),
              ],
            )
          : null,
      floatingActionButton: _canRecord(currentRole) ? FloatingActionButton.extended(
        onPressed: () => context.push('/record-incident'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Record incident'),
      ) : null,
    );
  }

  bool _canRecord(String role) => const {'TEACHER', 'DOD', 'PATRON', 'MATRON'}.contains(role);

  Widget _profileButton(BuildContext context) => IconButton(
        tooltip: 'Sign out',
        onPressed: () => context.go('/login'),
        icon: const Icon(Icons.logout_rounded),
      );

  void _select(int index) => setState(() => _selectedIndex = index);
  void _selectByLabel(String label) {
    final role = ref.read(authRoleProvider) ?? widget.role;
    final index = _itemsFor(role).indexWhere((item) => item.label == label);
    if (index >= 0) _select(index);
  }

  Widget _pageFor(String label, String role) => switch (label) {
        'Dashboard' => DashboardView(role: role),
        'Students' => const StudentsView(),
        'Discipline' => DisciplineView(role: role),
        '18/40 Cases' => const CasesView(),
        'Invitations' => const InvitationsView(),
        'Notifications' => const NotificationCenterPage(),
        'Announcements' => const AnnouncementsPage(),
        _ => const KtdsEmptyState(title: 'Workspace unavailable', message: 'This section is not enabled for your account.'),
      };
}

class _NavItem {
  const _NavItem(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.items, required this.selectedIndex, required this.onSelected});
  final List<_NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => Container(
        width: 248,
        color: Colors.white,
        child: SafeArea(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 18, 28),
              child: Row(children: [
                Image.asset('assets/images/KTSSlogo.png', width: 42, height: 42),
                const SizedBox(width: 10),
                const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('KTDS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: AppColors.deepBlue)),
                  Text('Kageyo TSS', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                ]),
              ]),
            ),
            for (var i = 0; i < items.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                child: ListTile(
                  selected: i == selectedIndex,
                  selectedTileColor: AppColors.lightBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  leading: Icon(items[i].icon),
                  title: Text(items[i].label),
                  onTap: () => onSelected(i),
                ),
              ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text('Kageyo TSS Discipline System', style: TextStyle(fontSize: 11, color: Colors.blueGrey)),
            ),
          ]),
        ),
      );
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.role, required this.onNotifications});
  final String role;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) => Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        color: Colors.white,
        child: Row(children: [
          const Expanded(child: Text('Kageyo TSS Discipline System', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
          IconButton(tooltip: 'Notifications', onPressed: onNotifications, icon: const Icon(Icons.notifications_none_rounded)),
          const SizedBox(width: 8),
          CircleAvatar(backgroundColor: AppColors.lightBlue, child: Text(role.substring(0, 1), style: const TextStyle(color: AppColors.deepBlue, fontWeight: FontWeight.w800))),
          const SizedBox(width: 10),
          Text(role.replaceAll('_', ' '), style: const TextStyle(fontWeight: FontWeight.w700)),
        ]),
      );
}

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key, required this.role});
  final String role;
  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  late Future<Map<String, dynamic>> _future;
  @override
  void initState() { super.initState(); _future = ref.read(ktdsApiProvider).dashboardStats(); }
  @override
  Widget build(BuildContext context) => FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const KtdsLoadingState();
          if (snapshot.hasError) return KtdsErrorState(error: snapshot.error!, onRetry: () => setState(() => _future = ref.read(ktdsApiProvider).dashboardStats()));
          final stats = snapshot.data!;
          return ListView(padding: const EdgeInsets.all(28), children: [
            Text('Welcome back', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text('${widget.role.replaceAll('_', ' ')} workspace · live school data', style: TextStyle(color: Colors.blueGrey.shade600)),
            const SizedBox(height: 26),
            Wrap(spacing: 14, runSpacing: 14, children: [
              _StatCard('Students', stats['totalStudents'], Icons.groups_rounded, AppColors.primaryBlue),
              _StatCard('Active students', stats['activeStudents'], Icons.verified_user_outlined, AppColors.success),
              _StatCard('18/40 cases', stats['thresholdCases'], Icons.warning_amber_rounded, AppColors.warning),
              _StatCard('Pending deductions', stats['pendingDeductions'], Icons.pending_actions_rounded, AppColors.danger),
            ]),
            const SizedBox(height: 28),
            Card(child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [
              const Icon(Icons.info_outline, color: AppColors.deepBlue),
              const SizedBox(width: 12),
              Expanded(child: Text('All figures come from the KTDS school server. Open Students, Discipline, or 18/40 Cases to review the underlying records.')),
            ]))),
          ]);
        },
      );
}

class _StatCard extends StatelessWidget {
  const _StatCard(this.label, this.value, this.icon, this.color);
  final String label; final dynamic value; final IconData icon; final Color color;
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 220,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(children: [
              CircleAvatar(backgroundColor: color.withValues(alpha: .12), child: Icon(icon, color: color)),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(value?.toString() ?? '—', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
                Text(label, style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 12)),
              ]),
            ]),
          ),
        ),
      );
}

class StudentsView extends ConsumerStatefulWidget {
  const StudentsView({super.key});
  @override
  ConsumerState<StudentsView> createState() => _StudentsViewState();
}

class _StudentsViewState extends ConsumerState<StudentsView> {
  late Future<List<Map<String, dynamic>>> _future;
  String _query = '';
  @override
  void initState() { super.initState(); _future = ref.read(ktdsApiProvider).students(); }
  @override
  Widget build(BuildContext context) => FutureBuilder<List<Map<String, dynamic>>>(
    future: _future,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) return const KtdsLoadingState();
      if (snapshot.hasError) return KtdsErrorState(error: snapshot.error!, onRetry: () => setState(() => _future = ref.read(ktdsApiProvider).students()));
      final students = snapshot.data!.where((s) => (s['fullName'] ?? '${s['firstName'] ?? ''} ${s['lastName'] ?? ''}').toString().toLowerCase().contains(_query.toLowerCase())).toList();
      return Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(28, 24, 28, 12), child: TextField(onChanged: (value) => setState(() => _query = value), decoration: const InputDecoration(labelText: 'Search students', prefixIcon: Icon(Icons.search)))),
        Expanded(child: students.isEmpty ? const KtdsEmptyState(title: 'No students found', message: 'There are no student records matching this search.') : ListView.builder(
          padding: const EdgeInsets.fromLTRB(28, 4, 28, 28), itemCount: students.length, itemBuilder: (context, index) {
            final student = students[index];
            final name = student['fullName'] ?? '${student['firstName'] ?? ''} ${student['lastName'] ?? ''}';
            return Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(
              leading: CircleAvatar(backgroundColor: AppColors.lightBlue, child: Text(name.toString().trim().isEmpty ? '?' : name.toString().trim()[0].toUpperCase())),
              title: Text(name.toString(), style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text('${student['studentId'] ?? 'No ID'} · ${student['className'] ?? 'Class not assigned'}'),
              trailing: KtdsStatusBadge((student['status'] ?? 'UNKNOWN').toString(), color: AppColors.success),
            ));
          },
        )),
      ]);
    },
  );
}

class DisciplineView extends ConsumerStatefulWidget {
  const DisciplineView({super.key, required this.role});
  final String role;
  @override
  ConsumerState<DisciplineView> createState() => _DisciplineViewState();
}

class _DisciplineViewState extends ConsumerState<DisciplineView> {
  late Future<List<Map<String, dynamic>>> _future;
  @override
  void initState() { super.initState(); _future = ref.read(ktdsApiProvider).incidents(); }
  @override
  Widget build(BuildContext context) => FutureBuilder<List<Map<String, dynamic>>>(
    future: _future,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) return const KtdsLoadingState();
      if (snapshot.hasError) return KtdsErrorState(error: snapshot.error!, onRetry: () => setState(() => _future = ref.read(ktdsApiProvider).incidents()));
      final incidents = snapshot.data!;
      if (incidents.isEmpty) return const KtdsEmptyState(title: 'No discipline incidents', message: 'Recorded incidents will appear here once submitted.', icon: Icons.shield_outlined);
      return ListView(padding: const EdgeInsets.all(28), children: [
        Text('Discipline records', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 14),
        for (final incident in incidents) Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(
          leading: const CircleAvatar(backgroundColor: Color(0xFFFFF3D6), child: Icon(Icons.shield_outlined, color: AppColors.warning)),
          title: Text((incident['category'] ?? 'Incident').toString(), style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text('${incident['studentId'] ?? 'Student'} · ${incident['description'] ?? ''}'),
          trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('-${incident['points'] ?? 0}', style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w900)),
            KtdsStatusBadge((incident['status'] ?? 'PENDING').toString()),
          ]),
        )),
      ]);
    },
  );
}

class CasesView extends ConsumerStatefulWidget {
  const CasesView({super.key});
  @override
  ConsumerState<CasesView> createState() => _CasesViewState();
}
class _CasesViewState extends ConsumerState<CasesView> {
  late Future<List<Map<String, dynamic>>> _future;
  @override
  void initState() { super.initState(); _future = ref.read(ktdsApiProvider).cases(); }
  @override
  Widget build(BuildContext context) => FutureBuilder<List<Map<String, dynamic>>>(
    future: _future,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) return const KtdsLoadingState();
      if (snapshot.hasError) return KtdsErrorState(error: snapshot.error!, onRetry: () => setState(() => _future = ref.read(ktdsApiProvider).cases()));
      final cases = snapshot.data!;
      if (cases.isEmpty) return const KtdsEmptyState(title: 'No 18/40 cases', message: 'Students requiring threshold review will appear here.', icon: Icons.warning_amber_outlined);
      return ListView(padding: const EdgeInsets.all(28), children: [
        Text('18/40 threshold cases', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        const Text('Review the student, current score, and next action before communicating with a parent.'),
        const SizedBox(height: 18),
        for (final item in cases) Card(child: ListTile(
          leading: const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
          title: Text((item['studentId'] ?? item['caseId'] ?? 'Student case').toString(), style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text('Score: ${item['score'] ?? 'Not provided'} / 40'),
          trailing: KtdsStatusBadge((item['status'] ?? 'OPEN').toString(), color: AppColors.warning),
        )),
      ]);
    },
  );
}

class InvitationsView extends ConsumerStatefulWidget {
  const InvitationsView({super.key});
  @override
  ConsumerState<InvitationsView> createState() => _InvitationsViewState();
}
class _InvitationsViewState extends ConsumerState<InvitationsView> {
  late Future<List<Map<String, dynamic>>> _future;
  @override
  void initState() { super.initState(); _future = ref.read(ktdsApiProvider).invitations(); }
  @override
  Widget build(BuildContext context) => FutureBuilder<List<Map<String, dynamic>>>(
    future: _future,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) return const KtdsLoadingState();
      if (snapshot.hasError) return KtdsErrorState(error: snapshot.error!, onRetry: () => setState(() => _future = ref.read(ktdsApiProvider).invitations()));
      final invitations = snapshot.data!;
      return ListView(padding: const EdgeInsets.all(28), children: [
        Row(children: [Expanded(child: Text('Staff invitations', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900))), FilledButton.icon(onPressed: () => _create(context), icon: const Icon(Icons.add), label: const Text('Create'))]),
        const SizedBox(height: 16),
        if (invitations.isEmpty) const KtdsEmptyState(title: 'No invitations', message: 'Create a referral invitation when onboarding a staff member.', icon: Icons.vpn_key_outlined),
        for (final item in invitations) Card(child: ListTile(title: Text((item['fullName'] ?? item['name'] ?? 'Staff invitation').toString()), subtitle: Text('${item['email'] ?? ''} · ${item['role'] ?? ''}'), trailing: KtdsStatusBadge((item['status'] ?? 'UNUSED').toString()))),
      ]);
    },
  );
  Future<void> _create(BuildContext context) async {
    final name = TextEditingController();
    final email = TextEditingController();
    String role = 'TEACHER';
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create staff invitation'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Full name')),
            const SizedBox(height: 10),
            TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: role,
              items: const [
                DropdownMenuItem(value: 'TEACHER', child: Text('Teacher')),
                DropdownMenuItem(value: 'DOD', child: Text('DOD')),
                DropdownMenuItem(value: 'PATRON', child: Text('Patron')),
                DropdownMenuItem(value: 'MATRON', child: Text('Matron')),
              ],
              onChanged: (value) => setDialogState(() => role = value!),
            ),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (name.text.trim().isEmpty || email.text.trim().isEmpty) return;
              final result = await ref.read(ktdsApiProvider).createInvitation(name: name.text.trim(), email: email.text.trim(), role: role);
              if (!context.mounted) return;
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Referral code: ${result['referralCode'] ?? 'created'}')));
              setState(() => _future = ref.read(ktdsApiProvider).invitations());
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
