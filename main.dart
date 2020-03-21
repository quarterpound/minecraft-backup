import 'dart:io';
import 'package:intl/intl.dart';
import 'package:archive/archive_io.dart';
import 'package:teledart/telegram.dart';
import 'package:dotenv/dotenv.dart' show load, env;
import "dart:async";

void main() async {
  load();
  var bot = new Telegram(env['BOT']);
print("Started");
  var stream = new Stream.periodic(const Duration(days: 1, seconds: 10), (count) async {
    var check = await  Directory("../world").exists();
    if(check) {
      var datestring = new DateFormat("yyyy-MM-dd").format(new DateTime.now());
      var encoder = ZipFileEncoder();
      encoder.zipDirectory(Directory('../world'), filename: 'backup/' + datestring + '.zip');
      return datestring;
    }
    return '';
  });

  stream.listen((result) async {
    var status = await result;
    if(status == '') {
      bot.sendMessage(int.parse(env['CHAT_ID']), 'Back was not generated!');
      return;
    }
    bot.sendMessage(int.parse(env['CHAT_ID']), 'Back up generated ${status}');
  });
}
