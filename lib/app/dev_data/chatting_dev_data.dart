/// chatting dev data
List<Message> messages = [
  Message(
    text: "Hey!",
    date: DateTime.now().subtract(const Duration(minutes: 1)),
    isSentByMe: false,
  ),
  Message(
    text: "Hey! How’s it going?",
    date: DateTime.now().subtract(const Duration(minutes: 9)),
    isSentByMe: true,
  ),
  Message(
    text: "Pretty good, just working on a Flutter app.",
    date: DateTime.now().subtract(const Duration(minutes: 8)),
    isSentByMe: false,
  ),
  Message(
    text: "Nice! What feature are you adding?",
    date: DateTime.now().subtract(const Duration(minutes: 7)),
    isSentByMe: true,
  ),
  Message(
    text: "A chat feature actually, testing messages.",
    date: DateTime.now().subtract(const Duration(minutes: 6)),
    isSentByMe: false,
  ),
  Message(
    text: "That’s great! Using Firebase?",
    date: DateTime.now().subtract(const Duration(minutes: 5)),
    isSentByMe: true,
  ),
  Message(
    text: "Yeah, Firebase Firestore for real-time messaging.",
    date: DateTime.now().subtract(const Duration(minutes: 4)),
    isSentByMe: false,
  ),
  Message(
    text: "Sounds solid. Need any help with state management?",
    date: DateTime.now().subtract(const Duration(minutes: 3)),
    isSentByMe: true,
  ),
  Message(
    text: "Maybe! I’m considering Riverpod or Bloc.",
    date: DateTime.now().subtract(const Duration(minutes: 2)),
    isSentByMe: false,
  ),
  Message(
    text: "Both are great! Bloc is good for structured apps.",
    date: DateTime.now().subtract(const Duration(minutes: 1)),
    isSentByMe: true,
  ),
  Message(
    text: "Yeah, I might go with Bloc. Thanks for the advice!",
    date: DateTime.now(),
    isSentByMe: false,
  ),
];

class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;

  Message({required this.text, required this.date, required this.isSentByMe});
}
