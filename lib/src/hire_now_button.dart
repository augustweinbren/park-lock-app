import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'dart:math';
import './locations.dart' as locations;
import './user.dart' as user_data;

class HireButton extends StatefulWidget {
  HireButton({
    Key? key,
    required this.title,
    required this.locker,
  }) : super(key: key);
  final String title;
  final locations.Locker locker;
  @override
  _HireButtonState createState() => _HireButtonState();
}

class _HireButtonState extends State<HireButton> {
  _HireButtonState();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        child: Text(widget.title),
        onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text('Hire a locker at ${widget.locker.name}?'),
                  content: const Text('This will cost you 1 credit.'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context, 'false');
                      },
                    ),
                    TextButton(
                      child: const Text('Hire'),
                      onPressed: () {
                        Navigator.pop(context, 'true');
                      },
                    ),
                  ],
                )));
  }
}

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