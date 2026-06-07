import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:siptatif_app/dialogs/preview_profile_pict.dart';

import 'package:siptatif_app/screens/beranda_screen.dart';
import 'package:siptatif_app/screens/dosen_screen.dart';
import 'package:siptatif_app/screens/logbook_mahasiswa_screen.dart';
import 'package:siptatif_app/screens/pendaftaran_sidang_screen.dart';
import 'package:siptatif_app/screens/penjadwalan_sidang_screen.dart';
import 'package:siptatif_app/screens/penilaian_sidang_screen.dart';
import 'package:siptatif_app/screens/mahasiswa_screen.dart';
import 'package:siptatif_app/screens/penguji_screen.dart';
import 'package:siptatif_app/screens/pembimbing_screen.dart';
import 'package:siptatif_app/screens/pengaturan_screen.dart';
import 'package:siptatif_app/screens/chat_list_screen.dart';
import 'package:siptatif_app/screens/dashboard_statistik_screen.dart';

import 'package:provider/provider.dart';
import 'package:siptatif_app/providers/auth_provider.dart';
import 'package:siptatif_app/providers/notifikasi_provider.dart';
import 'package:siptatif_app/providers/theme_provider.dart';
import 'package:siptatif_app/datas/models/user.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> get _widgetBody => [
    HomeScreen(onNavigate: _onItemTapped),
    const MahasiswaScreen(),
    const PengujiScreen(),
    const PembimbingScreen(),
    const DashboardStatistikScreen(),
  ];

  List<Widget> get _dosenWidgetBody => [
    const DosenScreen(),
    const ChatListScreen(),
    const PengaturanScreen(),
  ];

  List<Widget> get _mahasiswaWidgetBody => [
    const LogbookMahasiswaScreen(),
    const PendaftaranSidangScreen(),
    const ChatListScreen(),
    const PengaturanScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final isDosen = user?.roles == 'Dosen';
    final isMahasiswa = user?.roles == 'Mahasiswa';
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    Widget bodyWidget;
    if (isDosen) {
      bodyWidget = _dosenWidgetBody[_selectedIndex.clamp(0, _dosenWidgetBody.length - 1)];
    } else if (isMahasiswa) {
      bodyWidget = _mahasiswaWidgetBody[_selectedIndex.clamp(0, _mahasiswaWidgetBody.length - 1)];
    } else {
      bodyWidget = _widgetBody[_selectedIndex.clamp(0, _widgetBody.length - 1)];
    }

    Widget bottomNavWidget;
    if (isDosen) {
      bottomNavWidget = _bottomNavDosen();
    } else if (isMahasiswa) {
      bottomNavWidget = _bottomNavMahasiswa();
    } else {
      bottomNavWidget = _bottomNavigationBar();
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark 
            ? [const Color(0xFF231557), const Color(0xFF44107A), const Color(0xFFFF1361)]
            : [const Color(0xFF8EC5FC), const Color(0xFFE0C3FC)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        appBar: _appBar(user),
        drawer: _drawer(user),
        endDrawer: _endDrawer(),
        body: bodyWidget,
        bottomNavigationBar: bottomNavWidget,
      ),
    );
  }

  /////////////////////////////////////////////////////////////////////////////
  /// Bottom Navigation Bar Assets
  ////////////////////////////////////////////////////////////////////////////



  int _selectedIndex = 0;

  void _onItemTapped(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Container _bottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Theme.of(context).dividerColor, width: 1.0))),
      child: BottomNavigationBar(
        elevation: 30,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          _botBarItem(context: context, icon: "assets/svgs/beranda-icon.svg", label: "Beranda"),
          _botBarItem(context: context, 
              icon: "assets/svgs/mahasiswa-icon.svg", label: "Mahasiswa"),
          _botBarItem(context: context, icon: "assets/svgs/penguji-icon.svg", label: "Penguji"),
          _botBarItem(context: context, 
              icon: "assets/svgs/pembimbing-icon.svg", label: "Pembimbing"),
          _botBarItemIcon(context: context, icon: Icons.pie_chart, label: "Statistik"),
        ],
        useLegacyColorScheme: false,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
        unselectedIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
        ),
        selectedLabelStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontFamily: "Montserrat-SemiBold",
          letterSpacing: -0.9,
        ),
        unselectedLabelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
          fontFamily: "Montserrat-SemiBold",
          letterSpacing: -0.9,
        ),
      ),
    );
  }

  BottomNavigationBarItem _botBarItem(
      {required BuildContext context, required String icon, required String label}) {
    return BottomNavigationBarItem(
        icon: SvgPicture.asset(
          icon,
          width: 33,
          colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), BlendMode.srcIn),
        ),
        activeIcon: Container(
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).brightness == Brightness.dark ? Colors.deepPurple[900] : Colors.purple[50],
          ),
          child: SvgPicture.asset(
            icon,
            width: 33,
            colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
          ),
        ),
        label: label);
  }

  BottomNavigationBarItem _botBarItemIcon(
      {required BuildContext context, required IconData icon, required String label}) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          size: 33,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
        ),
        activeIcon: Container(
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).brightness == Brightness.dark ? Colors.deepPurple[900] : Colors.purple[50],
          ),
          child: Icon(
            icon,
            size: 33,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        label: label);
  }

  Container _bottomNavDosen() {
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Theme.of(context).dividerColor, width: 1.0))),
      child: BottomNavigationBar(
        elevation: 30,
        currentIndex: _selectedIndex.clamp(0, 2),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        useLegacyColorScheme: false,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        unselectedIconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)),
        selectedLabelStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontFamily: "Montserrat-SemiBold",
          letterSpacing: -0.9,
        ),
        unselectedLabelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
          fontFamily: "Montserrat-SemiBold",
          letterSpacing: -0.9,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school_rounded),
            label: 'Mahasiswa Saya',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Pesan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings_rounded),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }

  Container _bottomNavMahasiswa() {
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Theme.of(context).dividerColor, width: 1.0))),
      child: BottomNavigationBar(
        elevation: 30,
        currentIndex: _selectedIndex.clamp(0, 3),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        useLegacyColorScheme: false,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        unselectedIconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)),
        selectedLabelStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontFamily: "Montserrat-SemiBold",
          letterSpacing: -0.9,
        ),
        unselectedLabelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
          fontFamily: "Montserrat-SemiBold",
          letterSpacing: -0.9,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history_edu_outlined),
            activeIcon: Icon(Icons.history_edu_rounded),
            label: 'Logbook',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment_rounded),
            label: 'Tugas Akhir',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Pesan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings_rounded),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }



  /////////////////////////////////////////////////////////////////////////////
  /// Top Navigation Bar Assets
  ////////////////////////////////////////////////////////////////////////////

  AppBar _appBar(User? user) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Row(
        children: [
          Container(
            width: 4.0,
          ),
          IconButton(
            padding: const EdgeInsets.only(top: 1.7),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: SvgPicture.asset(
              'assets/svgs/menu-icon.svg',
              width: 25.0,
              height: 15.0,
            ),
          ),
          Container(
            width: 3.0,
          ),
          Text(
            'SIPTATIF',
            style: TextStyle(
              fontFamily: "Montserrat-Bold",
              fontSize: 24.0,
              letterSpacing: -0.9,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            ),
          )
        ],
      ),

      leadingWidth: 180,

      actions: [
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: themeProvider.isDarkMode ? Colors.yellow : Colors.black87,
              ),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            );
          },
        ),
        Consumer<NotifikasiProvider>(
          builder: (context, notifProvider, child) {
            return IconButton(
              icon: Badge(
                isLabelVisible: notifProvider.unreadCount > 0,
                label: Text(notifProvider.unreadCount.toString()),
                child: Icon(
                  Icons.notifications,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
                notifProvider.markAllAsRead();
              },
            );
          },
        ),
        InkWell(
          onLongPress: () async {
            await showDialog(
                context: context,
                builder: (_) =>
                    PreviewProfilePictDialog(imgFile: user?.profilePict ?? ''));
          },
          onTap: () {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text('Warning: Log-Out Confirmation!'),
                      content: const Text(
                          'Apakah anda yakin ingin log-out dari akun anda?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.red),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(context, "/login");
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.green),
                          ),
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ));
          },
          child: (user != null && user.profilePict.isNotEmpty)
              ? CircleAvatar(
                  backgroundImage: AssetImage(user.profilePict),
                  radius: 20,
                )
              : const CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.person),
                ),
        ),
        // Icon(
        //   Icons.account_circle_rounded,
        //   size: 40,
        //   color: Colors.grey[850],
        // ),

        Container(
          width: 11.0,
        ),
      ],

      shape: const Border(
        bottom: BorderSide(color: Colors.black12, width: 1.0),
      ),

      // backgroundColor: Colors.grey[200],
      // elevation: 1,
    );
  }

  Drawer _drawer(User? user) {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white.withValues(alpha: 0.6)
                : Colors.black.withValues(alpha: 0.6),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: SizedBox(
              height: 205,
              child: DrawerHeader(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            await showDialog(
                                context: context,
                                builder: (_) => PreviewProfilePictDialog(
                                    imgFile: user?.profilePict ?? ''));
                          },
                          child: (user != null && user.profilePict.isNotEmpty)
                              ? CircleAvatar(
                                  backgroundImage: AssetImage(user.profilePict),
                                  radius: 33,
                                )
                              : const CircleAvatar(
                                  radius: 33,
                                  child: Icon(Icons.person, size: 40),
                                ),
                        ),
                        const Spacer(
                          flex: 90,
                        ),
                        IconButton.outlined(
                          onPressed: () {
                            _scaffoldKey.currentState?.closeDrawer();
                          },
                          icon: const Icon(
                              Icons.keyboard_double_arrow_right_rounded,
                              size: 25),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      user?.fullName ?? "",
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5),
                    ),
                    Text(
                      user?.email ?? "",
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.5),
                    ),
                    Container(
                      height: 7,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.pending_actions,
                              size: 20,
                            ),
                            Container(
                              width: 7,
                            ),
                            Text(
                              user?.roles ?? "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (user?.roles == 'Admin') ...[
            ListTile(
              leading: SvgPicture.asset(
                "assets/svgs/beranda-icon.svg",
                width: 25,
              ),
              title: const Text('Beranda'),
              onTap: () => {
                _onItemTapped(0),
                _scaffoldKey.currentState?.closeDrawer(),
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                "assets/svgs/mahasiswa-icon.svg",
                width: 25,
              ),
              title: const Text('Mahasiswa'),
              onTap: () => {
                _onItemTapped(1),
                _scaffoldKey.currentState?.closeDrawer(),
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                "assets/svgs/penguji-icon.svg",
                width: 25,
              ),
              title: const Text('Penguji'),
              onTap: () => {
                _onItemTapped(2),
                _scaffoldKey.currentState?.closeDrawer(),
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                "assets/svgs/pembimbing-icon.svg",
                width: 25,
              ),
              title: const Text('Pembimbing'),
              onTap: () => {
                _onItemTapped(3),
                _scaffoldKey.currentState?.closeDrawer(),
              },
            ),
            ListTile(
              leading: Icon(Icons.edit_calendar_rounded, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87),
              title: Text('Penjadwalan Sidang', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
              onTap: () {
                _scaffoldKey.currentState?.closeDrawer();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PenjadwalanSidangScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.verified_user_rounded, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87),
              title: Text('Manajemen Yudisium', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
              onTap: () {
                _scaffoldKey.currentState?.closeDrawer();
                Navigator.pushNamed(context, "/manajemen-yudisium");
              },
            ),
          ],
          const Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87),
            title: Text('Pengaturan', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
            onTap: () {
              _scaffoldKey.currentState?.closeDrawer();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PengaturanScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87),
            title: Text('Tentang Aplikasi', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
            onTap: () {
              _scaffoldKey.currentState?.closeDrawer();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('SIPTATIF v1.0'),
                  content: const Text('Sistem Informasi Penjadwalan Tugas Akhir Teknik Informatika (SIPTATIF).\n\nDikembangkan Oleh Ahmad Novy Mufasir Untuk Universitas Pamulang.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup'),
                    ),
                  ],
                ),
              );
            },
          ),
          if (user?.roles == 'Dosen') ...[
            ListTile(
              leading: Icon(Icons.grading_rounded, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87),
              title: Text('Penilaian Sidang', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
              onTap: () {
                _scaffoldKey.currentState?.closeDrawer();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PenilaianSidangScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_turned_in_rounded, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87),
              title: Text('Persetujuan Yudisium', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
              onTap: () {
                _scaffoldKey.currentState?.closeDrawer();
                Navigator.pushNamed(context, "/pengesahan-revisi");
              },
            ),
          ],
          if (user?.roles == 'Mahasiswa') ...[
            ListTile(
              leading: Icon(Icons.workspace_premium_rounded, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87),
              title: Text('Yudisium & Kelulusan', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
              onTap: () {
                _scaffoldKey.currentState?.closeDrawer();
                Navigator.pushNamed(context, "/yudisium-mahasiswa");
              },
            ),
          ],
          Builder(builder: (context) {
            return ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () => {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Warning: Log-Out Confirmation!'),
                    content: const Text(
                        'Apakah anda yakin ingin log-out dari akun anda?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.red),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, "/login");
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.green),
                        ),
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              },
            );
          }),
        ],
      ),
    ))));
  }

  Drawer _endDrawer() {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white.withValues(alpha: 0.6)
                : Colors.black.withValues(alpha: 0.6),
            child: SafeArea(
              child: Consumer<NotifikasiProvider>(
                builder: (context, notifProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Notifikasi",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: notifProvider.notifikasiList.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final notif = notifProvider.notifikasiList[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(Icons.notifications_active, color: Colors.blue),
                        ),
                        title: Text(
                          notif.judul,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(notif.pesan),
                            const SizedBox(height: 8),
                            Text(
                              notif.waktu,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        onTap: () {
                          _scaffoldKey.currentState?.closeEndDrawer();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Membuka detail notifikasi: ${notif.judul}')),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
            ),
          ),
        ),
      ),
    );
  }
}
