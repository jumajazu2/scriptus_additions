import 'package:flutter/material.dart';

class ObjectAttributesTable extends StatelessWidget {
  final Map<String, dynamic> attributesMap;

  const ObjectAttributesTable({super.key, required this.attributesMap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 500,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Header row
            // const Row(
            //   children: [
            //     Expanded(
            //         child: Padding(
            //             padding: EdgeInsets.all(8.0),
            //             child: Text('Attribute'))),
            //     Expanded(
            //         child: Padding(
            //             padding: EdgeInsets.all(8.0), child: Text('Value'))),
            //   ],
            // ),
            // Data rows
            ...attributesMap.keys.map((key) {
              var value = attributesMap[key];
              Widget valueWidget;

              if (value is List) {
                valueWidget = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Number of items: ${value.length}'),
                    const SizedBox(height: 8),
                    ...value
                        .map((item) => Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(item.toString())))
                        .toList(),
                  ],
                );
              } else {
                valueWidget = Text(value.toString());
              }
              return value != null && value.toString().length > 30
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(
                        //     width: 100,
                        //     child:
                        Container(
                            width: 400,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(key,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey))),
                        // ,),
                        // Expanded(
                        //     child:
                        Container(
                            width: 400,
                            padding: const EdgeInsets.all(8.0),
                            child: valueWidget),
                        // ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 100,
                            padding: const EdgeInsets.all(8.0),
                            child: Text(key,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey))),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: valueWidget,
                          ),
                        ),
                      ],
                    );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 400,
//       height: 500,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Column(
//           // dataRowMaxHeight: 150,
//           // dataRowMinHeight: 20,
//           children: [
//             const Row( children: [Text('Attribute'), Text('Value')]),

//             for (var a in attributesMap.keys.map((key)).toList())
//               Row(children:[Text(key), Text(attributesMap[key].toString())]);
//       ]),
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }
