//
//  FormComponents.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 27/03/25.
//

import SwiftUI

// Validated text field with error display
struct ValidatedTextField: View {
    var title: String
    @Binding var text: String
    var error: String
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: UITextAutocapitalizationType = .sentences
    var onChange: ((String) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField(title, text: $text)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(error.isEmpty ? Color.clear : Color.red, lineWidth: 1)
                )
                .onChange(of: text) { newValue in
                    onChange?(newValue)
                }
                .keyboardType(keyboardType)
                .autocapitalization(autocapitalization)

            if !error.isEmpty {
                Text(error)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding(.horizontal, 4)
            }
        }
    }
}

// Dropdown selector with validation
struct DropdownSelector: View {
    var title: String
    @Binding var selection: String
    var options: [String]
    var error: String
    @Binding var isExpanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selection.isEmpty ? title : selection)
                        .foregroundColor(selection.isEmpty ? .gray : .black)
                        .padding()

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                        .padding(.trailing)
                }
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(error.isEmpty ? Color.clear : Color.red, lineWidth: 1)
                )
            }

            if !error.isEmpty {
                Text(error)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding(.horizontal, 4)
            }

            if isExpanded {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                selection = option
                                isExpanded = false
                            }) {
                                Text(option)
                                    .foregroundColor(.black)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(selection == option ? Color.blue.opacity(0.1) : Color.white)
                            }
                            Divider()
                        }
                    }
                }
                .frame(height: min(CGFloat(options.count) * 44, 200))
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 2)
                .zIndex(1)
            }
        }
    }
}

// Multi-selection dropdown with chips
struct MultiSelectionDropdown: View {
    var title: String
    @Binding var selectedItems: [String]
    var options: [String]
    var error: String
    @Binding var isExpanded: Bool
    @State private var searchText = ""

    var filteredOptions: [String] {
        if searchText.isEmpty {
            return options
        } else {
            return options.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    if selectedItems.isEmpty {
                        Text(title)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        Text("\(selectedItems.count) selected")
                            .foregroundColor(.black)
                            .padding()
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                        .padding(.trailing)
                }
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(error.isEmpty ? Color.clear : Color.red, lineWidth: 1)
                )
            }

            if !selectedItems.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(selectedItems, id: \.self) { item in
                            HStack(spacing: 4) {
                                Text(item)
                                    .font(.footnote)
                                    .padding(.leading, 8)

                                Button(action: {
                                    if let index = selectedItems.firstIndex(of: item) {
                                        selectedItems.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                                .padding(4)
                            }
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(16)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            if !error.isEmpty {
                Text(error)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding(.horizontal, 4)
            }

            if isExpanded {
                VStack {
                    TextField("Search", text: $searchText)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(filteredOptions, id: \.self) { option in
                                Button(action: {
                                    if selectedItems.contains(option) {
                                        selectedItems.removeAll { $0 == option }
                                    } else {
                                        selectedItems.append(option)
                                    }
                                }) {
                                    HStack {
                                        Text(option)
                                            .foregroundColor(.black)

                                        Spacer()

                                        if selectedItems.contains(option) {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .padding()
                                    .background(selectedItems.contains(option) ? Color.blue.opacity(0.1) : Color.white)
                                }
                                Divider()
                            }
                        }
                    }
                    .frame(height: min(CGFloat(filteredOptions.count) * 44, 200))
                }
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 2)
                .zIndex(1)
            }
        }
    }
}
