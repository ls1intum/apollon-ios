# Apollon iOS

A UML modeling editor application for iOS written in Swift and SwiftUI. The main functionality is imported from the [Apollon-iOS-Module](https://github.com/ls1intum/apollon-ios-module) SPM package.

## Main Features
### Easy to use editor
The user interface of Apollon iOS is simple to use. 
-   Select the diagram type you want to draw or choose to import a file.
-   Adding an element is as easy as choosing the desired element from the elements menu by clicking the `+` button at the bottom of the screen.
-   Drawing a connection between elements is done by selecting one element and dragging a path to another.
-   Edit the text of any element by selecting it and clicking the menu button. An easy-to-use menu will allow you to do so.
-   Elements can be moved and resized by holding down the move or resize button on the selected element.
-   Supports dark/light themes for the editor.
-   Offline Mode: Diagrams are saved locally on your device with SwiftData.

<img src="/docs/Apollon-iOS-Demo.gif" alt="Apollon iOS features" width="300"/>

### Import and Export
Apollon iOS allows importing JSON files for diagrams created on [Apollon Standalone](https://apollon.ase.in.tum.de).
Diagrams created and edited on the Apollon iOS application can also be exported to JSON, allowing diagrams to be used between both applications.

### UML diagrams
Currently, Apollon iOS supports creating three different UML diagrams, with more types to be added in the future.

The list of UML diagrams includes:
-   `Class Diagram`
-   `Object Diagram`
-   `Use Case Diagram`

## Screenshots
| Diagrams | Editor | Export |
|    :---:    |    :---:    |    :---:    |
| <img src="/docs/screenshots/Diagrams-Screenshot.png" width="300"/> | <img src="/docs/screenshots/Editor-Screenshot.png" width="300"/> | <img src="/docs/screenshots/Share-Screenshot.png" width="300"/> |

## Usage
1. Clone the repository
```
git clone https://github.com/ls1intum/apollon-ios.git
```
2. Open the project in Xcode
3. Compile and run the application in your simulator
