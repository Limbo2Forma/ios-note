/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2020C
  Assessment: Final Project
  Author: Team 1 
  Created  date: 01/01/2020 
  Last modified: 26/01/2020
  Acknowledgement: Acknowledge the resources that you use here. 
*/

import SwiftUI
import UIKit

struct SearchBar: UIViewRepresentable {

    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }
        
       /* Update the view. Besides, we are going to introduce another component in our SearchBar, a Coordinator.
         This Coordinator will conform to the UISearchBarDelegate protocol.
         Also, we need a new property to store all the changes received from this function  searchBar, every time the users changes his search. */
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    // The new SearchBar struct will wrap a UISearchBar, but it’s mandatory to implement two methods.
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search notes"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
