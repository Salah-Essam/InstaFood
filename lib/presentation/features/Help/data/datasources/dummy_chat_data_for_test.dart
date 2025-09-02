class DummyChatDataForTest {
  List<Map<String, dynamic>> messages() => [
    {'text': "Hello!", 'isMe': true},
    {
      'text':
          "Hello!, please choose the number corresponding to your needs for a more efficient service.",
      'isMe': false,
    },
    {
      'text':
          "1. Order Management\n2. Payments Management\n3. Account management and profile\n4. About order tracking\n5. Safety",
      'isMe': false,
    },
    {'text': "1", 'isMe': true},
    {
      'text':
          "You have a current order Strawberry Shake and Broccoli Lasagna\nOrder No. 0054752\n29 Nov, 01:20 pm ",
      'isMe': false,
    },
  ];
}
