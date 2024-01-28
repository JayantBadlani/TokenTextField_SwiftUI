//
//  TokenTextField.swift
//
//  Created by Jayant on 11/01/24.
//



import SwiftUI

struct TokenTextField: View {
    
    @Binding var tags: [TokenModel]
    @State var horizontalSpacingBetweenItem: CGFloat = 10
    @State var verticalSpacingBetweenItem: CGFloat = 15
    
    var body: some View {
        
        TokenLayout(alignment: .leading, horizontalSpacingBetweenItem: horizontalSpacingBetweenItem, verticalSpacingBetweenItem: verticalSpacingBetweenItem) {
            ForEach(tags.indices, id: \.self) { index in
                TagView(tag: $tags[index], allTags: $tags)
                    .onChange(of: tags[index].value) { newValue in
                        handleTagChange(index: index, newValue: newValue)
                    }
                    .onTapGesture {
                        handleTagTap(index: index)
                    }
                    .id(tags[index].convertedToToken)
            }
        }
        .padding(.all, 15)
        .background(Color.gray.opacity(0.08))
        .cornerRadius(5)
        .onTapGesture {
            updateSelectedTag()
        }
        .onAppear {
            handleInitialTag()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            handleKeyboardWillHide()
        }
    }
    
    private func updateSelectedTag() {
        // if !tags.isEmpty && tags.allSatisfy({ !$0.isSelected }) {
        if !tags.isEmpty {
            tags.indices.forEach { index in
                if tags[index].isSelected {
                    tags[index].isSelected = false
                }
            }
            if !tags[tags.indices.last!].convertedToToken  {
                tags[tags.indices.last!].isSelected = true
            }
            else {
                appendEmptyTag(isSelected: true)
            }
        }
    }
    
    private func handleTagChange(index: Int, newValue: String) {
        guard !newValue.isEmpty else {
            return
        }
        
        if let lastCharacter = newValue.last, ",; ".contains(lastCharacter) {
            tags[index].value.removeLast()
            if !tags[index].value.isEmpty {
                appendEmptyTag(isSelected: true)
            }
        }
    }
    
    
    private func handleInitialTag() {
        if tags.isEmpty {
            appendEmptyTag(isSelected: false)
        }
        else if let lastTag = tags.last, lastTag.convertedToToken {
            appendEmptyTag(isSelected: false)
        }
    }
    
    private func handleKeyboardWillHide() {
        if let lastTag = tags.last, !lastTag.value.isEmpty {
            appendEmptyTag(isSelected: true)
        }
    }
    
    private func appendEmptyTag(isSelected: Bool) {
        DispatchQueue.main.async {
            tags.indices.forEach { index in
                if !tags[index].convertedToToken && !(tags[index].value.isEmpty) {
                    tags[index].convertedToToken = true
                }
                if tags[index].isSelected {
                    tags[index].isSelected = false
                }
            }
            tags.append(TokenModel(value: "", isSelected: isSelected, convertedToToken: false))
        }
    }
    
    private func handleTagTap(index: Int) {
        tags.indices.forEach { tags[$0].isSelected = false }
        tags[index].isSelected = true
    }
}

struct TagView: View {
    
    @Binding var tag: TokenModel
    @Binding var allTags: [TokenModel]
    @FocusState private var isFocused: Bool
    @State private var isEditable: Bool = false
    
    var body: some View {
        BackSpaceListnerTextField(
            tag: $tag,
            onBackPressed: {
                handleBackspacePressed()
            },
            isEditable: $isEditable
        )
        .focused($isFocused)
        .padding(.vertical, 3)
        .padding(.horizontal, 5)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(isEditable ? Color.clear : (isFocused ? Color.accentColor : Color.gray.opacity(0.2)))
        }
        .frame(height: 21)
        .onTapGesture {
            handleTagTap()
        }
        .onChange(of: isFocused) { newValue in
            handleFocusChange()
        }
        .onChange(of: allTags) { newValue in
            handleTagFocusChange(newValue: newValue)
        }
        .onChange(of: tag.isSelected) { newValue in
            isEditable = !tag.convertedToToken
        }
        .onAppear() {
            isFocused = tag.isSelected
            isEditable = !tag.convertedToToken
        }
    }
    
    private func handleTagTap() {
        allTags.indices.forEach { allTags[$0].isSelected = false }
        tag.isSelected = true
        isFocused = tag.isSelected
    }
    
    
    private func handleBackspacePressed() {
        DispatchQueue.main.async {
            if let selectedTagIndex = allTags.firstIndex(where: { $0.isSelected }),
               allTags.count > 0 {
                if tag.value.isEmpty || (tag.isSelected && tag.convertedToToken) {
                    allTags.remove(at: selectedTagIndex)
                    
                    if !allTags.isEmpty {
                        allTags[allTags.indices.last!].isSelected = true
                    }
                }
            }
            
            if allTags.isEmpty {
                appendEmptyTag(isSelected: true)
                isEditable = true
            }
        }
    }
    
    private func appendEmptyTag(isSelected: Bool) {
        DispatchQueue.main.async {
            allTags.indices.forEach { index in
                if !allTags[index].convertedToToken && !(allTags[index].value.isEmpty) {
                    allTags[index].convertedToToken = true
                }
                if allTags[index].isSelected {
                    allTags[index].isSelected = false
                }
            }
            allTags.append(TokenModel(value: "", isSelected: isSelected, convertedToToken: false))
        }
    }
    
    private func handleFocusChange() {
        tag.isSelected = isFocused
        
        if allTags.allSatisfy({ !$0.isSelected }), let lastTag = allTags.last, lastTag.convertedToToken == true {
            appendEmptyTag(isSelected: false)
        }
        else if allTags.allSatisfy({ !$0.isSelected }), let lastTag = allTags.last, lastTag.convertedToToken == false, !lastTag.value.isEmpty {
            allTags[allTags.indices.last!].convertedToToken = true
        }
    }
    
    private func handleTagFocusChange(newValue: [TokenModel]) {
        if newValue.last?.id == tag.id && (newValue.last?.isSelected ?? false) && !isFocused {
            isFocused = true
        }
    }
}

struct BackSpaceListnerTextField: UIViewRepresentable {
    
    @Binding var tag: TokenModel
    var onBackPressed: () -> ()
    @Binding var isEditable: Bool
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $tag.value, isEditable: $isEditable, onBackPressed: onBackPressed)
    }
    
    func makeUIView(context: Context) -> CustomTextField {
        let textField = CustomTextField()
        textField.delegate = context.coordinator
        textField.onBackPressed = onBackPressed
        textField.keyboardType = .emailAddress
        textField.placeholder = "     "
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .words
        textField.backgroundColor = .clear
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textChange(textField:)), for: .editingChanged)
        return textField
    }
    
    func updateUIView(_ uiView: CustomTextField, context: Context) {
        
        if (uiView.text?.count ?? 0) > 0 {
            uiView.placeholder = ""
        }
        else {
            uiView.placeholder = "     " // to initially give width to textfield
        }
        
        if !isEditable {
            uiView.text = tag.value
            uiView.tintColor = tag.isSelected ? .clear : .tintColor
            uiView.textColor = tag.isSelected ? .white : .black
        } else {
            uiView.text = tag.value
            uiView.tintColor = .tintColor
            uiView.textColor = .black
        }
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: CustomTextField, context: Context) -> CGSize? {
        return uiView.intrinsicContentSize
    }
    
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        @Binding var isEditable: Bool
        var onBackPressed: () -> ()
        
        init(text: Binding<String>, isEditable: Binding<Bool>, onBackPressed: @escaping () -> ()) {
            self._text = text
            self._isEditable = isEditable
            self.onBackPressed = onBackPressed
        }
        
        @objc func textChange(textField: UITextField) {
            DispatchQueue.main.async { [weak self] in
                self?.text = textField.text ?? ""
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if !isEditable {
                if string.isEmpty {
                    onBackPressed()
                    return false
                } else {
                    return false
                }
            }
            return true
        }
    }
    
    class CustomTextField: UITextField {
        
        open var onBackPressed: (() -> ())?
        var isEditable: Bool = true
        
        override func deleteBackward() {
            if isEditable {
                super.deleteBackward()
                onBackPressed?()
            } else {
                // Handle deletion of the entire tag
                onBackPressed?()
            }
        }
        
        override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            return false
        }
    }
}


struct demoTags: View {
    @State private var tags: [TokenModel] = []
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                TokenTextField(tags: $tags)
            }
        }
    }
}

struct TagField_Previews: PreviewProvider {
    static var previews: some View {
        demoTags()
    }
}
