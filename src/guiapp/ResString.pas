unit ResString;

interface

type
  // application language:
  APP_LANGUAGE_SET= (
    LANG_DEU,    // german
    LANG_ENG     // english
  );
var
  APP_LANGUAGE: APP_LANGUAGE_SET;

const
  { ENGLISH }
  ENG_STR_MAINMENU_FILE    = '&File';

  ENG_STR_MAINMENU_EDIT                           = '&Edit';
  ENG_STR_MAINMENU_EDIT_SETTINGS                  = '&Settings';
  ENG_STR_MAINMENU_EDIT_SETTINGS_PROJECT          = '&Project';
  ENG_STR_MAINMENU_EDIT_SETTINGS_LANGUAGE         = '&Language';
  ENG_STR_MAINMENU_EDIT_SETTINGS_LANGUAGE_ENGLISH = 'English';
  ENG_STR_MAINMENU_EDIT_SETTINGS_LANGUAGE_GERMAN  = 'German';

  ENG_STR_MAINMENU_HELP    = '&Help';

  ENG_STR_TABSHEET_PROJECT_OPTIONS = 'Project Options';

  ENG_STR_SET_CATEGORY = 'Select a Category';
  ENG_STR_NEW_TOPIC = 'New Topic';

  { GERMAN }
  DEU_STR_MAINMENU_FILE    = '&Datei';

  DEU_STR_MAINMENU_EDIT                           = '&Bearbeiten';
  DEU_STR_MAINMENU_EDIT_SETTINGS                  = '&Einstellungen';
  DEU_STR_MAINMENU_EDIT_SETTINGS_PROJECT          = '&Projekt';
  DEU_STR_MAINMENU_EDIT_SETTINGS_LANGUAGE         = '&Sprache';
  DEU_STR_MAINMENU_EDIT_SETTINGS_LANGUAGE_ENGLISH = 'Englisch';
  DEU_STR_MAINMENU_EDIT_SETTINGS_LANGUAGE_GERMAN  = 'Deutsch';

  DEU_STR_MAINMENU_HELP    = '&Hilfe';

  DEU_STR_TABSHEET_PROJECT_OPTIONS = 'Projekt Optionen';

  DEU_STR_SET_CATEGORY = 'Kategorie auswählen';
  DEU_STR_NEW_TOPIC = 'Neues Thema';

implementation

end.
