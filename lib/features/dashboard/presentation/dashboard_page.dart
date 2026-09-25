import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KTDS'),
        actions: [
          IconButton(
              tooltip: 'Notifications',
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded)),
          const Padding(
              padding: EdgeInsets.only(right: 16),
              child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.lightBlue,
                  child:
                      Icon(Icons.person_outline, color: AppColors.deepBlue))),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: const [
        _HomeView(),
        _PlaceholderView(title: 'Students', icon: Icons.groups_rounded),
        _PlaceholderView(title: 'Discipline', icon: Icons.shield_outlined),
        _PlaceholderView(title: 'More', icon: Icons.menu_rounded)
      ]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.groups_outlined),
              selectedIcon: Icon(Icons.groups_rounded),
              label: 'Students'),
          NavigationDestination(
              icon: Icon(Icons.shield_outlined),
              selectedIcon: Icon(Icons.shield_rounded),
              label: 'Discipline'),
          NavigationDestination(icon: Icon(Icons.menu_rounded), label: 'More'),
        ],
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async =>
          Future<void>.delayed(const Duration(milliseconds: 500)),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          Text('Good morning, Admin',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('Here is your school discipline overview.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.blueGrey.shade600)),
          const SizedBox(height: 22),
          const _AcademicContextCard(),
          const SizedBox(height: 18),
          GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: const [
                _MetricCard(
                    label: 'Students',
                    value: '524',
                    icon: Icons.groups_rounded,
                    color: AppColors.primaryBlue),
                _MetricCard(
                    label: 'Teachers',
                    value: '42',
                    icon: Icons.badge_outlined,
                    color: AppColors.leafGreen),
                _MetricCard(
                    label: 'Classes',
                    value: '18',
                    icon: Icons.class_outlined,
                    color: AppColors.deepBlue),
                _MetricCard(
                    label: '18/40 cases',
                    value: '7',
                    icon: Icons.warning_amber_rounded,
                    color: AppColors.warning),
              ]),
          const SizedBox(height: 26),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Recent activity',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800)),
            TextButton(onPressed: () {}, child: const Text('View all'))
          ]),
          const SizedBox(height: 8),
          const _ActivityTile(
              icon: Icons.check_circle_outline,
              color: AppColors.success,
              title: 'Deduction approved',
              subtitle: 'Patrick N. \u00B7 S5 Software Development',
              time: '12 min ago'),
          const _ActivityTile(
              icon: Icons.warning_amber_rounded,
              color: AppColors.warning,
              title: 'Threshold case needs review',
              subtitle: '2 students are approaching 18/40',
              time: '1 hr ago'),
          const _ActivityTile(
              icon: Icons.person_add_alt_1_rounded,
              color: AppColors.primaryBlue,
              title: 'New invitation created',
              subtitle: 'Teacher invitation \u00B7 expires in 7 days',
              time: 'Yesterday'),
        ],
      ),
    );
  }
}

class _AcademicContextCard extends StatelessWidget {
  const _AcademicContextCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.deepBlue,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Academic year',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Colors.white70)),
            const SizedBox(height: 6),
            Text('2026\u20132027',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w800))
          ]),
          Container(width: 1, height: 42, color: Colors.white24),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('Current term',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Colors.white70)),
            const SizedBox(height: 6),
            Text('Term 2',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w800))
          ]),
        ]),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: color),
                  Text(value,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  Text(label,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.blueGrey.shade600))
                ])));
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile(
      {required this.icon,
      required this.color,
      required this.title,
      required this.subtitle,
      required this.time});
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            leading: CircleAvatar(
                backgroundColor: color.withValues(alpha: .12),
                child: Icon(icon, color: color, size: 20)),
            title: Text(title,
                style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(subtitle),
            trailing: Text(time,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Colors.blueGrey.shade500))));
  }
}

class _PlaceholderView extends StatelessWidget {
  const _PlaceholderView({required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 54, color: AppColors.primaryBlue),
      const SizedBox(height: 14),
      Text(title,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.w800)),
      const SizedBox(height: 6),
      Text('This workspace is ready for the next feature slice.',
          style: TextStyle(color: Colors.blueGrey.shade600))
    ]));
  }
}
