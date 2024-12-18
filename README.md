# Email vs Username TextField Demo

This project demonstrates how iOS keyboard suggestions differ when using `textContentType` values of `.emailAddress` vs. `.username` on text fields. The key takeaway is that using `.emailAddress` on a text field will trigger Apple's iCloud "Hide My Email" feature above the keyboard, while `.username` will invoke the default password manager set on the device.

**What’s Included:**

- **SwiftUI Example:**  
  A `TextField` configured with `.textContentType(.emailAddress)` and another with `.textContentType(.username)`.  
  The `.emailAddress` field shows iCloud’s "Hide My Email", whereas the `.username` field shows the device’s default password manager suggestions.

- **UIKit Example:**  
  Two `UITextField`s set up similarly, one with `.emailAddress` and one with `.username` illustrating the same behavior in UIKit.

**How to Use:**

1. Open the Xcode project.
2. Run the app on an iOS device or simulator.
3. Focus the first (email) field and notice "Hide My Email" if `textContentType` is `.emailAddress`.
4. Switch to the second (username) field to see suggestions from the default password manager.

**Why This Matters:**

If your app wants to show password manager suggestions rather than Apple's "Hide My Email," you should avoid `.emailAddress` and use `.username` or another suitable content type. This ensures that users who prefer alternative password managers get the expected autofill options.

**Screenshot**

<p align="center">
  <img src="https://github.com/user-attachments/assets/98eb9004-a283-4b5a-8dfa-880ba3a0d654" width="419" />
  <img src="https://github.com/user-attachments/assets/5085e4c2-9845-4389-887f-256e916cf98f" width="419" />
</p>
