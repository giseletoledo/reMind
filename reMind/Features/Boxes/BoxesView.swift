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
                        identifier: nil,
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
        ZStack(alignment: .topTrailing) { // Usar ZStack para sobrepor elementos
            NavigationLink(destination: BoxView(viewModel: viewModel as! BoxViewModel, box: box)) {
                BoxCardView(boxName: box.name ?? "Unknown",
                            numberOfTerms: box.numberOfTerms,
                            theme: box.theme)
                .reBadge("\(viewModel.getNumberOfPendingTerms(of: box).count)") 
            }
            
            // Botão de lixeira posicionado no canto superior direito do card
            Button(action: {
                viewModel.deleteBox(box)
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.red)
                    .clipShape(Circle()) // Deixa o botão redondo
                    .shadow(radius: 1)
            }
            .offset(x: -10, y: 10) // Ajusta o posicionamento do botão
        }
        .padding(5) // Espaço entre os elementos
    }
}

  



