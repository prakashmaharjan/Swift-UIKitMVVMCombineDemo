This is the demo app to show MVVM architecture in swift UIKIT with combine framework.
Here Post list is fetched from sample json url (https://jsonplaceholder.typicode.com/posts) provided by https://jsonplaceholder.typicode.com and shown in UITableView with help of combine framework.


4. **Launch the project:**
   - Open `UIKitMVVMCombineDemo.xcodeproj` directly in Xcode.
   - Select your preferred simulator (e.g., iPhone 17).
   - Press `Cmd + R` to compile and run.

> **Note on Code Signing:** If compilation fails with a signing error, navigate to **Project Settings > Signing & Capabilities** and update the development team to your personal developer account.

## 🏗️ Architecture & Stack
- **Language**: Swift 6
- **Architecture**: MVVM(Model-View-ViewModel)
- **UI Layout**: UIKit Programmatic 
- **Network Client**: Combine-driven API service layer with URLSession
