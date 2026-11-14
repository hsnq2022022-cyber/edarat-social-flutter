import 'package:flutter/material.dart';

/// Supported UI languages. English is the default and primary language;
/// Arabic is the second supported language. The map-based design makes it
/// straightforward to register a third language later without touching
/// call sites — do not invent one until the product team decides.
enum AppLanguage {
  en('en', 'English', TextDirection.ltr),
  ar('ar', 'العربية', TextDirection.rtl);

  const AppLanguage(this.code, this.nativeName, this.direction);

  final String code;
  final String nativeName;
  final TextDirection direction;

  Locale get locale => Locale(code);

  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
      (l) => l.code == code,
      orElse: () => AppLanguage.en,
    );
  }
}

/// Simple lookup table used by [MahalliLocalizations].
class Messages {
  static final Map<String, Map<String, String>> _table = {
    'en': _en,
    'ar': _ar,
  };

  static String of(AppLanguage language, String key,
      [Map<String, String>? params]) {
    var text = _table[language.code]?[key] ?? _table['en']![key] ?? key;
    params?.forEach((k, v) => text = text.replaceAll('{$k}', v));
    return text;
  }
}

const Map<String, String> _en = {
  // App
  'app.name': 'MAHALLI',
  'app.tagline': 'Loyalty that loves your neighborhood',

  // Navigation
  'nav.home': 'Home',
  'nav.discover': 'Discover',
  'nav.cards': 'My Cards',
  'nav.rewards': 'Rewards',
  'nav.profile': 'Profile',

  // Home
  'home.greeting': 'Hello, {name}',
  'home.subtitle': 'Here is your loyalty overview',
  'home.myCards': 'My loyalty cards',
  'home.recentlyUsed': 'Recently accessed',
  'home.availableRewards': 'Available rewards',
  'home.discoverPrograms': 'Discover more programs',
  'home.noCardsTitle': 'No loyalty cards yet',
  'home.noCardsBody':
      'Join a local business program to start collecting stamps.',
  'home.viewAll': 'View all',
  'home.demoBanner': 'Demo mode — sample data, not real records',

  // Discover
  'discover.title': 'Discover businesses',
  'discover.searchHint': 'Search by business name',
  'discover.emptyTitle': 'No businesses found',
  'discover.emptyBody': 'Try a different search term.',
  'discover.programSummary': '{stamps} stamps → {reward}',
  'discover.join': 'Join program',
  'discover.joined': 'You are in this program',
  'discover.joining': 'Joining…',
  'discover.joinFailed': 'Could not join the program. Please try again.',
  'discover.notJoinable': 'This program is not open for joining right now.',

  // Business details
  'business.category': 'Category',
  'business.about': 'About',
  'business.program': 'Loyalty program',
  'business.howToEarn': 'How to earn stamps',
  'business.reward': 'Reward',
  'business.rewardNote': 'Reward details are configured by the business.',
  'business.contact': 'Contact',
  'business.address': 'Address',
  'business.phone': 'Phone',

  // Loyalty card
  'card.stampsProgress': '{earned} of {required} stamps',
  'card.remaining': '{count} more to unlock your reward',
  'card.ready': 'Reward unlocked — redeem it at the business',
  'card.status.active': 'Active',
  'card.status.completed': 'Completed',
  'card.status.expired': 'Expired',
  'card.status.suspended': 'Suspended',
  'card.rewardLabel': 'Reward',
  'card.addToWallet': 'Add to Google Wallet',
  'card.walletAdding': 'Opening Google Wallet…',
  'card.walletSuccess': 'Card added to Google Wallet',
  'card.walletUnavailable':
      'Google Wallet pass is not available yet for this card. The backend must generate a signed Save URL first.',
  'card.walletFailed': 'Could not add the card to Google Wallet.',
  'card.openFailed': 'No app available to open the Wallet link on this device.',
  'card.details': 'Card details',

  // Rewards
  'rewards.title': 'Rewards',
  'rewards.available': 'Available',
  'rewards.redeemed': 'Redeemed',
  'rewards.emptyAvailable': 'No available rewards yet',
  'rewards.emptyRedeemed': 'No redeemed rewards yet',
  'rewards.redeemInfo': 'Redemption info',
  'rewards.earnedAt': 'Earned {date}',
  'rewards.redeemedAt': 'Redeemed {date}',
  'rewards.note':
      'Rewards can only be redeemed at the business. This app never redeems rewards on its own.',

  // Activity
  'activity.title': 'Activity history',
  'activity.empty': 'No activity recorded yet',
  'activity.stampEarned': '+{amount} stamp(s)',
  'activity.rewardRedeemed': 'Reward redeemed',
  'activity.programJoined': 'Joined program',
  'activity.filter.all': 'All',
  'activity.filter.stamps': 'Stamps',
  'activity.filter.redemptions': 'Redemptions',

  // Profile & settings
  'profile.title': 'Profile & settings',
  'profile.language': 'Language',
  'profile.account': 'Account',
  'profile.email': 'Email',
  'profile.phone': 'Phone',
  'profile.signOut': 'Sign out',
  'profile.signOutConfirm': 'Are you sure you want to sign out?',
  'profile.demoMode': 'Demo mode',
  'profile.demoModeOn': 'You are browsing with demo fixtures, not live data.',
  'profile.version': 'Version',
  'profile.editName': 'Display name',
  'profile.save': 'Save changes',
  'profile.saved': 'Profile updated locally',

  // Auth
  'auth.welcome': 'Welcome to MAHALLI',
  'auth.subtitle': 'Collect stamps. Earn rewards. Support local.',
  'auth.continueAsGuest': 'Continue as guest (demo mode)',
  'auth.signOutTitle': 'Signed out',
  'auth.signedOutBody': 'You have been signed out of this session.',

  // Common
  'common.retry': 'Retry',
  'common.loading': 'Loading…',
  'common.errorTitle': 'Something went wrong',
  'common.body': 'Body',
  'common.cancel': 'Cancel',
  'common.confirm': 'Confirm',
  'common.close': 'Close',
};

const Map<String, String> _ar = {
  'app.name': 'محلي',
  'app.tagline': 'ولاء يحبّ حيّك',

  'nav.home': 'الرئيسية',
  'nav.discover': 'استكشف',
  'nav.cards': 'بطاقاتي',
  'nav.rewards': 'المكافآت',
  'nav.profile': 'حسابي',

  'home.greeting': 'مرحبًا، {name}',
  'home.subtitle': 'إليك ملخص برامج الولاء الخاصة بك',
  'home.myCards': 'بطاقات الولاء',
  'home.recentlyUsed': 'تم الوصول مؤخرًا',
  'home.availableRewards': 'المكافآت المتاحة',
  'home.discoverPrograms': 'اكتشف المزيد من البرامج',
  'home.noCardsTitle': 'لا توجد بطاقات ولاء بعد',
  'home.noCardsBody': 'انضم إلى برنامج لأحد المتاجر المحلية لتبدأ بجمع الأختام.',
  'home.viewAll': 'عرض الكل',
  'home.demoBanner': 'وضع تجريبي — بيانات نموذجية وليست سجلات حقيقية',

  'discover.title': 'استكشف المتاجر',
  'discover.searchHint': 'ابحث باسم المتجر',
  'discover.emptyTitle': 'لم يتم العثور على متاجر',
  'discover.emptyBody': 'جرّب كلمة بحث مختلفة.',
  'discover.programSummary': '{stamps} أختام ← {reward}',
  'discover.join': 'انضم للبرنامج',
  'discover.joined': 'أنت مشترك في هذا البرنامج',
  'discover.joining': 'جارٍ الانضمام…',
  'discover.joinFailed': 'تعذّر الانضمام إلى البرنامج. حاول مرة أخرى.',
  'discover.notJoinable': 'هذا البرنامج غير متاح للانضمام حاليًا.',

  'business.category': 'الفئة',
  'business.about': 'نبذة',
  'business.program': 'برنامج الولاء',
  'business.howToEarn': 'كيف تكسب الأختام',
  'business.reward': 'المكافأة',
  'business.rewardNote': 'تفاصيل المكافأة يحددها المتجر.',
  'business.contact': 'التواصل',
  'business.address': 'العنوان',
  'business.phone': 'الهاتف',

  'card.stampsProgress': '{earned} من {required} أختام',
  'card.remaining': 'تحتاج {count} إضافية لفتح مكافأتك',
  'card.ready': 'تم فتح المكافأة — استبدلها لدى المتجر',
  'card.status.active': 'نشطة',
  'card.status.completed': 'مكتملة',
  'card.status.expired': 'منتهية',
  'card.status.suspended': 'موقوفة',
  'card.rewardLabel': 'المكافأة',
  'card.addToWallet': 'الإضافة إلى Google Wallet',
  'card.walletAdding': 'جارٍ فتح Google Wallet…',
  'card.walletSuccess': 'تمت إضافة البطاقة إلى Google Wallet',
  'card.walletUnavailable':
      'بطاقة Wallet غير متاحة لهذه البطاقة بعد. يجب أن يقوم الخادم بإنشاء رابط حفظ موقّع أولًا.',
  'card.walletFailed': 'تعذّرت إضافة البطاقة إلى Google Wallet.',
  'card.openFailed': 'لا يوجد تطبيق على هذا الجهاز لفتح رابط Wallet.',
  'card.details': 'تفاصيل البطاقة',

  'rewards.title': 'المكافآت',
  'rewards.available': 'متاحة',
  'rewards.redeemed': 'مستبدلة',
  'rewards.emptyAvailable': 'لا توجد مكافآت متاحة بعد',
  'rewards.emptyRedeemed': 'لا توجد مكافآت مستبدلة بعد',
  'rewards.redeemInfo': 'معلومات الاستبدال',
  'rewards.earnedAt': 'اكسبت في {date}',
  'rewards.redeemedAt': 'استُبدلت في {date}',
  'rewards.note':
      'يمكن استبدال المكافآت لدى المتجر فقط. هذا التطبيق لا يستبدل أي مكافأة بنفسه.',

  'activity.title': 'سجل النشاط',
  'activity.empty': 'لا يوجد نشاط مسجل بعد',
  'activity.stampEarned': '+{amount} أختام',
  'activity.rewardRedeemed': 'تم استبدال مكافأة',
  'activity.programJoined': 'انضم إلى برنامج',
  'activity.filter.all': 'الكل',
  'activity.filter.stamps': 'الأختام',
  'activity.filter.redemptions': 'الاستبدالات',

  'profile.title': 'الحساب والإعدادات',
  'profile.language': 'اللغة',
  'profile.account': 'الحساب',
  'profile.email': 'البريد الإلكتروني',
  'profile.phone': 'الهاتف',
  'profile.signOut': 'تسجيل الخروج',
  'profile.signOutConfirm': 'هل أنت متأكد من تسجيل الخروج؟',
  'profile.demoMode': 'الوضع التجريبي',
  'profile.demoModeOn': 'تتصفح بيانات نموذجية وليست بيانات حية.',
  'profile.version': 'الإصدار',
  'profile.editName': 'الاسم المعروض',
  'profile.save': 'حفظ التغييرات',
  'profile.saved': 'تم تحديث الملف محليًا',

  'auth.welcome': 'مرحبًا بك في محلي',
  'auth.subtitle': 'اجمع الأختام. اكسب المكافآت. ادعم المتاجر المحلية.',
  'auth.continueAsGuest': 'المتابعة كضيف (وضع تجريبي)',
  'auth.signOutTitle': 'تم تسجيل الخروج',
  'auth.signedOutBody': 'تم تسجيل خروجك من هذه الجلسة.',

  'common.retry': 'إعادة المحاولة',
  'common.loading': 'جارٍ التحميل…',
  'common.errorTitle': 'حدث خطأ ما',
  'common.body': 'النص',
  'common.cancel': 'إلغاء',
  'common.confirm': 'تأكيد',
  'common.close': 'إغلاق',
};
