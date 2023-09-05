# scriptus

Flutter App

Loads JSON data from a URL and displays it in a ListView.

Uses OpenAI API to return Bible references.

Structure

Providers

- PlacesProvider - Loads JSON data from a URL and returns a list of places for opened sermon's meeting.

Workflow

1. User opens JSON file from the file system.
   - File is parsed into Segments. ()
   - Segments are displayed in a ListView.
   - From filename, get meeting date and load meeting data from API.
   - From API, get already saved Places for the meeting.
   - Display Bible references for the meeting in a ListView.

Now let's finish the GUI. After user loads an JSON file and file is parsed into segments, Segments are listed
There must be this functionality
