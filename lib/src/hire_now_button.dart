import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:math';
import './locations.dart' as locations;
import './user.dart' as user_data;

class HireButton extends StatelessWidget {
  const HireButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        _confirmHire(context);
      },
      child: const Text('Hire Now'),
    );
  }

  void _confirmHire(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the ConfirmScreen
      MaterialPageRoute(builder: (context) => const ConfirmScreen()),
    );
  }
}

class ConfirmScreen extends StatelessWidget {
  const ConfirmScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Hire'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Confirm');
              },
              child: const Text('Book Locker'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

// class _HireButtonState extends State<HireButton> {
//   _HireButtonState();

//   @override
//   Widget build(BuildContext context) {
//     return OutlinedButton(
//       child: const Text('Hire Now'),
//       onPressed: () {
//         _hireNow(context, widget.locker);
//       },
//     );
//   }
// }

// void _hireNow(BuildContext context, locations.Locker locker) async {
//   final result = await Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => const HireNow(locker),
//     ),
//   );
// }

// class HireNow extends StatefulWidget {
//   const HireNow(this.locker);

//   final locations.Locker locker;
// }

// class _HireNowState extends State<HireNow> {
//   _HireNowState();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: const Text('Confirm locker hire')),
//         body: Center(
//           child: Column(
//             children: [
//               TextButton(
//                 child: const Text('Hire now'),
//                 onPressed: () {
//                   _hireNow(context, widget.locker);
//                 },
//               ),
//               TextButton(
//                 child: const Text('Cancel'),
//                 onPressed: () {
//                   _hireNow(context, widget.locker);
//                 },
//               ),
//             ],
//           ),
//         ));
//   }
// }


  // onPressed: () => showDialog<String>(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //           title: Text('Hire a locker at ${widget.locker.name}?'),
  //           content: const Text('This will cost you 1 credit.'),
  //           actions: <Widget>[
  //             TextButton(
  //               child: const Text('Cancel'),
  //               onPressed: () {
  //                 Navigator.pop(context, 'false');
  //               },
  //             ),
  //             TextButton(
  //               child: const Text('Hire'),
  //               onPressed: () {
  //                 Navigator.pop(context, 'true');
  //               },
  //             ),
  //           ],
  //         ))

// void _confirmHire(BuildContext context, locations.Locker locker) async {
//   final result = await Navigator.push(
//     context,
//     builder: (context) => HireConfirmation(
//       locker: locker.name,
//     ),
//   );
//   if (result) {
//     locker.occupancy -= 1;
//   }
// }

// class HireConfirmation extends StatefulWidget {
//   HireConfirmation({
//     Key? key,
//     required this.locker,
//   }) : super(key: key);
//   final String locker;
//   @override
//   _HireConfirmationState createState() => _HireConfirmationState();
// }

// class _HireConfirmationState extends State<HireConfirmation> {
//   _HireConfirmationState();

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Hire ${widget.locker}?'),
//       content: const Text('This will cost you 1 credit.'),
//       actions: <Widget>[
//         TextButton(
//           child: const Text('Cancel'),
//           onPressed: () {
//             Navigator.pop(context, false);
//           },
//         ),
//         TextButton(
//           child: const Text('Hire'),
//           onPressed: () {
//             Navigator.pop(context, true);
//           },
//         ),
//       ],
//     );
//   }
// }

/*showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Are you sure you would like to book a locker at ' +
              widget.locker.name +
              '?'),
          content: const Text('This will cost you 1 credit.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => {Navigator.pop(context, 'OK')},
              child: const Text('OK'),
            ),
          ],
        ),
      ),*/
            /*trailing: OutlinedButton(
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('How many lockers do you need?'),
                    content: NumberPicker(
                      minValue: 1,
                      maxValue:
                          lockers[index].capacity - lockers[index].occupancy,
                      value: min(2,
                          lockers[index].capacity - lockers[index].occupancy),
                      onChanged: (value) => setState(() =>
                      lockers[index].occupancy += value)),
                    
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
                // onPressed: () {}, //=> showDialog<String>(
                //   context: context,
                //   builder: (BuildContext context) => AlertDialog(
                //       title: const Text('How many lockers?'),
                //       content: NumberPicker(
                //           minValue: 1,
                //           maxValue: lockers[index].capacity -
                //               lockers[index].occupancy,
                //               value: 1,
                //   ),
                // ) {

                // },
                child: const Text('Hire Now'),*/