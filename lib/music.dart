import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mirror/motivational_music.dart';
import 'package:mirror/sleepingmusic.dart';

class TicketTabView extends StatefulWidget {
  const TicketTabView({
    Key? key,
  }) : super(key: key);

  @override
  State<TicketTabView> createState() => _TicketTabViewState();
}

class _TicketTabViewState extends State<TicketTabView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);

    return Scaffold(
        // backgroundColor: Colors.white,
        body: SafeArea(
      child: Container(
          // margin: const EdgeInsets.only(right: 10, left: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TabBar(
            unselectedLabelColor: Colors.grey,
            labelStyle: GoogleFonts.poppins(
                textStyle: const TextStyle(
              fontFamily: 'poppins',
              fontSize: 15,
              fontWeight: FontWeight.w500,
            )),
            controller: tabController,
            indicatorColor: Colors.red,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 2,
            dividerColor: Colors.grey.shade300,
            tabs: const [
              Tab(text: 'Motivational'),
              Tab(
                text: 'Sleep',
              ),
            ]),
        Expanded(
            child: TabBarView(
                controller: tabController,
                children: [MotivationalMusicPage(), SleepingMusicPage()])),
      ])),
    ));
  }
}
