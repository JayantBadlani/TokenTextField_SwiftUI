//
//  TokenFieldExampleView.swift
//  TokenFieldExample_SwiftUI
//
//  Created by MacBook Pro on 27/01/24.
//

import SwiftUI

struct TokenFieldExampleView: View {
    
    @FocusState private var tagFieldFocusState: Bool
    @State private var tags: [TokenModel] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("TokenField Example")
                .font(.title)
                .padding(.bottom, 20)
            
            Text("- Use ','  ';'  'SPACE' or Return button in keyboard to enter token")
                .font(.subheadline)
            Text("- Click any token to select it and backpress to delete it")
                .font(.subheadline)
                .padding(.bottom, 20)
            
            
            TokenTextField(tags: $tags)
                .focused($tagFieldFocusState)
            
            Spacer()
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

