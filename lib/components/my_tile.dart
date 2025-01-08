// import 'package:flutter/material.dart';

// class MyTile extends StatelessWidget {
//   final String text;
//   final IconData? icon;
//   final void Function()? onTap;

//   const MyTile(
//       {super.key, required this.text, required this.icon, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20.0),
//       child: ListTile(
//         title: Text(
//           text,
//           style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
//         ),
//         leading: Icon(
//           icon,
//           color: Theme.of(context).colorScheme.inversePrimary,
//         ),
//         onTap: onTap,
//       ),
//     );
//   }
// }
// ------------------------------------------------------------------------------------------------------
import 'package:flutter/material.dart';

class MyTile extends StatelessWidget {
  final String text;
  final IconData? icon;
  final void Function()? onTap;

  const MyTile({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          title: Text(
            text,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          leading: Icon(
            icon,
            color: Colors.black,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
            size: 18.0,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
