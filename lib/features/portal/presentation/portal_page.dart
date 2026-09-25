import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';

class PortalPage extends StatefulWidget {
  const PortalPage({super.key, required this.role});
  final PortalRole role;

  @override
  State<PortalPage> createState() => _PortalPageState();
}

enum PortalRole { admin, manager, staff }

extension on PortalRole {
  String get label => switch (this) {
        PortalRole.admin => 'Admin',
        PortalRole.manager => 'School Manager',
        PortalRole.staff => 'Staff',
      };

  String get greeting => switch (this) {
        PortalRole.admin => 'Good morning, Admin',
        PortalRole.manager => 'Good morning, Manager',
        PortalRole.staff => 'Good morning, Staff',
      };
}

class _PortalPageState extends State<PortalPage> {
  int _index = 0;

  List<_PortalDestination> get _destinations => switch (widget.role) {
        PortalRole.admin => const [
            _PortalDestination('Home', Icons.home_rounded),
            _PortalDestination('Students', Icons.groups_rounded),
            _PortalDestination('Staff', Icons.badge_rounded),
            _PortalDestination('Reports', Icons.bar_chart_rounded),
            _PortalDestination('More', Icons.menu_rounded),
          ],
        PortalRole.manager => const [
            _PortalDestination('Home', Icons.home_rounded),
            _PortalDestination('Cases', Icons.warning_amber_rounded),
            _PortalDestination('Students', Icons.groups_rounded),
            _PortalDestination('Reports', Icons.bar_chart_rounded),
            _PortalDestination('More', Icons.menu_rounded),
          ],
        PortalRole.staff => const [
            _PortalDestination('Home', Icons.home_rounded),
            _PortalDestination('Students', Icons.groups_rounded),
            _PortalDestination('Discipline', Icons.shield_rounded),
            _PortalDestination('Alerts', Icons.notifications_rounded),
            _PortalDestination('More', Icons.menu_rounded),
          ],
      };

  @override
  Widget build(BuildContext context) {
    final destinations = _destinations;
    return Scaffold(
      appBar: AppBar(
        title: Text('KTDS \u00B7 ${widget.role.label}'),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () => context.go('/login'),
            icon: const Icon(Icons.logout_rounded),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.lightBlue,
              child: Icon(Icons.person_outline, color: AppColors.deepBlue),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: [
          _Overview(role: widget.role),
          ...List.generate(
              destinations.length - 1,
              (i) => _PortalSection(
                  title: destinations[i + 1].label, role: widget.role)),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          for (final destination in destinations)
            NavigationDestination(
                icon: Icon(destination.icon), label: destination.label),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handlePrimaryAction(context),
        icon: Icon(widget.role == PortalRole.admin ? Icons.vpn_key_rounded : Icons.add_rounded),
        label: Text(switch (widget.role) {
          PortalRole.admin => 'Generate referral code',
          PortalRole.manager => 'Review 18/40 cases',
          PortalRole.staff => 'Record incident',
        }),
      ),
    );
  }

  void _handlePrimaryAction(BuildContext context) {
    if (widget.role == PortalRole.admin) {
      _showReferralGeneratorModal(context);
    } else if (widget.role == PortalRole.manager) {
      context.push('/case/patrick');
    } else {
      context.push('/record-incident');
    }
  }

  void _showReferralGeneratorModal(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    String selectedRole = 'TEACHER';
    String? generatedCode;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Generate Staff Referral Code',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text('Create a 5-digit single-use invitation code for staff onboarding.'),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Staff full name', prefixIcon: Icon(Icons.person_outline)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Staff email', prefixIcon: Icon(Icons.email_outlined)),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedRole,
                decoration: const InputDecoration(labelText: 'Staff role'),
                items: const [
                  DropdownMenuItem(value: 'TEACHER', child: Text('Teacher')),
                  DropdownMenuItem(value: 'DOD', child: Text('DOD')),
                  DropdownMenuItem(value: 'PATRON', child: Text('Patron')),
                  DropdownMenuItem(value: 'MATRON', child: Text('Matron')),
                ],
                onChanged: (val) => setModalState(() => selectedRole = val!),
              ),
              const SizedBox(height: 20),
              if (generatedCode != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryBlue),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.vpn_key_rounded, color: AppColors.deepBlue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('5-Digit Referral Code', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                            Text(generatedCode!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 4, color: AppColors.primaryBlue)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, color: AppColors.primaryBlue),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: generatedCode!));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Referral code copied to clipboard!')));
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              ElevatedButton.icon(
                onPressed: () {
                  final code = (10000 + (DateTime.now().microsecondsSinceEpoch % 90000)).toString();
                  setModalState(() {
                    generatedCode = code;
                  });
                },
                icon: const Icon(Icons.check_rounded),
                label: Text(generatedCode == null ? 'Generate 5-Digit Code' : 'Regenerate Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.role});
  final PortalRole role;

  @override
  Widget build(BuildContext context) {
    final manager = role == PortalRole.manager;
    final admin = role == PortalRole.admin;

    return RefreshIndicator(
      onRefresh: () async => Future<void>.delayed(const Duration(milliseconds: 400)),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 90),
        children: [
          Text(role.greeting, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('Here is your school discipline overview.', style: TextStyle(color: Colors.blueGrey.shade600)),
          const SizedBox(height: 22),
          if (manager) const _AttentionCard(),
          if (!manager) const _AcademicCard(),
          const SizedBox(height: 18),
          _Stats(role: role),
          const SizedBox(height: 24),
          if (admin) ...[
            Text('Pending Teacher Deductions', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            const _PendingApprovalCard(),
            const SizedBox(height: 20),
          ],
          Text(manager ? 'Recent cases' : 'Recent activity', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          const _Activity(
            title: 'Patrick N. \u00B7 S5 Software Development',
            subtitle: 'Discipline threshold reached \u00B7 18 / 40',
            color: AppColors.danger,
            icon: Icons.warning_amber_rounded,
          ),
          const _Activity(
            title: 'Teacher deduction submitted',
            subtitle: 'Awaiting Admin approval',
            color: AppColors.warning,
            icon: Icons.pending_actions_rounded,
          ),
          const _Activity(
            title: 'School announcement',
            subtitle: 'New discipline meeting notice',
            color: AppColors.primaryBlue,
            icon: Icons.campaign_outlined,
          ),
        ],
      ),
    );
  }
}

class _PendingApprovalCard extends StatelessWidget {
  const _PendingApprovalCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFFFF3D6),
                  child: Icon(Icons.pending_actions_rounded, color: AppColors.warning),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Late to class (-2 pts)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                      Text('Submitted by: Aline Nshimiyimana (Teacher)\nStudent: Patrick N. (S5 SD)'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deduction request rejected.')));
                  },
                  child: const Text('Reject', style: TextStyle(color: AppColors.danger)),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deduction approved! Score updated to 32/40.')));
                  },
                  child: const Text('Approve'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AcademicCard extends StatelessWidget {
  const _AcademicCard();
  @override
  Widget build(BuildContext context) => Card(
        color: AppColors.deepBlue,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('KAGEYO TSS', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Academic Year 2026\u20132027\nTerm 2 Active', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                ],
              ),
              const Icon(Icons.school_rounded, color: Colors.white70, size: 38),
            ],
          ),
        ),
      );
}

class _AttentionCard extends StatelessWidget {
  const _AttentionCard();
  @override
  Widget build(BuildContext context) => Card(
        color: AppColors.danger,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('CASES REQUIRING ATTENTION', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700, letterSpacing: 1)),
              const SizedBox(height: 10),
              Text('7 students at 18 / 40', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => context.push('/case/patrick'),
                child: const Text('Review cases & WhatsApp history'),
              ),
            ],
          ),
        ),
      );
}

class _Stats extends StatelessWidget {
  const _Stats({required this.role});
  final PortalRole role;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Students', '524', Icons.groups_rounded),
      ('Classes', '18', Icons.class_outlined),
      ('Incidents', '24', Icons.report_outlined),
      ('18/40 cases', '7', Icons.warning_amber_rounded)
    ];
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.45,
      children: [
        for (final item in items)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(item.$3, color: item.$1 == '18/40 cases' ? AppColors.danger : AppColors.primaryBlue),
                  Text(item.$2, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                  Text(item.$1, style: TextStyle(color: Colors.blueGrey.shade600)),
                ],
              ),
            ),
          )
      ],
    );
  }
}

class _Activity extends StatelessWidget {
  const _Activity({required this.title, required this.subtitle, required this.color, required this.icon});
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: CircleAvatar(backgroundColor: color.withValues(alpha: .12), child: Icon(icon, color: color)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right_rounded),
        ),
      );
}

class _PortalSection extends StatelessWidget {
  const _PortalSection({required this.title, required this.role});
  final String title;
  final PortalRole role;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 90),
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Manage ${title.toLowerCase()} with clear, secure school workflows.', style: TextStyle(color: Colors.blueGrey.shade600)),
          const SizedBox(height: 20),
          if (title == 'Cases' || title == 'Discipline')
            const _CaseTile()
          else if (title == 'Students')
            const _StudentTile()
          else ...const [
            _ActionTile(icon: Icons.inbox_outlined, title: 'No new items', subtitle: 'Everything is up to date'),
            _ActionTile(icon: Icons.search_rounded, title: 'Search records', subtitle: 'Find students, classes, incidents and letters'),
          ]
        ],
      );
}

class _CaseTile extends StatelessWidget {
  const _CaseTile();

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: const CircleAvatar(backgroundColor: Color(0xFFFFE8E8), child: Icon(Icons.warning_amber_rounded, color: AppColors.danger)),
          title: const Text('Patrick N.', style: TextStyle(fontWeight: FontWeight.w800)),
          subtitle: const Text('S5 Software Development\nThreshold reached \u00B7 18 / 40'),
          trailing: FilledButton(onPressed: () => context.push('/case/patrick'), child: const Text('Review')),
        ),
      );
}

class _StudentTile extends StatelessWidget {
  const _StudentTile();

  @override
  Widget build(BuildContext context) => Column(children: const [
        _ActionTile(icon: Icons.person_outline, title: 'Patrick N.', subtitle: 'S5 Software Development \u00B7 18 / 40'),
        _ActionTile(icon: Icons.person_outline, title: 'Amina K.', subtitle: 'S3 Business Studies \u00B7 21 / 40'),
        _ActionTile(icon: Icons.person_outline, title: 'Joel M.', subtitle: 'S2 Geography \u00B7 17 / 40'),
      ]);
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.icon, required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: Icon(icon, color: AppColors.primaryBlue),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right_rounded),
        ),
      );
}

class _PortalDestination {
  const _PortalDestination(this.label, this.icon);
  final String label;
  final IconData icon;
}
