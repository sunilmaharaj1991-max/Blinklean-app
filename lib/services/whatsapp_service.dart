import 'package:url_launcher/url_launcher.dart';
import '../models/scrap_item_model.dart';

class WhatsappService {
  final String _businessNumber = '+917022803582'; // Blinklean business number

  Future<void> sendScrapPickupRequest({
    required List<ScrapItemModel> items,
    required String address,
    required String date,
    required String time,
  }) async {
    StringBuffer itemsBuffer = StringBuffer();
    for (var item in items) {
      itemsBuffer.writeln('${item.category} - ${item.estimatedWeight}kg');
    }

    String message =
        '''Hello Blinklean,

I want to schedule a scrap pickup.

Scrap Items:
$itemsBuffer
Pickup Address:
$address

Preferred Date:
$date

Preferred Time:
$time
''';

    final Uri whatsappUrl = Uri.parse(
      'https://wa.me/$_businessNumber?text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch WhatsApp');
    }
  }
}
