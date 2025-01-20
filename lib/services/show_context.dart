import 'package:country_flags/country_flags.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:scriptus/audio/audio_player.dart';
import 'package:scriptus/extensions/deepl_service.dart';
import 'package:scriptus/extensions/document_service.dart';
import 'package:scriptus/extensions/file_services.dart';
import 'package:scriptus/models/meeting.dart';
import 'package:scriptus/models/transcript_data.dart';
import 'package:scriptus/providers/current_doc_provider.dart';
import 'package:scriptus/providers/meeting_provider.dart';
import 'package:scriptus/providers/sentence_providers.dart';
import 'package:scriptus/providers/settings_provider.dart';
import 'package:scriptus/providers/variable_monitor.dart';
import 'package:scriptus/repositories/transcript_data_repo.dart';
import 'package:scriptus/screen_parts/assigned_places.dart';
import 'package:scriptus/screen_parts/found_scriptures.dart';
import 'package:scriptus/screen_parts/saved_verses.dart';
import 'package:scriptus/screen_parts/search_widget.dart';
import 'package:scriptus/screen_parts/settings/settigns_dialog.dart';
import 'package:scriptus/services/kjv_from_db.dart';
import 'package:scriptus/home_page.dart';
import 'package:scriptus/services/show_context.dart';

class ShowContext extends ConsumerWidget {
  /// Displays a wider context of Scriptures before and after a selected scripture.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScrollController _scrollController = ScrollController();

    // Initialize scroll position to center the middle item
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int totalCharacters = contextFromDB
          .where((item) => item is String) // Ensure the item is a String
          .map((item) => (item as String).length) // Cast to String
          .fold<int>(0, (sum, length) => sum + length); // Sum up lengths
      final middleIndex = contextFromDB.length ~/ 2;
      final middleOffset = totalCharacters /
          2.8; // approximated on the number of characters in the whole list
      //_scrollController.jumpTo(middleIndex);
      //print(totalCharacters);
      //print(middleOffset);
      _scrollController.animateTo(middleOffset,
          duration: Duration(seconds: 1), curve: Curves.easeInOut);
    });

    return Flexible(
      child: ListView.builder(
        controller: _scrollController, // Attach the controller
        itemCount: contextFromDB.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: SelectableText(
              contextFromDB[index],
              style: TextStyle(
                fontWeight: (index == (contextFromDB.length ~/ 2))
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}
