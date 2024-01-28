# TokenTextField / TagTextField in SwiftUI

### TokenTextField is a SwiftUI component that facilitates the creation of a token field, allowing users to convert text into easily selectable and manipulable tokens, similar to the iOS Mail app.

https://github.com/JayantBadlani/TokenTextField_SwiftUI/assets/37996543/1ec51584-435a-4ed9-b47e-ac0ee055e3c2

## Installation
To use Tinder Card Swiper in your project, simply copy the ##TokenTextField_SupportFiles## files folder into your project's source code. You can then import the TokenTextField class into any SwiftUI view where you want to use it.

### Usage
To use Tinder Card Swiper, you'll first need to create a array of tokens that you want to display. Each token should be represented as a token view, and can contain any type of text content you like.

Once you have your array of tokens, you can create a TokenTextField View in your View and pass tokens as a parameter:

```ruby
import SwiftUI

struct TokenFieldExampleView: View {
    
    @FocusState private var tagFieldFocusState: Bool
    @State private var tags: [TokenModel] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("TokenField Example")
                .font(.title)
                .padding(.bottom, 20)
            
            TokenTextField(tags: $tags)
                .focused($tagFieldFocusState)
        }
        .padding(.all, 40)
        .onAppear {
            tagFieldFocusState = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TokenFieldExampleView()
    }
}

```

### Features
-Support iOS 15+
-Multiline Token TextField
-Customizable UI

```ruby

//TokenTextField provides customization options for tailoring the appearance and behavior of your token field. Customize the UI and explore additional features as needed for your specific use case.
horizontalSpacingBetweenItem: CGFloat = 10
verticalSpacingBetweenItem: CGFloat = 15

```

You can also customize the appearance of your Token field and tokens by applying any SwiftUI modifiers that you like.

### Conclusion
TokenTextField simplifies the implementation of token fields in SwiftUI, offering a user-friendly interface for text-to-token conversion. Explore the features, customize the UI, and enhance your app's user experience with this versatile component..
