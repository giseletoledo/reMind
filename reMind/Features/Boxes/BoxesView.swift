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
                if let boxViewModel = viewModel as? BoxViewModel {
                    BoxEditorView(
                        viewModel: boxViewModel,
                        name: "",
                        keywords: "",
                        description: "",
                        theme: 0,
                        delegate: viewModel as? BoxEditorDelegate
                    )
                } else {
                    Text("Erro: ViewModel inválido.")
                }
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
    static var previews: some View {
        let viewModel = BoxViewModel()

        // Criando caixas de exemplo usando o método unificado de adicionar
        viewModel.addBox(
            name: "Box 1",
            keywords: "Sample, Keywords",
            description: "A description for Box 1",
            theme: 0
        )

        let term1 = Term(context: CoreDataStack.inMemory.managedContext)
        term1.value = "Sample Term 1"
        term1.lastReview = Calendar.current.date(byAdding: .day, value: -5, to: Date())

        // Adicionando o termo diretamente ao contexto, se necessário
        if let firstBox = viewModel.boxes.first {
            firstBox.addToTerms(term1)
        }

        viewModel.addBox(
            name: "Box 2",
            keywords: "Another, Set",
            description: "A description for Box 2",
            theme: 1
        )
        
        viewModel.addBox(
            name: "Box 3",
            keywords: "Third, Example",
            description: "A description for Box 3",
            theme: 2
        )

        return NavigationStack {
            BoxesView(viewModel: viewModel)
        }
    }
}

