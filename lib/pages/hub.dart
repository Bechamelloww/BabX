import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {

  final events = [
    {
      "speaker": "Arouf Gangsta",
      "date" : "143h à 12h",
      "subject" : "la mort des streamers",
      "avatar": "aroufe0.png"
    },
    {
      "speaker": "Aroufeeeeeeeee Gangsta",
      "date" : "1h à 12h",
      "subject" : "la mort des streamerss",
      "avatar": "aroufe0.png"
    },
    {
      "speaker": "Aroufeee Gangsta",
      "date" : "1h à 12h",
      "subject" : "la mort des streamerssss",
      "avatar": "aroufe0.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final avatar = event['avatar'];
          final date = event['date'];
          final subject = event['subject'];
          final speaker = event['speaker'];

          return Card(
              child: ListTile(
                leading: Image.asset("assets/images/$avatar"),
                title: Text("$speaker ($date)"),
                subtitle: Text("$subject"),
                trailing: const Icon(Icons.more_vert),
              )
          );
        },
      ),
    );
  }
}
