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
    // Generate a list of numbers from 1 to 10

    final contextDisplay = contextByID(
        'Who have said, With our tongue will we prevail; our lips are our own: who is lord over us?',
        100,
        20,
        ref);

    return Flexible(
      child: ListView.builder(
          itemCount: contextFromDB.length, // Number of items in the list
          itemBuilder: (context, index) {
            return ListTile(
              title: SelectableText(contextFromDB[index]), // Display each item
              //leading: Icon(Icons.star)
            );
          }),
    );
  }
}
