import 'package:flutter/material.dart';
import 'package:ukk_cafe/Manager/awal.dart';

class ManagerPage extends StatefulWidget {
  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  bool showFailedTransactions = false;
  String searchDate = ''; 
  String selectedMonth = 'Semua Bulan'; // Default value for dropdown

  final List<String> months = [
    'Semua Bulan',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final List<Map<String, dynamic>> transactions = [
    {
      'date': '22-09-2024',
      'items': '2x Mango Iced Tea',
      'customer': 'Rosmala',
      'amount': 'Rp.14.000,00',
      'isSuccessful': true,
    },
    {
      'date': '22-09-2024',
      'items': '2x Mango Iced Tea',
      'customer': 'Rosmala',
      'amount': 'Rp.14.000,00',
      'isSuccessful': true,
    },
    {
      'date': '22-09-2024',
      'items': '1x Orange Juice',
      'customer': 'Rosmala',
      'amount': 'Rp.10.000,00',
      'isSuccessful': false,
    },
    {
      'date': '22-09-2024',
      'items': '1x Lemonade',
      'customer': 'Siti',
      'amount': 'Rp.12.000,00',
      'isSuccessful': true,
    },
    {
      'date': '21-09-2024',
      'items': '1x Strawberry Milkshake',
      'customer': 'Ahmad',
      'amount': 'Rp.15.000,00',
      'isSuccessful': true,
    },
    {
      'date': '21-09-2024',
      'items': '1x Apple Juice',
      'customer': 'Ahmad',
      'amount': 'Rp.12.000,00',
      'isSuccessful': false,
    },
    {
      'date': '21-09-2024',
      'items': '2x Banana Smoothie',
      'customer': 'Laila',
      'amount': 'Rp.18.000,00',
      'isSuccessful': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E9D3),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  color: Color(0xFF8B5D57),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AwalPage()), 
                        );
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Transaction History',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildCategoryButton('Transaction', !showFailedTransactions, () {
                      setState(() {
                        showFailedTransactions = false;
                      });
                    }),
                    SizedBox(width: 10),
                    buildCategoryButton('Failed', showFailedTransactions, () {
                      setState(() {
                        showFailedTransactions = true;
                      });
                    }),
                  ],
                ),
              ),
              // Dropdown for filtering by month
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: DropdownButton<String>(
                  value: selectedMonth,
                  items: months.map((String month) {
                    return DropdownMenuItem<String>(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMonth = value!;
                    });
                  },
                  isExpanded: true,
                  underline: Container(
                    height: 2,
                    color: Color(0xFF8B5D57),
                  ),
                ),
              ),
              Expanded(
                child: buildTransactionList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCategoryButton(String text, bool isSelected, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFF8B5D57) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide(color: Color(0xFF8B5D57)),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.white : Color(0xFF8B5D57),
          ),
        ),
      ),
    );
  }

  Widget buildTransactionList() {
    List<Map<String, dynamic>> filteredTransactions = transactions.where((transaction) {
      // Filter transactions based on the selected month and the search query
      bool matchesSearch = transaction['date'].contains(searchDate);
      bool matchesStatus = showFailedTransactions
          ? !transaction['isSuccessful']
          : transaction['isSuccessful'];
      bool matchesMonth = selectedMonth == 'Semua Bulan' || transaction['date'].contains(getMonthNumber(selectedMonth));
      
      return matchesSearch && matchesStatus && matchesMonth;
    }).toList();

    return ListView.builder(
      itemCount: filteredTransactions.length,
      itemBuilder: (context, index) {
        var transaction = filteredTransactions[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction['items'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        transaction['customer'],
                      ),
                    ],
                  ),
                  Text(
                    transaction['amount'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7D4D47),
                    ),
                  ),
                  Icon(
                    transaction['isSuccessful']
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: transaction['isSuccessful'] ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String getMonthNumber(String month) {
    switch (month) {
      case 'Januari':
        return '01';
      case 'Februari':
        return '02';
      case 'Maret':
        return '03';
      case 'April':
        return '04';
      case 'Mei':
        return '05';
      case 'Juni':
        return '06';
      case 'Juli':
        return '07';
      case 'Agustus':
        return '08';
      case 'September':
        return '09';
      case 'Oktober':
        return '10';
      case 'November':
        return '11';
      case 'Desember':
        return '12';
      default:
        return '';
    }
  }
}
