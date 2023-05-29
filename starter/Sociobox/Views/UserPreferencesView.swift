/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI
import Combine

struct UserPreferencesView<Store>: View where Store: PreferencesStoreProtocol {
  
  private var store: Store
  
  init(store: Store = DIContainer.shared.resolve(type: Store.self)!) {
    self.store = store
  }
  
  var body: some View {
    NavigationView {
      VStack {
        PreferenceView(title: .photos, value: .friend) { value in
          store.photosPreference = value
        }
        PreferenceView(title: .friends, value: .friend) { value in
          store.friendsListPreference = value
        }
        PreferenceView(title: .feed, value: .friend) { value in
          store.feedPreference = value
        }
        PreferenceView(title: .videoCall, value: .friend) { value in
          store.videoCallsPreference = value
        }
        PreferenceView(title: .message, value: .friend) { value in
          store.messagePreference = value
        }
        Spacer()
      }
    }.navigationBarTitle("Privacy preferences")
  }
}

struct PreferenceView: View {
  private let title: PrivacySetting
  private let value: PrivacyLevel
  private let onPreferenceUpdated: (PrivacyLevel) -> Void

  init(title: PrivacySetting, value: PrivacyLevel, onPreferenceUpdated: @escaping (PrivacyLevel) -> Void) {
    self.title = title
    self.value = value
    self.onPreferenceUpdated = onPreferenceUpdated
  }

  var body: some View {
    HStack {
      Text(title.rawValue).font(.body)
      Spacer()
      PreferenceMenu(title: value.title, onPreferenceUpdated: onPreferenceUpdated)
    }.padding()
  }
}

struct PreferenceMenu: View {
  @State var title: String
  private let onPreferenceUpdated: (PrivacyLevel) -> Void

  init(title: String, onPreferenceUpdated: @escaping (PrivacyLevel) -> Void) {
    _title = State<String>(initialValue: title)
    self.onPreferenceUpdated = onPreferenceUpdated
  }

  var body: some View {
    Menu(title) {
      Button(PrivacyLevel.closeFriend.title) {
        onPreferenceUpdated(PrivacyLevel.closeFriend)
        title = PrivacyLevel.closeFriend.title
      }
      Button(PrivacyLevel.friend.title) {
        onPreferenceUpdated(PrivacyLevel.friend)
        title = PrivacyLevel.friend.title
      }
      Button(PrivacyLevel.everyone.title) {
        onPreferenceUpdated(PrivacyLevel.everyone)
        title = PrivacyLevel.everyone.title
      }
    }
  }
}

struct UserPreferencesView_Previews: PreviewProvider {
  static var previews: some View {
    UserPreferencesView(store: PreferencesStore())
  }
}
