import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SubscribePage extends StatelessWidget {
  const SubscribePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace this with your payment details
    final String paymentDetails = 'Your Payment Details';

    return Scaffold(
      backgroundColor: Color.fromRGBO(218, 251, 249, 1),
      appBar: AppBar(
        toolbarHeight: 100,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Color.fromARGB(255, 147, 230, 208)),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Subscribe to our newsletter!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            QrImageView(
              data: paymentDetails,
              version: QrVersions.auto,
              size: 200,
            ),
            SizedBox(height: 16),
            Text(
              "2.99",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Scan the QR code to make a payment',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              width: 400,
              child: ElevatedButton(
                child: Text("Subscribe"),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 32, 177, 138),
                  elevation: 0,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Subscription Confirmation'),
                        content: Text('Are you sure you want to subscribe?'),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                          ),
                          TextButton(
                            child: Text('Subscribe'),
                            onPressed: () {
                              // Perform subscription logic here
                              // ...
                              Navigator.pop(context); // Close the dialog
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
