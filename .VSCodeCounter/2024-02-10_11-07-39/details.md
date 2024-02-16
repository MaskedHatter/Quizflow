# Details

Date : 2024-02-10 11:07:39

Directory /home/aouser/Documents/fluff/quizflow/lib

Total : 43 files,  3125 codes, 444 comments, 413 blanks, all 3982 lines

[Summary](results.md) / Details / [Diff Summary](diff.md) / [Diff Details](diff-details.md)

## Files
| filename | language | code | comment | blank | total |
| :--- | :--- | ---: | ---: | ---: | ---: |
| [lib/audio_control.dart](/lib/audio_control.dart) | Dart | 4 | 1 | 3 | 8 |
| [lib/collection_types/card_deck.dart](/lib/collection_types/card_deck.dart) | Dart | 108 | 10 | 39 | 157 |
| [lib/collection_types/card_deck.g.dart](/lib/collection_types/card_deck.g.dart) | Dart | 90 | 4 | 8 | 102 |
| [lib/collection_types/card_deck_register.dart](/lib/collection_types/card_deck_register.dart) | Dart | 9 | 0 | 4 | 13 |
| [lib/collection_types/collection.dart](/lib/collection_types/collection.dart) | Dart | 5 | 0 | 3 | 8 |
| [lib/collection_types/collection.g.dart](/lib/collection_types/collection.g.dart) | Dart | 21 | 4 | 8 | 33 |
| [lib/collection_types/duration.g.dart](/lib/collection_types/duration.g.dart) | Dart | 14 | 0 | 4 | 18 |
| [lib/collection_types/flashcard.dart](/lib/collection_types/flashcard.dart) | Dart | 50 | 12 | 18 | 80 |
| [lib/collection_types/flashcard.g.dart](/lib/collection_types/flashcard.g.dart) | Dart | 54 | 4 | 8 | 66 |
| [lib/collection_types/folder.dart](/lib/collection_types/folder.dart) | Dart | 91 | 5 | 23 | 119 |
| [lib/collection_types/folder.g.dart](/lib/collection_types/folder.g.dart) | Dart | 57 | 4 | 8 | 69 |
| [lib/domain/signin.dart](/lib/domain/signin.dart) | Dart | 30 | 13 | 8 | 51 |
| [lib/firebase_options.dart](/lib/firebase_options.dart) | Dart | 55 | 12 | 4 | 71 |
| [lib/functions/again.dart](/lib/functions/again.dart) | Dart | 18 | 4 | 4 | 26 |
| [lib/functions/easy.dart](/lib/functions/easy.dart) | Dart | 31 | 7 | 4 | 42 |
| [lib/functions/good.dart](/lib/functions/good.dart) | Dart | 37 | 5 | 5 | 47 |
| [lib/functions/grade_button_action.dart](/lib/functions/grade_button_action.dart) | Dart | 6 | 0 | 2 | 8 |
| [lib/functions/hard.dart](/lib/functions/hard.dart) | Dart | 26 | 5 | 4 | 35 |
| [lib/functions/scheduler.dart](/lib/functions/scheduler.dart) | Dart | 0 | 0 | 1 | 1 |
| [lib/main.dart](/lib/main.dart) | Dart | 66 | 37 | 15 | 118 |
| [lib/provider/add_card_model.dart](/lib/provider/add_card_model.dart) | Dart | 45 | 11 | 13 | 69 |
| [lib/provider/hive_model.dart](/lib/provider/hive_model.dart) | Dart | 100 | 13 | 16 | 129 |
| [lib/provider/import_model.dart](/lib/provider/import_model.dart) | Dart | 175 | 45 | 18 | 238 |
| [lib/provider/page_model.dart](/lib/provider/page_model.dart) | Dart | 9 | 0 | 4 | 13 |
| [lib/provider/root_folder_model.dart](/lib/provider/root_folder_model.dart) | Dart | 335 | 97 | 33 | 465 |
| [lib/provider/selected_deck_model.dart](/lib/provider/selected_deck_model.dart) | Dart | 33 | 1 | 7 | 41 |
| [lib/provider/settings_model.dart](/lib/provider/settings_model.dart) | Dart | 18 | 3 | 4 | 25 |
| [lib/screen/add_card_screen.dart](/lib/screen/add_card_screen.dart) | Dart | 90 | 0 | 4 | 94 |
| [lib/screen/display_cards_screen.dart](/lib/screen/display_cards_screen.dart) | Dart | 117 | 6 | 6 | 129 |
| [lib/screen/list_screen.dart](/lib/screen/list_screen.dart) | Dart | 145 | 29 | 21 | 195 |
| [lib/screen/settings_screen.dart](/lib/screen/settings_screen.dart) | Dart | 100 | 4 | 4 | 108 |
| [lib/service/googl_sign_in/googledrivehandler.dart](/lib/service/googl_sign_in/googledrivehandler.dart) | Dart | 2 | 1 | 2 | 5 |
| [lib/service/googl_sign_in/src/googledrivehandler_functions.dart](/lib/service/googl_sign_in/src/googledrivehandler_functions.dart) | Dart | 64 | 0 | 15 | 79 |
| [lib/service/googl_sign_in/src/googledrivehandler_screen.dart](/lib/service/googl_sign_in/src/googledrivehandler_screen.dart) | Dart | 319 | 44 | 29 | 392 |
| [lib/service/openai_service/llm_service.dart](/lib/service/openai_service/llm_service.dart) | Dart | 137 | 8 | 23 | 168 |
| [lib/widgets/add_screen_widgets/input_field.dart](/lib/widgets/add_screen_widgets/input_field.dart) | Dart | 69 | 0 | 4 | 73 |
| [lib/widgets/display_screen_widgets/card_view.dart](/lib/widgets/display_screen_widgets/card_view.dart) | Dart | 182 | 2 | 12 | 196 |
| [lib/widgets/display_screen_widgets/flip_card_button.dart](/lib/widgets/display_screen_widgets/flip_card_button.dart) | Dart | 39 | 1 | 3 | 43 |
| [lib/widgets/display_screen_widgets/grade_buttons.dart](/lib/widgets/display_screen_widgets/grade_buttons.dart) | Dart | 98 | 13 | 3 | 114 |
| [lib/widgets/display_screen_widgets/row_of_buttons.dart](/lib/widgets/display_screen_widgets/row_of_buttons.dart) | Dart | 63 | 7 | 3 | 73 |
| [lib/widgets/list_screen_widgets/carddeck_tile.dart](/lib/widgets/list_screen_widgets/carddeck_tile.dart) | Dart | 43 | 5 | 3 | 51 |
| [lib/widgets/list_screen_widgets/folder_tile.dart](/lib/widgets/list_screen_widgets/folder_tile.dart) | Dart | 116 | 13 | 8 | 137 |
| [lib/widgets/list_screen_widgets/list_screen_appbar.dart](/lib/widgets/list_screen_widgets/list_screen_appbar.dart) | Dart | 54 | 14 | 5 | 73 |

[Summary](results.md) / Details / [Diff Summary](diff.md) / [Diff Details](diff-details.md)