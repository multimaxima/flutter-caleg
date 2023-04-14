import 'dart:convert';

import 'package:caleg/page/informasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:caleg/page/beranda.dart';
import 'package:caleg/page/chat.dart';
import 'package:caleg/page/kegiatan.dart';
import 'package:caleg/page/notifikasi.dart';
import 'package:caleg/page/profil.dart';
import 'package:caleg/service/service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedNavbar = 0;
  String? nama;
  String key = getKey();
  final _formKey = GlobalKey<FormState>();

  final _cari = TextEditingController();

  static const List<Widget> _widgetOptions = <Widget>[
    BerandaPage(),
    ChatPage(),
    NotifikasiPage(),
    KegiatanPage(),
    ProfilPage(),
  ];

  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }

  Future<void> getUser() async {
    var result =
        await http.get(Uri.parse("${ApiStatus.baseUrl}/api/get-nama?key=$key"));

    if (result.statusCode == 200) {
      var data = await json.decode(result.body);

      if (mounted) {
        setState(() {
          nama = data['nama'] ?? "";

          hapusLoader();
        });
      }
    } else {
      hapusLoader();
      errorPesan("Terjadi kegagalan koneksi, silahkan ulangi kembali.");
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverLayoutBuilder(
              builder: (BuildContext context, constraints) {
                final scrolled = constraints.scrollOffset > 0;

                return SliverAppBar(
                  pinned: true,
                  snap: true,
                  floating: true,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  scrolledUnderElevation: 2,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
                    title: Text(
                      nama != null ? "$nama" : "",
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                    background: scrolled
                        ? null
                        : Image.asset('assets/images/back_atas.jpg',
                            fit: BoxFit.cover),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 150,
                                child: Form(
                                  key: _formKey,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          TextFormField(
                                            controller: _cari,
                                            style:
                                                const TextStyle(fontSize: 14),
                                            textCapitalization:
                                                TextCapitalization.words,
                                            decoration: const InputDecoration(
                                              labelText: "Cari data...",
                                              labelStyle:
                                                  TextStyle(fontSize: 14),
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                            ),
                                            validator: (value) {
                                              if (value == "") {
                                                return 'Nama wajib diisi';
                                              }
                                              return null;
                                            },
                                          ),
                                          IntrinsicHeight(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton.icon(
                                                    label: const Text('CARI'),
                                                    icon: const Icon(
                                                        Icons.search),
                                                    onPressed: () {},
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: ElevatedButton.icon(
                                                    label: const Text('BATAL'),
                                                    icon:
                                                        const Icon(Icons.close),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Icon(
                          Icons.search,
                          size: 24.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: GestureDetector(
                        onTap: () {
                          _changeSelectedNavBar(1);
                        },
                        child: const Icon(
                          Icons.chat,
                          size: 24.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: GestureDetector(
                        onTap: () {
                          _changeSelectedNavBar(2);
                        },
                        child: const Icon(
                          Icons.notifications,
                          size: 24.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const InformasiPage());
                        },
                        child: const Icon(
                          Icons.info,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ];
        },
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/back_bawah.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(child: _widgetOptions.elementAt(_selectedNavbar)),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_sharp),
            label: 'Kegiatan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedNavbar,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _changeSelectedNavBar,
      ),
    );
  }
}
