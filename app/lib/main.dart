import 'package:flutter/material.dart';

const Color appBg = Color(0xFF061A14);
const Color appCard = Color(0xFF0B241C);
const Color appField = Color(0xFF0F2E24);
const Color appBorder = Color(0xFF173D30);
const Color appGreen = Color(0xFF3DD189);
const Color appMuted = Color(0xFF8B9E96);
const Color appGold = Color(0xFFE5B54B);
const Color appPink = Color(0xFFE1306C);

void main() {
  runApp(const EdaratSocialApp());
}

class EdaratSocialApp extends StatelessWidget {
  const EdaratSocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'إدارة سوشيال',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: appBg,
        colorScheme: const ColorScheme.dark(
          primary: appGreen,
          surface: appCard,
          secondary: appGold,
        ),
        fontFamily: 'Handicrafts',
        appBarTheme: const AppBarTheme(
          backgroundColor: appBg,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: appCard,
          indicatorColor: appGreen.withOpacity(0.18),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 11),
          ),
        ),
        cardTheme: CardThemeData(
          color: appCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: appBorder),
          ),
        ),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    DashboardPage(),
    InboxPage(),
    AgentsPage(),
    ChannelsPage(),
    MorePage(),
  ];

  final List<String> titles = const [
    'الرئيسية',
    'المحادثات',
    'موظفو الذكاء الاصطناعي',
    'القنوات',
    'المزيد',
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: appGreen.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.hub_rounded,
                  color: appGreen,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إدارة سوشيال',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    titles[selectedIndex],
                    style: const TextStyle(
                      color: appMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                showMessage(context, 'لا توجد إشعارات جديدة حالياً');
              },
              icon: const Icon(Icons.notifications_none_rounded),
            ),
            const SizedBox(width: 6),
          ],
        ),
        body: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            setState(() => selectedIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              selectedIcon: Icon(Icons.chat_bubble_rounded),
              label: 'المحادثات',
            ),
            NavigationDestination(
              icon: Icon(Icons.smart_toy_outlined),
              selectedIcon: Icon(Icons.smart_toy_rounded),
              label: 'الموظفون',
            ),
            NavigationDestination(
              icon: Icon(Icons.share_outlined),
              selectedIcon: Icon(Icons.share_rounded),
              label: 'القنوات',
            ),
            NavigationDestination(
              icon: Icon(Icons.apps_outlined),
              selectedIcon: Icon(Icons.apps_rounded),
              label: 'المزيد',
            ),
          ],
        ),
      ),
    );
  }
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: appField,
    ),
  );
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  void _notify(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: appField,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: appBorder),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 850;
        final medium = constraints.maxWidth >= 560;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1160),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PremiumDashboardHeading(
                    onNotifications: () => _notify(
                      context,
                      'مركز الإشعارات سيظهر هنا عند تفعيل بيانات الحساب.',
                    ),
                  ),
                  const SizedBox(height: 20),
                  _PremiumDashboardHero(
                    wide: wide,
                    onTest: () => _notify(
                      context,
                      'هذه معاينة تصميمية. سيُفتح اختبار الموظف عند ربط شاشة الاختبار.',
                    ),
                    onChannels: () => _notify(
                      context,
                      'إدارة ربط القنوات موجودة ضمن شاشة القنوات.',
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _PremiumSectionHeading(
                    title: 'نظرة عامة',
                    subtitle: 'مؤشرات توضيحية لتصميم لوحة التحكم',
                    trailing: _PremiumPreviewBadge(),
                  ),
                  const SizedBox(height: 12),
                  _PremiumMetricGrid(medium: medium),
                  const SizedBox(height: 24),
                  if (wide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Expanded(flex: 6, child: _PremiumInboxPanel()),
                        SizedBox(width: 16),
                        Expanded(flex: 5, child: _PremiumAgentPanel()),
                      ],
                    )
                  else ...[
                    const _PremiumInboxPanel(),
                    const SizedBox(height: 16),
                    const _PremiumAgentPanel(),
                  ],
                  const SizedBox(height: 24),
                  if (wide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _PremiumActivityPanel(wide: wide),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _PremiumFollowUpPanel(
                            onOpen: () => _notify(
                              context,
                              'ستظهر تفاصيل المتابعة هنا بعد ربط بيانات الطلبات.',
                            ),
                          ),
                        ),
                      ],
                    )
                  else ...[
                    _PremiumActivityPanel(wide: wide),
                    const SizedBox(height: 16),
                    _PremiumFollowUpPanel(
                      onOpen: () => _notify(
                        context,
                        'ستظهر تفاصيل المتابعة هنا بعد ربط بيانات الطلبات.',
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  const _PremiumTrustNote(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PremiumDashboardHeading extends StatelessWidget {
  final VoidCallback onNotifications;

  const _PremiumDashboardHeading({required this.onNotifications});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: appGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'مساحة العمل',
                    style: TextStyle(
                      color: appGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Text(
                'أهلًا بك في إدارة سوشيال',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Handicrafts',
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'كل المحادثات، والردود، وفرص البيع في مكان واحد.',
                style: TextStyle(
                  color: appMuted,
                  fontSize: 12.5,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Material(
          color: appCard,
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            onTap: onNotifications,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: appBorder),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 23,
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: appGold,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PremiumDashboardHero extends StatelessWidget {
  final bool wide;
  final VoidCallback onTest;
  final VoidCallback onChannels;

  const _PremiumDashboardHero({
    required this.wide,
    required this.onTest,
    required this.onChannels,
  });

  @override
  Widget build(BuildContext context) {
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: appGreen.withOpacity(.12),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: appGreen.withOpacity(.28)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome_rounded, color: appGreen, size: 14),
              const SizedBox(width: 6),
              Text(
                'موظف الذكاء الاصطناعي',
                style: TextStyle(
                  color: appGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'حوّل المحادثات\nإلى فرص بيع حقيقية',
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight: FontWeight.w900,
            fontFamily: 'Handicrafts',
            height: 1.32,
            letterSpacing: -.35,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'نظّم رسائل قنواتك، اختبر ردود موظفك، وتابع الحالات التي تحتاج قرارك — من لوحة واحدة.',
          style: TextStyle(
            color: Colors.white.withOpacity(.72),
            fontSize: 13,
            height: 1.85,
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 9,
          runSpacing: 9,
          children: [
            FilledButton.icon(
              onPressed: onTest,
              style: FilledButton.styleFrom(
                backgroundColor: appGreen,
                foregroundColor: appBg,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              icon: const Icon(Icons.play_arrow_rounded, size: 19),
              label: const Text('اختبر الموظف الذكي'),
            ),
            OutlinedButton.icon(
              onPressed: onChannels,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withOpacity(.2)),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              icon: const Icon(Icons.link_rounded, size: 17),
              label: const Text('إدارة القنوات'),
            ),
          ],
        ),
      ],
    );

    final illustration = SizedBox(
      width: wide ? 250 : double.infinity,
      height: wide ? 210 : 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 176,
            height: 176,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appGreen.withOpacity(.055),
              border: Border.all(color: appGreen.withOpacity(.14)),
            ),
          ),
          Container(
            width: 136,
            height: 136,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appGreen.withOpacity(.07),
              border: Border.all(color: appGreen.withOpacity(.2)),
            ),
          ),
          Container(
            width: 91,
            height: 91,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(29),
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF3DD189), Color(0xFF167A55)],
              ),
              boxShadow: [
                BoxShadow(
                  color: appGreen.withOpacity(.22),
                  blurRadius: 35,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Icon(
              Icons.psychology_alt_rounded,
              color: Color(0xFF061A14),
              size: 50,
            ),
          ),
          Positioned(
            top: 17,
            right: wide ? 22 : 44,
            child: _PremiumFloatingIcon(
              icon: Icons.chat_bubble_rounded,
              color: appGreen,
            ),
          ),
          Positioned(
            bottom: 19,
            left: wide ? 24 : 42,
            child: _PremiumFloatingIcon(
              icon: Icons.shopping_bag_rounded,
              color: appGold,
            ),
          ),
          Positioned(
            top: 45,
            left: wide ? 21 : 50,
            child: _PremiumFloatingIcon(
              icon: Icons.bolt_rounded,
              color: appPink,
            ),
          ),
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF103D2B), Color(0xFF0B241C), Color(0xFF092018)],
        ),
        border: Border.all(color: appGreen.withOpacity(.23)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.16),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          children: [
            Positioned(
              top: -100,
              left: -60,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appGreen.withOpacity(.04),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(wide ? 26 : 20),
              child: wide
                  ? Row(
                      children: [
                        Expanded(child: copy),
                        const SizedBox(width: 18),
                        illustration,
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [copy, illustration],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumFloatingIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _PremiumFloatingIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: appCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(.38)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.15), blurRadius: 15),
        ],
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class _PremiumPreviewBadge extends StatelessWidget {
  const _PremiumPreviewBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: appGold.withOpacity(.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: appGold.withOpacity(.22)),
      ),
      child: Text(
        'معاينة',
        style: TextStyle(
          color: appGold,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PremiumSectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _PremiumSectionHeading({
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: appMuted, fontSize: 11.5, height: 1.5),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          trailing!,
        ],
      ],
    );
  }
}

class _PremiumMetricGrid extends StatelessWidget {
  final bool medium;
  const _PremiumMetricGrid({required this.medium});

  @override
  Widget build(BuildContext context) {
    final items = <_PremiumMetricData>[
      _PremiumMetricData(
        title: 'محادثات اليوم',
        value: '128',
        detail: '+18% مقارنة بالأمس',
        icon: Icons.forum_rounded,
        color: appGreen,
        progress: .76,
      ),
      _PremiumMetricData(
        title: 'ردود الموظف',
        value: '94',
        detail: 'من إجمالي 128 محادثة',
        icon: Icons.auto_awesome_rounded,
        color: const Color(0xFF62B6FF),
        progress: .69,
      ),
      _PremiumMetricData(
        title: 'فرص بيع',
        value: '16',
        detail: 'طلبات تحتاج متابعة',
        icon: Icons.shopping_bag_rounded,
        color: appGold,
        progress: .42,
      ),
      _PremiumMetricData(
        title: 'تحتاج تدخلك',
        value: '4',
        detail: 'محادثات بانتظار الفريق',
        icon: Icons.support_agent_rounded,
        color: appPink,
        progress: .22,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 980 ? 4 : 2;
        final gap = 12.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: items
              .map((item) => SizedBox(
                    width: width,
                    child: _PremiumMetricCard(data: item),
                  ))
              .toList(),
        );
      },
    );
  }
}

class _PremiumMetricData {
  final String title;
  final String value;
  final String detail;
  final IconData icon;
  final Color color;
  final double progress;

  const _PremiumMetricData({
    required this.title,
    required this.value,
    required this.detail,
    required this.icon,
    required this.color,
    required this.progress,
  });
}

class _PremiumMetricCard extends StatelessWidget {
  final _PremiumMetricData data;
  const _PremiumMetricCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: appBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.10), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: data.color.withOpacity(.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: data.color.withOpacity(.15)),
                ),
                child: Icon(data.icon, color: data.color, size: 21),
              ),
              const Spacer(),
              Icon(Icons.more_horiz_rounded, color: appMuted.withOpacity(.8), size: 21),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            data.title,
            style: TextStyle(color: appMuted, fontSize: 11.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Text(
            data.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 29,
              height: 1.15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.detail,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: appMuted, fontSize: 10.5),
          ),
          const SizedBox(height: 13),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: data.progress,
              minHeight: 4,
              backgroundColor: appField,
              valueColor: AlwaysStoppedAnimation<Color>(data.color),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const _PremiumPanel({required this.child, this.padding = const EdgeInsets.all(17)});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: appCard,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: appBorder),
      ),
      child: child,
    );
  }
}

class _PremiumInboxPanel extends StatelessWidget {
  const _PremiumInboxPanel();

  @override
  Widget build(BuildContext context) {
    return _PremiumPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: _PremiumSectionHeading(
                  title: 'صندوق المحادثات',
                  subtitle: 'عرض موحّد للقنوات الاجتماعية',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: appGreen.withOpacity(.1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  'عرض تجريبي',
                  style: TextStyle(color: appGreen, fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: const [
              _PremiumChannelChip(label: 'الكل', active: true, color: appGreen),
              _PremiumChannelChip(label: 'إنستغرام', color: appPink),
              _PremiumChannelChip(label: 'فيسبوك', color: Color(0xFF62B6FF)),
              _PremiumChannelChip(label: 'واتساب', color: Color(0xFF36C977)),
            ],
          ),
          const SizedBox(height: 8),
          const _PremiumConversationTile(
            initials: 'م',
            name: 'مها علي',
            channel: 'إنستغرام',
            message: 'ممكن أعرف سعر المنتج والتوصيل؟',
            time: 'قبل 3 د',
            unread: '2',
            color: appPink,
            status: 'بانتظار المتابعة',
          ),
          const _PremiumConversationTile(
            initials: 'ع',
            name: 'علي حسن',
            channel: 'فيسبوك',
            message: 'هل يتوفر لون آخر؟',
            time: 'قبل 12 د',
            color: Color(0xFF62B6FF),
            status: 'ردّ تجريبي',
          ),
          const _PremiumConversationTile(
            initials: 'س',
            name: 'سارة محمد',
            channel: 'واتساب',
            message: 'أريد تأكيد تفاصيل الطلب.',
            time: 'قبل 25 د',
            color: Color(0xFF36C977),
            status: 'تحتاج تأكيدًا',
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('هذه قائمة توضيحية؛ سيُفتح صندوق المحادثات الكامل عند ربطه.'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: appField,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: appGreen,
              side: BorderSide(color: appBorder),
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.forum_outlined, size: 17),
            label: const Text('فتح صندوق المحادثات', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _PremiumChannelChip extends StatelessWidget {
  final String label;
  final bool active;
  final Color color;
  const _PremiumChannelChip({required this.label, required this.color, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: active ? appGreen.withOpacity(.12) : appField,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: active ? appGreen.withOpacity(.4) : appBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!active) ...[
            Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: active ? appGreen : Colors.white.withOpacity(.78),
              fontSize: 10.5,
              fontWeight: active ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumConversationTile extends StatelessWidget {
  final String initials;
  final String name;
  final String channel;
  final String message;
  final String time;
  final String? unread;
  final Color color;
  final String status;

  const _PremiumConversationTile({
    required this.initials,
    required this.name,
    required this.channel,
    required this.message,
    required this.time,
    required this.color,
    required this.status,
    this.unread,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 9),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: appField.withOpacity(.65),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: appBorder.withOpacity(.85)),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: color.withOpacity(.13),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(.35)),
            ),
            alignment: Alignment.center,
            child: Text(initials, style: TextStyle(color: color, fontSize: 17, fontWeight: FontWeight.w900)),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(width: 7),
                    Text(channel, style: TextStyle(color: color, fontSize: 9.5, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text(time, style: TextStyle(color: appMuted, fontSize: 9.5)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(message, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: appMuted, fontSize: 11, height: 1.4)),
                const SizedBox(height: 7),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(.09),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(status, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
          if (unread != null) ...[
            const SizedBox(width: 7),
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: appGreen, shape: BoxShape.circle),
              child: Text(unread!, style: const TextStyle(color: appBg, fontSize: 10, fontWeight: FontWeight.w900)),
            ),
          ],
        ],
      ),
    );
  }
}

class _PremiumAgentPanel extends StatelessWidget {
  const _PremiumAgentPanel();

  @override
  Widget build(BuildContext context) {
    return _PremiumPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _PremiumSectionHeading(
            title: 'الموظف الذكي',
            subtitle: 'إعدادات الرد وجودة الإجابة',
          ),
          const SizedBox(height: 17),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [appGreen.withOpacity(.13), appField.withOpacity(.65)],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: appGreen.withOpacity(.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: appGreen.withOpacity(.15),
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: appGreen.withOpacity(.32)),
                  ),
                  child: const Icon(Icons.psychology_alt_rounded, color: appGreen, size: 29),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('موظف خدمة العملاء', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)),
                      SizedBox(height: 5),
                      Text('يرد من معلومات نشاطك', style: TextStyle(color: appMuted, fontSize: 10.5)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(color: appGold.withOpacity(.1), borderRadius: BorderRadius.circular(8)),
                  child: Text('معاينة', style: TextStyle(color: appGold, fontSize: 9.5, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _PremiumProgressLine(label: 'الاعتماد على قاعدة المعرفة', value: .86, valueLabel: 'مرتفع'),
          const SizedBox(height: 14),
          const _PremiumProgressLine(label: 'الحاجة إلى تحويل بشري', value: .24, valueLabel: 'منخفض'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: appGold.withOpacity(.07),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: appGold.withOpacity(.18)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.shield_outlined, color: appGold, size: 18),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'عندما لا يجد معلومة مؤكدة، يجب أن يطلب توضيحًا أو يحوّل المحادثة بدل اختراع إجابة.',
                    style: TextStyle(color: Colors.white.withOpacity(.75), fontSize: 10.5, height: 1.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumProgressLine extends StatelessWidget {
  final String label;
  final double value;
  final String valueLabel;
  const _PremiumProgressLine({required this.label, required this.value, required this.valueLabel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: TextStyle(color: appMuted, fontSize: 10.5, fontWeight: FontWeight.w600))),
            Text(valueLabel, style: const TextStyle(color: appGreen, fontSize: 10, fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 5,
            backgroundColor: appField,
            valueColor: const AlwaysStoppedAnimation<Color>(appGreen),
          ),
        ),
      ],
    );
  }
}

class _PremiumActivityPanel extends StatelessWidget {
  final bool wide;
  const _PremiumActivityPanel({required this.wide});

  @override
  Widget build(BuildContext context) {
    const heights = [25.0, 38.0, 31.0, 51.0, 42.0, 66.0, 49.0];
    const days = ['س', 'ح', 'ن', 'ث', 'ر', 'خ', 'ج'];
    return _PremiumPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _PremiumSectionHeading(
            title: 'نشاط المحادثات',
            subtitle: 'توزيع توضيحي خلال الأسبوع',
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(heights.length, (index) {
              final selected = index == 5;
              return Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(end: index == heights.length - 1 ? 0 : 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: heights[index],
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: selected
                                ? [appGreen, appGreen.withOpacity(.34)]
                                : [appGreen.withOpacity(.42), appGreen.withOpacity(.09)],
                          ),
                          border: Border.all(color: appGreen.withOpacity(selected ? .5 : .12)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(days[index], style: TextStyle(color: selected ? appGreen : appMuted, fontSize: 10, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),
          Divider(color: appBorder, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(width: 7, height: 7, decoration: const BoxDecoration(color: appGreen, shape: BoxShape.circle)),
              const SizedBox(width: 7),
              Expanded(child: Text('أعلى نشاط في نهاية الأسبوع', style: TextStyle(color: appMuted, fontSize: 10.5))),
              Text('توضيحي', style: TextStyle(color: appMuted.withOpacity(.7), fontSize: 9.5)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PremiumFollowUpPanel extends StatelessWidget {
  final VoidCallback onOpen;
  const _PremiumFollowUpPanel({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return _PremiumPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: _PremiumSectionHeading(
                  title: 'متابعة ذكية',
                  subtitle: 'أمثلة على حالات تحتاج انتباهك',
                ),
              ),
              Icon(Icons.task_alt_rounded, color: appGold, size: 21),
            ],
          ),
          const SizedBox(height: 13),
          const _PremiumFollowUpItem(
            icon: Icons.person_search_rounded,
            color: appGold,
            title: 'استفسار يحتاج قرارًا',
            detail: 'معلومة غير متوفرة في قاعدة المعرفة',
            tag: 'مراجعة',
          ),
          const SizedBox(height: 9),
          const _PremiumFollowUpItem(
            icon: Icons.local_shipping_outlined,
            color: appGreen,
            title: 'تأكيد تفاصيل الطلب',
            detail: 'التحقق من العنوان قبل الإتمام',
            tag: 'طلب',
          ),
          const SizedBox(height: 9),
          const _PremiumFollowUpItem(
            icon: Icons.schedule_rounded,
            color: Color(0xFF62B6FF),
            title: 'موعد يحتاج تأكيدًا',
            detail: 'تأكيد الوقت مع العميل',
            tag: 'موعد',
          ),
          const SizedBox(height: 14),
          TextButton.icon(
            onPressed: onOpen,
            style: TextButton.styleFrom(
              foregroundColor: appGreen,
              alignment: AlignmentDirectional.centerStart,
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 7),
            ),
            icon: const Icon(Icons.arrow_back_rounded, size: 17),
            label: const Text('عرض قائمة المتابعة', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

class _PremiumFollowUpItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String detail;
  final String tag;

  const _PremiumFollowUpItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.detail,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: appField.withOpacity(.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: appBorder.withOpacity(.8)),
      ),
      child: Row(
        children: [
          Container(
            width: 37,
            height: 37,
            decoration: BoxDecoration(color: color.withOpacity(.11), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(detail, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: appMuted, fontSize: 9.5)),
              ],
            ),
          ),
          const SizedBox(width: 7),
          Text(tag, style: TextStyle(color: color, fontSize: 9.5, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _PremiumTrustNote extends StatelessWidget {
  const _PremiumTrustNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: appCard.withOpacity(.72),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: appBorder.withOpacity(.85)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lock_outline_rounded, size: 17, color: appMuted),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'المعلومات والأرقام الظاهرة هنا أمثلة تصميمية فقط، وليست بيانات حساب متصل. سيظهر المحتوى الحقيقي بعد ربط خدمات التطبيق.',
              style: TextStyle(color: appMuted, fontSize: 10.5, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: appMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String detail;
  final IconData icon;
  final Color color;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.detail,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: appCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: appBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.13),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: appMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            detail,
            style: TextStyle(
              fontSize: 10,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class ShortcutCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ShortcutCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: appBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 27),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                color: appMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;

  const ActivityRow({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: appCard,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: appBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: appMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            time,
            style: const TextStyle(
              color: appMuted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  final TextEditingController searchController = TextEditingController();
  String selectedFilter = 'الكل';

  final List<Map<String, dynamic>> conversations = [
    {
      'name': 'سارة أحمد',
      'message': 'أريد معرفة تفاصيل الخدمة',
      'time': 'الآن',
      'platform': 'Instagram',
      'unread': true,
      'color': Color(0xFFE1306C),
      'initial': 'س',
    },
    {
      'name': 'محمد علي',
      'message': 'هل يمكنني حجز موعد؟',
      'time': 'قبل 8 د',
      'platform': 'WhatsApp',
      'unread': true,
      'color': Color(0xFF25D366),
      'initial': 'م',
    },
    {
      'name': 'نور حسين',
      'message': 'شكراً لكم على المساعدة',
      'time': 'قبل 25 د',
      'platform': 'Facebook',
      'unread': false,
      'color': Color(0xFF6CA8FF),
      'initial': 'ن',
    },
    {
      'name': 'علي كريم',
      'message': 'ما هي أوقات العمل؟',
      'time': 'قبل ساعة',
      'platform': 'Instagram',
      'unread': false,
      'color': Color(0xFFE1306C),
      'initial': 'ع',
    },
    {
      'name': 'زينب حسن',
      'message': 'هل توجد خدمة توصيل؟',
      'time': 'أمس',
      'platform': 'WhatsApp',
      'unread': false,
      'color': Color(0xFF25D366),
      'initial': 'ز',
    },
  ];

  final List<String> filters = [
    'الكل',
    'غير مقروءة',
    'Instagram',
    'WhatsApp',
    'Facebook',
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = searchController.text.trim().toLowerCase();

    final filtered = conversations.where((item) {
      final matchesSearch =
          item['name'].toString().toLowerCase().contains(query) ||
          item['message'].toString().toLowerCase().contains(query);

      final matchesFilter = switch (selectedFilter) {
        'غير مقروءة' => item['unread'] == true,
        'Instagram' => item['platform'] == 'Instagram',
        'WhatsApp' => item['platform'] == 'WhatsApp',
        'Facebook' => item['platform'] == 'Facebook',
        _ => true,
      };

      return matchesSearch && matchesFilter;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const Text(
          'صندوق الوارد',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'تابع محادثات عملائك من مكان واحد',
          style: TextStyle(color: appMuted, fontSize: 13),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: searchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'ابحث عن عميل أو رسالة...',
            hintStyle: const TextStyle(color: appMuted, fontSize: 13),
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: appField,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide.none,
            ),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      searchController.clear();
                      setState(() {});
                    },
                    icon: const Icon(Icons.close_rounded),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final filter = filters[index];
              final active = selectedFilter == filter;

              return ChoiceChip(
                label: Text(filter),
                selected: active,
                onSelected: (_) {
                  setState(() => selectedFilter = filter);
                },
                selectedColor: appGreen.withOpacity(0.18),
                backgroundColor: appCard,
                side: BorderSide(
                  color: active ? appGreen : appBorder,
                ),
                labelStyle: TextStyle(
                  color: active ? appGreen : appMuted,
                  fontSize: 12,
                ),
                showCheckmark: false,
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Text(
              'المحادثات الأخيرة',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '${filtered.length} محادثات',
              style: const TextStyle(
                color: appMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: appCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: appBorder),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 42,
                  color: appMuted,
                ),
                SizedBox(height: 12),
                Text('لا توجد محادثات مطابقة'),
                SizedBox(height: 5),
                Text(
                  'جرّب البحث باسم آخر أو غيّر التصفية',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        else
          ...filtered.map((item) {
            return ConversationTile(
              name: item['name'] as String,
              message: item['message'] as String,
              time: item['time'] as String,
              platform: item['platform'] as String,
              unread: item['unread'] as bool,
              color: item['color'] as Color,
              initial: item['initial'] as String,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChatPage(
                      customerName: item['name'] as String,
                      platform: item['platform'] as String,
                      platformColor: item['color'] as Color,
                    ),
                  ),
                );
              },
            );
          }),
        const SizedBox(height: 16),
        const Text(
          'ملاحظة: هذه محادثات تجريبية، ولم تُربط بعد بحسابات التواصل الاجتماعي.',
          style: TextStyle(
            color: appMuted,
            fontSize: 11,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class ConversationTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String platform;
  final bool unread;
  final Color color;
  final String initial;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.platform,
    required this.unread,
    required this.color,
    required this.initial,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(19),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: appCard,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: unread ? appGreen.withOpacity(0.35) : appBorder,
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: color.withOpacity(0.14),
                  child: Text(
                    initial,
                    style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: appCard, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: unread ? Colors.white : appMuted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    platform,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    color: appMuted,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 10),
                if (unread)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: appGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                const SizedBox(height: 5),
                const Icon(
                  Icons.chevron_left_rounded,
                  color: appMuted,
                  size: 19,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final String customerName;
  final String platform;
  final Color platformColor;

  const ChatPage({
    super.key,
    required this.customerName,
    required this.platform,
    required this.platformColor,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController =
      TextEditingController();
  final ScrollController scrollController = ScrollController();

  final List<Map<String, dynamic>> messages = [];

  bool aiEnabled = true;

  @override
  void initState() {
    super.initState();

    messages.addAll([
      {
        'text': 'مرحباً، أهلاً بك! كيف يمكننا مساعدتك؟',
        'mine': false,
        'time': '10:30',
      },
      {
        'text': 'أريد معرفة تفاصيل الخدمة والأسعار.',
        'mine': true,
        'time': '10:31',
      },
      {
        'text': 'بكل سرور، أخبرني بالخدمة التي تريد الاستفسار عنها.',
        'mine': false,
        'time': '10:31',
      },
    ]);
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void sendMessage() {
    final text = messageController.text.trim();

    if (text.isEmpty) return;

    setState(() {
      messages.add({
        'text': text,
        'mine': true,
        'time': TimeOfDay.now().format(context),
      });
      messageController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });

    showMessage(
      context,
      'أُضيفت الرسالة محلياً فقط، ولم تُرسل إلى العميل',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: widget.platformColor.withOpacity(0.15),
              child: Text(
                widget.customerName.isNotEmpty
                    ? widget.customerName.substring(0, 1)
                    : 'ع',
                style: TextStyle(
                  color: widget.platformColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.customerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.platform,
                    style: TextStyle(
                      color: widget.platformColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showMessage(context, 'ملف العميل التجريبي');
            },
            icon: const Icon(Icons.person_outline_rounded),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'details') {
                showMessage(context, 'تفاصيل العميل التجريبية');
              } else if (value == 'clear') {
                setState(() => messages.clear());
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'details',
                child: Text('تفاصيل العميل'),
              ),
              PopupMenuItem(
                value: 'clear',
                child: Text('مسح الرسائل المعروضة'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(14, 8, 14, 10),
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: appCard,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: appBorder),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.smart_toy_rounded,
                  color: aiEnabled ? appGreen : appMuted,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'الموظف الذكي',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        aiEnabled ? 'مفعّل محلياً' : 'متوقف محلياً',
                        style: const TextStyle(
                          color: appMuted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: aiEnabled,
                  activeThumbColor: appGreen,
                  onChanged: (value) {
                    setState(() => aiEnabled = value);
                    showMessage(
                      context,
                      'تغيّر العرض المحلي فقط؛ لم يتغير إعداد خادم حقيقي',
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: messages.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.forum_outlined,
                          size: 45,
                          color: appMuted,
                        ),
                        SizedBox(height: 10),
                        Text('لا توجد رسائل معروضة'),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final mine = message['mine'] as bool;

                      return Align(
                        alignment: mine
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width * 0.78,
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.fromLTRB(
                            14,
                            11,
                            14,
                            8,
                          ),
                          decoration: BoxDecoration(
                            color: mine ? const Color(0xFF124532) : appCard,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(18),
                              topRight: const Radius.circular(18),
                              bottomLeft: Radius.circular(mine ? 18 : 5),
                              bottomRight: Radius.circular(mine ? 5 : 18),
                            ),
                            border: Border.all(
                              color: mine ? appGreen.withOpacity(0.2) : appBorder,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['text'] as String,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.7,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  message['time'] as String,
                                  style: const TextStyle(
                                    color: appMuted,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            decoration: const BoxDecoration(
              color: appCard,
              border: Border(
                top: BorderSide(color: appBorder),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      showMessage(
                        context,
                        'إرفاق الملفات غير متاح في النسخة التجريبية',
                      );
                    },
                    icon: const Icon(
                      Icons.add_circle_outline_rounded,
                      color: appGreen,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالة...',
                        hintStyle: const TextStyle(
                          color: appMuted,
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: appField,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: appGreen,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(
                        Icons.send_rounded,
                        color: appBg,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AgentsPage extends StatefulWidget {
  const AgentsPage({super.key});

  @override
  State<AgentsPage> createState() => _AgentsPageState();
}

class _AgentsPageState extends State<AgentsPage> {
  final List<Map<String, dynamic>> agents = [
    {
      'name': 'موظف خدمة العملاء',
      'role': 'الرد على الاستفسارات',
      'tone': 'ودود',
      'icon': Icons.support_agent_rounded,
      'color': appGreen,
      'enabled': true,
      'description': 'يجيب عن أسئلة العملاء ويساعدهم في الوصول للمعلومة.',
    },
    {
      'name': 'موظف المبيعات',
      'role': 'مساعدة العملاء على الشراء',
      'tone': 'احترافي',
      'icon': Icons.shopping_bag_outlined,
      'color': appGold,
      'enabled': true,
      'description': 'يساعد العميل على فهم المنتجات والخدمات واتخاذ القرار.',
    },
    {
      'name': 'موظف المواعيد',
      'role': 'تنظيم الاستفسارات عن المواعيد',
      'tone': 'رسمي',
      'icon': Icons.calendar_month_rounded,
      'color': Color(0xFF6CA8FF),
      'enabled': false,
      'description': 'يتعامل مع أسئلة المواعيد والحجوزات بصورة تجريبية.',
    },
    {
      'name': 'موظف المتابعة',
      'role': 'متابعة العملاء',
      'tone': 'ودود',
      'icon': Icons.person_search_rounded,
      'color': appPink,
      'enabled': false,
      'description': 'يساعد على متابعة استفسارات العملاء السابقة.',
    },
  ];

  void openAgentSettings(Map<String, dynamic> agent) {
    final roleController = TextEditingController(
      text: agent['role'] as String,
    );

    String selectedTone = agent['tone'] as String;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: appCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                22,
                20,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: appBorder,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'إعدادات الموظف',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      agent['name'] as String,
                      style: const TextStyle(
                        color: appMuted,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'دور الموظف',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 9),
                    TextField(
                      controller: roleController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: appField,
                        hintText: 'اكتب دور الموظف',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'نبرة الرد',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['ودود', 'احترافي', 'رسمي', 'عراقي'].map(
                        (tone) {
                          return ChoiceChip(
                            label: Text(tone),
                            selected: selectedTone == tone,
                            onSelected: (_) {
                              setSheetState(() => selectedTone = tone);
                            },
                            selectedColor: appGreen.withOpacity(0.18),
                            side: BorderSide(
                              color: selectedTone == tone
                                  ? appGreen
                                  : appBorder,
                            ),
                            showCheckmark: false,
                          );
                        },
                      ).toList(),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          setState(() {
                            agent['role'] = roleController.text.trim().isEmpty
                                ? 'مساعد ذكي'
                                : roleController.text.trim();
                            agent['tone'] = selectedTone;
                          });
                          Navigator.pop(sheetContext);
                          showMessage(
                            this.context,
                            'حُفظت الإعدادات محلياً في هذه الجلسة',
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: appGreen,
                          foregroundColor: appBg,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text('حفظ الإعدادات'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(roleController.dispose);
  }

  @override
  Widget build(BuildContext context) {
    final activeCount =
        agents.where((agent) => agent['enabled'] == true).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const Text(
          'موظفو الذكاء الاصطناعي',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'جهّز مساعدين افتراضيين لمهام عملك المختلفة',
          style: TextStyle(
            color: appMuted,
            fontSize: 13,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF124532), appCard],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: appBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: appGreen.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.smart_toy_rounded,
                  color: appGreen,
                  size: 29,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'فريقك الافتراضي',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$activeCount من ${agents.length} موظفين مفعّلون محلياً',
                      style: const TextStyle(
                        color: appMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.auto_awesome_rounded,
                color: appGold,
                size: 25,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle(
          title: 'فريق العمل',
          subtitle: 'اختر الموظف الذي تريد تخصيصه',
        ),
        const SizedBox(height: 14),
        ...agents.map((agent) {
          final color = agent['color'] as Color;
          final enabled = agent['enabled'] as bool;

          return Container(
            margin: const EdgeInsets.only(bottom: 13),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: appCard,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: enabled ? color.withOpacity(0.35) : appBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.13),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        agent['icon'] as IconData,
                        color: color,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            agent['name'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            enabled ? 'مفعّل محلياً' : 'متوقف محلياً',
                            style: TextStyle(
                              color: enabled ? appGreen : appMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: enabled,
                      activeThumbColor: appGreen,
                      onChanged: (value) {
                        setState(() => agent['enabled'] = value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                Text(
                  agent['description'] as String,
                  style: const TextStyle(
                    color: appMuted,
                    fontSize: 12,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 13),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    _AgentTag(
                      icon: Icons.assignment_outlined,
                      label: agent['role'] as String,
                    ),
                    _AgentTag(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: 'النبرة: ${agent['tone']}',
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => openAgentSettings(agent),
                    icon: const Icon(Icons.tune_rounded, size: 18),
                    label: const Text('تخصيص الموظف'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: appGreen,
                      side: const BorderSide(color: appBorder),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 6),
        const Text(
          'التشغيل والإعدادات في هذه النسخة تجريبية، ولا تؤثر في الموظفين المتصلين بالخادم.',
          style: TextStyle(
            color: appMuted,
            fontSize: 11,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class _AgentTag extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AgentTag({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: appField,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: appMuted, size: 15),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: appMuted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class ChannelsPage extends StatefulWidget {
  const ChannelsPage({super.key});

  @override
  State<ChannelsPage> createState() => _ChannelsPageState();
}

class _ChannelsPageState extends State<ChannelsPage> {
  final List<Map<String, dynamic>> channels = [
    {
      'name': 'Instagram',
      'description': 'رسائل حساب Instagram للأعمال',
      'icon': Icons.camera_alt_rounded,
      'color': appPink,
      'connected': true,
      'account': '@your_business',
    },
    {
      'name': 'WhatsApp',
      'description': 'تواصل مباشر مع عملائك',
      'icon': Icons.chat_rounded,
      'color': const Color(0xFF25D366),
      'connected': false,
      'account': 'لم يُربط حساب',
    },
    {
      'name': 'Facebook',
      'description': 'رسائل صفحة Facebook',
      'icon': Icons.facebook_rounded,
      'color': const Color(0xFF6CA8FF),
      'connected': false,
      'account': 'لم تُربط صفحة',
    },
  ];

  void showChannelDetails(Map<String, dynamic> channel) {
    final connected = channel['connected'] as bool;
    final name = channel['name'] as String;
    final color = channel['color'] as Color;

    showModalBottomSheet(
      context: context,
      backgroundColor: appCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 25, 22, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: appBorder,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Icon(
                      channel['icon'] as IconData,
                      color: color,
                      size: 29,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          connected ? 'حالة العرض: متصل' : 'حالة العرض: غير متصل',
                          style: TextStyle(
                            color: connected ? appGreen : appMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Text(
                'معلومات القناة',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                channel['description'] as String,
                style: const TextStyle(
                  color: appMuted,
                  fontSize: 13,
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: appField,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_circle_outlined,
                      color: appMuted,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        channel['account'] as String,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: appGold.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: appGold.withOpacity(0.2),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: appGold,
                      size: 20,
                    ),
                    SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        'هذه شاشة تجريبية. الربط الحقيقي يتطلب إعداد تسجيل الدخول والصلاحيات في الخادم.',
                        style: TextStyle(
                          color: appMuted,
                          fontSize: 11,
                          height: 1.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    showMessage(
                      this.context,
                      connected
                          ? 'القناة معروضة كمتصلة تجريبياً'
                          : 'لم يُنفّذ ربط حقيقي؛ ستضاف عملية OAuth لاحقاً',
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: appGreen,
                    foregroundColor: appBg,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    connected ? 'عرض حالة القناة' : 'إعداد الربط',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectedCount = channels
        .where((channel) => channel['connected'] == true)
        .length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const Text(
          'قنوات التواصل',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'اجمع قنوات عملك في مساحة واحدة',
          style: TextStyle(
            color: appMuted,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(19),
          decoration: BoxDecoration(
            color: appCard,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: appBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: appGreen.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.hub_rounded,
                  color: appGreen,
                  size: 27,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'قنوات مساحة العمل',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$connectedCount من ${channels.length} قنوات معروضة كمتصلة',
                      style: const TextStyle(
                        color: appMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        const SectionTitle(
          title: 'القنوات المتاحة',
          subtitle: 'افتح القناة لمعرفة تفاصيل إعدادها',
        ),
        const SizedBox(height: 14),
        ...channels.map((channel) {
          final color = channel['color'] as Color;
          final connected = channel['connected'] as bool;

          return InkWell(
            onTap: () => showChannelDetails(channel),
            borderRadius: BorderRadius.circular(21),
            child: Container(
              margin: const EdgeInsets.only(bottom: 13),
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: appCard,
                borderRadius: BorderRadius.circular(21),
                border: Border.all(
                  color: connected
                      ? color.withOpacity(0.35)
                      : appBorder,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 53,
                        height: 53,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.13),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          channel['icon'] as IconData,
                          color: color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              channel['name'] as String,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              channel['description'] as String,
                              style: const TextStyle(
                                color: appMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_left_rounded,
                        color: appMuted,
                      ),
                    ],
                  ),
                  const SizedBox(height: 17),
                  const Divider(color: appBorder, height: 1),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: connected ? appGreen : appMuted,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        connected ? 'متصل تجريبياً' : 'غير مربوط',
                        style: TextStyle(
                          color: connected ? appGreen : appMuted,
                          fontSize: 11,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        connected ? 'عرض التفاصيل' : 'إعداد القناة',
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 6),
        const Text(
          'حالات الاتصال المعروضة تجريبية ولا تؤكد وجود اتصال فعلي بحسابات Meta.',
          style: TextStyle(
            color: appMuted,
            fontSize: 11,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  void openFeature(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FeaturePage(
          title: title,
          description: description,
          icon: icon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const Text(
          'المزيد',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'إدارة مساحة عملك وتفضيلاتك',
          style: TextStyle(
            color: appMuted,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF124532), appCard],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(23),
            border: Border.all(color: appBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 53,
                height: 53,
                decoration: BoxDecoration(
                  color: appGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  color: appGreen,
                  size: 28,
                ),
              ),
              const SizedBox(width: 13),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مشروعي',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'مساحة العمل التجريبية',
                      style: TextStyle(
                        color: appMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.verified_user_outlined,
                color: appGreen,
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        const SectionTitle(
          title: 'إدارة العمل',
          subtitle: 'أدوات تنظيم العملاء والمعلومات',
        ),
        const SizedBox(height: 12),
        _MoreTile(
          icon: Icons.people_alt_outlined,
          color: const Color(0xFF6CA8FF),
          title: 'العملاء',
          subtitle: 'عرض وإدارة بيانات العملاء',
          onTap: () => openFeature(
            context,
            'العملاء',
            'ستعرض هذه الصفحة قائمة العملاء وبيانات التواصل وسجل المحادثات بعد ربط قاعدة البيانات.',
            Icons.people_alt_rounded,
          ),
        ),
        _MoreTile(
          icon: Icons.shopping_bag_outlined,
          color: appGreen,
          title: 'الطلبات والمواعيد',
          subtitle: 'متابعة الطلبات والحجوزات',
          onTap: () => openFeature(
            context,
            'الطلبات والمواعيد',
            'ستتيح هذه الصفحة متابعة الطلبات والحجوزات وحالاتها عند إعداد التكاملات المطلوبة.',
            Icons.calendar_month_rounded,
          ),
        ),
        _MoreTile(
          icon: Icons.library_books_outlined,
          color: appGold,
          title: 'قاعدة المعرفة',
          subtitle: 'المعلومات التي يعتمد عليها الموظف الذكي',
          onTap: () => openFeature(
            context,
            'قاعدة المعرفة',
            'ستتمكن هنا من إضافة معلومات مشروعك وأسئلته الشائعة ليستخدمها المساعد في الردود.',
            Icons.library_books_rounded,
          ),
        ),
        _MoreTile(
          icon: Icons.auto_awesome_outlined,
          color: appPink,
          title: 'القوالب والأتمتة',
          subtitle: 'تنظيم الردود وسير العمل',
          onTap: () => openFeature(
            context,
            'القوالب والأتمتة',
            'ستضاف أدوات تنظيم الردود والتدفقات الآلية بعد تحديد آلية تنفيذها وربطها بالخادم.',
            Icons.auto_awesome_rounded,
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle(
          title: 'الحساب والتطبيق',
          subtitle: 'إعدادات مساحة العمل',
        ),
        const SizedBox(height: 12),
        _MoreTile(
          icon: Icons.workspace_premium_outlined,
          color: appGold,
          title: 'الاشتراك والاستخدام',
          subtitle: 'الخطة والاستهلاك والرصيد',
          onTap: () => openFeature(
            context,
            'الاشتراك والاستخدام',
            'ستعرض هذه الصفحة الخطة والرصيد والاستهلاك الفعلي بعد ربط بيانات الاشتراك.',
            Icons.workspace_premium_rounded,
          ),
        ),
        _MoreTile(
          icon: Icons.settings_outlined,
          color: appMuted,
          title: 'الإعدادات',
          subtitle: 'تفضيلات التطبيق ومساحة العمل',
          onTap: () => openFeature(
            context,
            'الإعدادات',
            'ستضاف هنا إعدادات الحساب واللغة والإشعارات والتفضيلات العامة.',
            Icons.settings_rounded,
          ),
        ),
        _MoreTile(
          icon: Icons.help_outline_rounded,
          color: const Color(0xFF6CA8FF),
          title: 'المساعدة والدعم',
          subtitle: 'معلومات عن التطبيق والمساعدة',
          onTap: () => openFeature(
            context,
            'المساعدة والدعم',
            'إدارة سوشيال منصة لإدارة محادثات العملاء ومساعدة فرق العمل باستخدام الذكاء الاصطناعي.',
            Icons.help_rounded,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: appField,
            borderRadius: BorderRadius.circular(17),
          ),
          child: const Column(
            children: [
              Icon(
                Icons.hub_rounded,
                size: 30,
                color: appGreen,
              ),
              SizedBox(height: 9),
              Text(
                'إدارة سوشيال',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'نسخة واجهة تجريبية',
                style: TextStyle(
                  color: appMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MoreTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MoreTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: appCard,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: appBorder),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 5,
        ),
        leading: Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: color, size: 23),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: appMuted,
              fontSize: 11,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_left_rounded,
          color: appMuted,
        ),
      ),
    );
  }
}

class FeaturePage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const FeaturePage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 28),
            Center(
              child: Container(
                width: 94,
                height: 94,
                decoration: BoxDecoration(
                  color: appGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(29),
                  border: Border.all(color: appBorder),
                ),
                child: Icon(
                  icon,
                  color: appGreen,
                  size: 45,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: appMuted,
                fontSize: 14,
                height: 1.9,
              ),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: appCard,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: appBorder),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.construction_rounded,
                    color: appGold,
                  ),
                  SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      'هذه واجهة أولية. هذه الميزة تحتاج إلى تنفيذ وظيفتها وربطها بالخادم قبل استخدامها فعلياً.',
                      style: TextStyle(
                        color: appMuted,
                        fontSize: 12,
                        height: 1.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('العودة'),
              style: OutlinedButton.styleFrom(
                foregroundColor: appGreen,
                side: const BorderSide(color: appBorder),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
