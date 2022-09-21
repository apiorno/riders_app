import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PayFareAmountDialog extends StatefulWidget {
  final double fareAmount;
  const PayFareAmountDialog({required this.fareAmount, super.key});

  @override
  State<PayFareAmountDialog> createState() => _PayFareAmountDialogState();
}

class _PayFareAmountDialogState extends State<PayFareAmountDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      backgroundColor: Colors.grey,
      child: Container(
        margin: const EdgeInsets.all(6),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.black87, borderRadius: BorderRadius.circular(6)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'FARE AMOUNT',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(thickness: 4, color: Colors.grey),
            const SizedBox(
              height: 16,
            ),
            Text(
              '\$ ${widget.fareAmount.toString()}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 50,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('This is the total trip fare amount, pay it',
                  style: TextStyle(
                    color: Colors.grey,
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  Future.delayed(const Duration(milliseconds: 2000), () {
                    Navigator.pop(context, true);
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Pay Cash',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.attach_money,
                      color: Colors.white,
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
