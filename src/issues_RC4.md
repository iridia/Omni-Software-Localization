The following are issues found by the team before release of RC4.

# Issues
* No progress indicator for file upload
* Files are not separated by language (resource bundle)
* When switching users, need to update main UI (go to a default view?)
* Outline view selection of items other than actual projects or glossaries has unexpected behavior (including deselecting all items)
* Most of the application is left-aligned, except the toolbar items are right-aligned. This is a little jarring
* No keyboard shortcuts for table views (up, down)
* Comments potentially won't fit in editor window
* No way to log out
* Login/Register windows retain info previously entered
* Uploading is inconsistent
* Doesn't scroll line items table view when you hit next in editor window
* Enter doesn't submit things across the UI (login, register, feedback)
* File menu is weird all by itself
* Voting UI allows multiple clicks, but only single vote
* Files with no values are shown (like empty line items)
* Editing is slow for large applications
* After upload, the first click does not register anywhere
* Inconsistent buttons in editor/rest of app

# Projects we have found that break our uploading
* Safari
* Camino
* Colloquy

# Glossaries we have found that break our uploading
* Safari's Localizable.strings