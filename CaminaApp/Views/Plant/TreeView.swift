import SwiftUI

struct TreeView: View {
    var tree: Tree
    
    var body: some View {
        ScrollView{
            Text("Tree view")
        }
        .navigationTitle(tree.alias)
    }
}

/*
 #Preview {
 TreeView()
 }
*/
