import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ExpandableCard extends StatelessWidget {
  String heading;
  String body;
  ExpandableCard({
    required this.heading,
    required this.body,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        initialExpanded: false,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Card(
            elevation: 0,
            // color: Color(0xff143061),
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color(0xff4e77ba), // Set the border color
                width: 2.0, // Set the border width
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: Container(
              child: Column(
                children: <Widget>[
                  ScrollOnExpand(
                    scrollOnExpand: true,
                    scrollOnCollapse: false,
                    child: ExpandablePanel(
                      theme: const ExpandableThemeData(
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        tapBodyToCollapse: true,
                        iconColor: Colors.white,
                      ),
                      header: Container(
                        margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              heading,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      collapsed: Text(
                        "More details",
                        style: TextStyle(color: Colors.white),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        selectionColor: Colors.white,
                      ),
                      expanded: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Divider(
                            thickness: 1,
                            color: Color(0xffCCCCCC),
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            body,
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                        ],
                      ),
                      builder: (_, collapsed, expanded) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Expandable(
                            collapsed: collapsed,
                            expanded: expanded,
                            theme:
                                const ExpandableThemeData(crossFadePoint: 0.7),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
