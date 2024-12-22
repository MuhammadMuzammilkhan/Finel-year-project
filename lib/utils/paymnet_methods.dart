import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth for getting the user email
import 'package:sneakers_app/view/detail/card_info.dart';
import '../../../theme/custom_app_theme.dart';
import '../../../utils/constants.dart';

class PaymentModeScreen extends StatefulWidget {
  const PaymentModeScreen({Key? key}) : super(key: key);

  @override
  _PaymentModeScreenState createState() => _PaymentModeScreenState();
}

class _PaymentModeScreenState extends State<PaymentModeScreen> {
  String _selectedPaymentMode = 'Cash on Delivery'; // Default selection
  String? _selectedOnlinePaymentMethod;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late String userEmail; // Store user's email

  @override
  void initState() {
    super.initState();
    _getUserEmail(); // Get user email on initialization
  }

  Future<void> _getUserEmail() async {
    User? user = _auth.currentUser;
    if (user != null) {
      userEmail = user.email ?? 'unknown';
    } else {
      userEmail = 'unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Modes", style: AppThemes.bagTitle),
        backgroundColor: AppConstantsColor.darkTextColor,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Choose Payment Mode", style: AppThemes.bagTitle),
            SizedBox(height: height * 0.02),

            // Cash on Delivery Option
            ListTile(
              title: const Text("Cash on Delivery", style: AppThemes.bagProductModel),
              leading: Radio<String>(
                value: 'Cash on Delivery',
                groupValue: _selectedPaymentMode,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMode = value!;
                    _selectedOnlinePaymentMethod = null; // Reset online payment selection
                  });
                },
                activeColor: AppConstantsColor.materialButtonColor,
              ),
            ),

            // Online Payment Option
            ListTile(
              title: const Text("Online Payment", style: AppThemes.bagProductModel),
              leading: Radio<String>(
                value: 'Online Payment',
                groupValue: _selectedPaymentMode,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMode = value!;
                  });
                },
                activeColor: AppConstantsColor.materialButtonColor,
              ),
            ),

            // Show JazzCash option only if Online Payment is selected
            if (_selectedPaymentMode == 'Online Payment') ...[
              SizedBox(height: height * 0.02),
              const Text("Select Online Payment Method", style: AppThemes.bagTitle),
              ListTile(
                title: const Text("JazzCash", style: AppThemes.bagProductModel),
                leading: Radio<String>(
                  value: 'JazzCash',
                  groupValue: _selectedOnlinePaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedOnlinePaymentMethod = value!;
                    });
                  },
                  activeColor: AppConstantsColor.materialButtonColor,
                ),
              ),
            ],

            // Confirm Button
            const Spacer(),
            Center(
              child: MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                minWidth: width * 0.8,
                height: height / 15,
                color: AppConstantsColor.materialButtonColor,
                onPressed: () {
                  // Handle confirmation action (e.g. move to the next screen)
                  _confirmPayment();
                },
                child: const Text(
                  "CONFIRM",
                  style: TextStyle(color: AppConstantsColor.lightTextColor),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
          ],
        ),
      ),
    );
  }

  void _confirmPayment() async {
    String paymentInfo = _selectedPaymentMode;
    if (_selectedPaymentMode == 'Online Payment' && _selectedOnlinePaymentMethod != null) {
      paymentInfo += " with $_selectedOnlinePaymentMethod";
    }

    try {
      // Save order details to Firestore
      await _firestore.collection('orders').add({
        'userEmail': userEmail,
        'paymentMode': _selectedPaymentMode,
        'onlinePaymentMethod': _selectedOnlinePaymentMethod ?? '',
        'orderTime': FieldValue.serverTimestamp(), // Store timestamp
      });

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Payment Confirmation'),
            content: Text('You have selected: $paymentInfo\nOrder saved for tracking.'),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CardInfoScreen()));
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Show error message if saving fails
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to save your order. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
