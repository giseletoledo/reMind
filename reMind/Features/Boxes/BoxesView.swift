import SwiftUI

struct BoxesView<ViewModel: BoxViewModellingProtocol>: View {
    private let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 140), spacing: 20),
        GridItem(.adaptive(minimum: 140), spacing: 20)
    ]
    
    @ObservedObject var viewModel: ViewModel
    @State private var isCreatingNewBox: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.boxes) { box in
                        BoxItemView(viewModel: viewModel, box: box)
                    }
                }
                .padding(40)
            }
            .padding(.horizontal, -20)
            .navigationTitle("Boxes")
            .background(reBackground())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isCreatingNewBox.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isCreatingNewBox) {
                // Passando viewModel como delegado diretamente
                BoxEditorView(viewModel: viewModel as! BoxViewModel,  // Forçando para BoxViewModel
                              name: "",
                              theme: 0,
                              delegate: viewModel as? BoxEditorDelegate) // Passando viewModel como delegado
            }
        }
    }
}

struct BoxItemView<ViewModel: BoxViewModellingProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    var box: Box

    var body: some View {
        HStack {
            NavigationLink(destination: BoxView(viewModel: viewModel as! BoxViewModel, box: box)) {
                BoxCardView(boxName: box.name ?? "Unknown",
                            numberOfTerms: box.numberOfTerms,
                            theme: box.theme)
                    .reBadge(viewModel.getNumberOfPendingTerms(of: box))
            }
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    viewModel.deleteBox(box)
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
    }
}



struct BoxesView_Previews: PreviewProvider {
    static let viewModel: BoxViewModel = {
        let box1 = Box(context: CoreDataStack.inMemory.managedContext)
        box1.name = "Box 1"
        box1.rawTheme = 0

        let term = Term(context: CoreDataStack.inMemory.managedContext)
        term.lastReview = Calendar.current.date(byAdding: .day, value: -5, to: Date())!
        box1.addToTerms(term)

        let box2 = Box(context: CoreDataStack.inMemory.managedContext)
        box2.name = "Box 2"
        box2.rawTheme = 1

        let box3 = Box(context: CoreDataStack.inMemory.managedContext)
        box3.name = "Box 3"
        box3.rawTheme = 2

        let viewModel = BoxViewModel()
        viewModel.boxes = [box1, box2, box3]
        return viewModel
    }()

    static var previews: some View {
        NavigationStack {
            BoxesView(viewModel: BoxesView_Previews.viewModel)
        }
    }
}
