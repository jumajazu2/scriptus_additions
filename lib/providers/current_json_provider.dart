// create a provider to store current json
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentJsonProvider = StateProvider<String>((ref) => '');
