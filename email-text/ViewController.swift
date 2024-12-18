//
//  ViewController.swift
//  email-text
//
//  Created by Bojan Stefanović on 12/18/24.
//

import SwiftUI
import UIKit

private enum Consts {
  static let intrinsicTextFieldHeight: CGFloat = 34
  static let defaultPadding: CGFloat = 16
}

struct InlineCodeTextView: View {
  private let verbatim: String

  init(verbatim: String) {
    self.verbatim = verbatim
  }

  var body: some View {
    Text(verbatim: verbatim)
      .monospaced()
      .padding(.horizontal, 4)
      .padding(.vertical, 2)
      .background(Color.gray.opacity(0.33))
      .cornerRadius(4)
  }
}

struct SwiftUIExample: View {
  private enum FocusField {
    case email, username
  }

  @FocusState private var focusField: FocusField?
  @State private var emailText: String = ""
  @State private var usernameText: String = ""

  var body: some View {
    VStack {
      Text("SwiftUI")
        .font(.largeTitle)
      Group {
        HStack {
          Text(verbatim: "TextField with")
          InlineCodeTextView(verbatim: ".textContentType(.emailAddress)")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        TextField("Email", text: $emailText)
          .textFieldStyle(.roundedBorder)
          .focused($focusField, equals: .email)
          .submitLabel(.next)
          .onSubmit { focusField = .username }
          .textContentType(.emailAddress); #warning("SwiftUI: The culprit")
        // When the contentType is `.emailAddress`, Apple's iCloud Hide My Email feature is shown in the QuickType bar.
        // This is not perfect since the user might have a different default password manager which is what should be shown during authorization.
      }
      Group {
        HStack {
          Text(verbatim: "TextField with")
          InlineCodeTextView(verbatim: ".textContentType(.username)")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        TextField("Username", text: $usernameText)
          .textFieldStyle(.roundedBorder)
          .focused($focusField, equals: .username)
          .submitLabel(.next)
          .onSubmit { focusField = .email }
          .textContentType(.username); #warning("SwiftUI: The solution")
        // When the contentType is `.username`, this shows the default password manager in the QuickType bar.
      }
      Spacer()
      Text("👇")
        .font(.largeTitle)
    }
    .padding()
    .onAppear {
      focusField = .email
    }
  }
}

class ViewController: UIViewController {
  private let emailTextField = UITextField()
  private let usernameTextField = UITextField()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    /* UIKit example */
    let label = UILabel()
    label.text = "UIKit"
    label.textAlignment = .center
    label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    view.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.setContentHuggingPriority(.required, for: .vertical)
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Consts.defaultPadding),
      label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Consts.defaultPadding),
      label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Consts.defaultPadding),
    ])

    emailTextField.placeholder = "Email"
    emailTextField.textContentType = .emailAddress; #warning("UIKit: The culprit")
    emailTextField.borderStyle = .roundedRect
    emailTextField.returnKeyType = .next
    emailTextField.delegate = self
    view.addSubview(emailTextField)
    emailTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      emailTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 1),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: emailTextField.trailingAnchor, multiplier: 1),
      emailTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Consts.defaultPadding),
      emailTextField.heightAnchor.constraint(equalToConstant: Consts.intrinsicTextFieldHeight)
    ])

    usernameTextField.placeholder = "Username"
    emailTextField.returnKeyType = .next
    usernameTextField.textContentType = .username; #warning("UIKit: The solution")
    usernameTextField.borderStyle = .roundedRect
    usernameTextField.delegate = self
    view.addSubview(usernameTextField)
    usernameTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      usernameTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 1),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: usernameTextField.trailingAnchor, multiplier: 1),
      usernameTextField.topAnchor.constraint(equalToSystemSpacingBelow: emailTextField.bottomAnchor, multiplier: 1),
      usernameTextField.heightAnchor.constraint(equalToConstant: Consts.intrinsicTextFieldHeight)
    ])

    /* SwiftUI example */
    let hostingController = UIHostingController(rootView: SwiftUIExample())
    addChild(hostingController)
    view.addSubview(hostingController.view)
    hostingController.didMove(toParent: self)
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      hostingController.view.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor),
      hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }


}

extension ViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
    case emailTextField:
      usernameTextField.becomeFirstResponder()
    case usernameTextField:
      emailTextField.becomeFirstResponder()
    default:
      break
    }

    return false
  }
}
