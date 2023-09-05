import 'package:scriptus/providers/current_doc_provider.dart';

void setAllWBQ(ref) {
  ref.read(currentTranscriptProvider.notifier).setAllWBQ();
}
