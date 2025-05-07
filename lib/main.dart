import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _age = 15;
  final TextEditingController _ageController = TextEditingController();
  bool _inputHasError = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _showDialog() {
    setState(() {
      _inputHasError = false;
    });
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return AlertDialog(
              title: const Text('Yoshni kiriting'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    decoration: InputDecoration(
                      hintText: '10 dan 99 gacha son kiriting',
                      errorText: _inputHasError
                          ? 'Xato: Iltimos, 2 xonali son kiriting'
                          : null,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _inputHasError ? Colors.red : Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _inputHasError ? Colors.red : Colors.blue,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Bekor qilish'),
                ),
                TextButton(
                  onPressed: () {
                    int? enteredAge = int.tryParse(_ageController.text);
                    if (enteredAge == null || enteredAge < 10 || enteredAge > 99) {
                      setStateSB(() {
                        _inputHasError = true;
                      });
                    } else {
                      setState(() {
                        _age = enteredAge;
                      });
                      Navigator.of(dialogContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ma’lumot saqlandi'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      _ageController.clear();
                      _inputHasError = false;
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  final List<String> imagePaths = List.generate(15, (index) => 'assets/${index + 1}.jpg');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
         child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CurrencyPage() ));
                  }, icon:Icon(Icons.attach_money) ),
                   Text(
                    'flutter',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                 GestureDetector(
                    onTap: _showDialog,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Lottie.asset('assets/button.json'),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text('HIS AGE', style: TextStyle(color: Colors.grey)),
                    Text('$_age /100',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Text('OVERALL', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 10),
                    const StatRow(icon: Icons.favorite, value: 34, label: 'Energy'),
                    const StatRow(icon: Icons.visibility, value: 24, label: 'Smart'),
                    const StatRow(icon: Icons.flash_on, value: 54, label: 'Speed'),
                  ],
                ),
                const SizedBox(height: 10),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 50,
                      child: Lottie.asset(
                        'assets/circul1.json',
                        width: 120,
                      ),
                    ),
                    Positioned(
                      child: Image.asset(
                        'assets/1.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Old memory',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            CarouselSlider(
              options: CarouselOptions(
                height: 350,
                enlargeCenterPage: true,
                autoPlay: true,
              ),
              items: imagePaths.map((path) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ImagePreviewPage(imagePath: path),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Radius berilgan joy
                    child: Image.asset(
                      path,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class StatRow extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;

  const StatRow({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.red),
          const SizedBox(width: 10),
          Text('$value /100',
              style: const TextStyle(fontSize: 16, color: Colors.black)),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class ImagePreviewPage extends StatelessWidget {
  final String imagePath;

  const ImagePreviewPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Viewer"),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}




class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  List<dynamic> currencies = [];
  String updatedDate = '';

  @override
  void initState() {
    super.initState();
    fetchCurrencies();
  }

  Future<void> fetchCurrencies() async {
    final response = await http.get(
      Uri.parse('https://cbu.uz/uz/arkhiv-kursov-valyut/json/')
    );

    if (response.statusCode == 200) {
      setState(() {
        currencies = jsonDecode(response.body);
        final now = DateTime.now();
        updatedDate =
            "${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}";
      });
    } else {
      throw Exception("Valyutalarni olishda xatolik yuz berdi.");
    }
  }

  Widget currencyTile(Map<String, dynamic> currency) {
    final isPositive = !currency['Diff'].toString().startsWith('-');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(
            currency['CcyNm_UZ'],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "1 ${currency['Ccy']} = ${currency['Rate']} so'm",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            isPositive ? "+${currency['Diff']}" : currency['Diff'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: isPositive ? Colors.green : Colors.red,
            ),
          ),
          const Divider(thickness: 1),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdf7ff),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Valyuta kurslari", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: currencies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "Yangilangan sana: $updatedDate",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ...currencies.map((currency) => currencyTile(currency)).toList(),
                ],
              ),
            ),
    );
  }
}
