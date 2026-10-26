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
        fontFamily: 'Roboto',
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
              icon: Icon(Icons.grid_view_rounded),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.forum_outlined),
              selectedIcon: Icon(Icons.forum_rounded),
              label: 'المحادثات',
            ),
            NavigationDestination(
              icon: Icon(Icons.smart_toy_outlined),
              selectedIcon: Icon(Icons.smart_toy_rounded),
              label: 'الموظفون',
            ),
            NavigationDestination(
              icon: Icon(Icons.hub_outlined),
              selectedIcon: Icon(Icons.hub_rounded),
              label: 'القنوات',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_rounded),
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF124532),
                Color(0xFF0B241C),
                Color(0xFF091D17),
              ],
            ),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: appBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: appGreen.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: appGreen,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'مساحة العمل',
                          style: TextStyle(
                            color: appGreen,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: appGold,
                    size: 27,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'خلّ الذكاء الاصطناعي\\nيدير محادثاتك',
                style: TextStyle(
                  fontSize: 26,
                  height: 1.45,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'ردود أسرع، متابعة للعملاء، وإدارة قنواتك من مكان واحد.',
                style: TextStyle(
                  color: appMuted,
                  fontSize: 13,
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: () {
                  showMessage(
                    context,
                    'ستتوفر إعدادات الموظف عند ربط النظام',
                  );
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text('إعداد موظف ذكي'),
                style: FilledButton.styleFrom(
                  backgroundColor: appGreen,
                  foregroundColor: appBg,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const SectionTitle(
          title: 'نظرة عامة',
          subtitle: 'ملخص نشاط مساحة عملك',
        ),
        const SizedBox(height: 14),
        const Row(
          children: [
            Expanded(
              child: MetricCard(
                title: 'المحادثات',
                value: '128',
                detail: '+12 هذا الأسبوع',
                icon: Icons.forum_rounded,
                color: appGreen,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                title: 'العملاء',
                value: '84',
                detail: 'بيانات تجريبية',
                icon: Icons.people_alt_rounded,
                color: Color(0xFF6CA8FF),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(
              child: MetricCard(
                title: 'الموظفون',
                value: '3',
                detail: 'موظفون تجريبيون',
                icon: Icons.smart_toy_rounded,
                color: appGold,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                title: 'القنوات',
                value: '2',
                detail: 'حالة تجريبية',
                icon: Icons.hub_rounded,
                color: appPink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        const SectionTitle(
          title: 'الوصول السريع',
          subtitle: 'الأدوات التي تحتاجها يومياً',
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: ShortcutCard(
                title: 'المحادثات',
                subtitle: 'تابع رسائل العملاء',
                icon: Icons.chat_bubble_outline_rounded,
                color: appGreen,
                onTap: () => showMessage(
                  context,
                  'افتح تبويب المحادثات من الشريط السفلي',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ShortcutCard(
                title: 'الموظفون',
                subtitle: 'إدارة المساعدين',
                icon: Icons.psychology_alt_rounded,
                color: appGold,
                onTap: () => showMessage(
                  context,
                  'افتح تبويب الموظفون من الشريط السفلي',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        const SectionTitle(
          title: 'آخر النشاطات',
          subtitle: 'أمثلة توضيحية داخل التطبيق',
        ),
        const SizedBox(height: 12),
        const ActivityRow(
          icon: Icons.mark_chat_read_rounded,
          color: appGreen,
          title: 'محادثة جديدة',
          subtitle: 'وصل استفسار من عميل تجريبي',
          time: 'قبل 5 دقائق',
        ),
        const ActivityRow(
          icon: Icons.smart_toy_rounded,
          color: appGold,
          title: 'الموظف الذكي جاهز',
          subtitle: 'موظف خدمة العملاء التجريبي',
          time: 'قبل 20 دقيقة',
        ),
        const ActivityRow(
          icon: Icons.link_rounded,
          color: Color(0xFF6CA8FF),
          title: 'إعداد القنوات',
          subtitle: 'يمكنك مراجعة حالة القنوات',
          time: 'اليوم',
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: appField,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: appMuted,
                size: 20,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'الأرقام والنشاطات هنا تجريبية للعرض فقط، وليست بيانات حقيقية من حسابك.',
                  style: TextStyle(
                    color: appMuted,
                    fontSize: 12,
                    height: 1.7,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: appCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: appBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.13),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 16),
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
