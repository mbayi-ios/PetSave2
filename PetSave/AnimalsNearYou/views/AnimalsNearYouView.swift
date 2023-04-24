
import SwiftUI

struct AnimalsNearYouView: View {
  private let requestManager = RequestManager()
  
  @State var animals: [Animal] = []
  @State var isLoading = true


  var body: some View {
    NavigationView {
      List {
        ForEach(animals) { animal in
          AnimalRow(animal: animal)
        }
      }
      .task {
        await fetchAnimals()
      }
      .listStyle(.plain)
      .navigationTitle("Animals near you")

      .overlay {
        if isLoading {
          ProgressView("Finding Animals Near you...")
        }
      }
    }.navigationViewStyle(StackNavigationViewStyle())
  }

  @MainActor
  func stopLoading() async {
    isLoading = false
  }

  func fetchAnimals() async {
    do {
      let animalsContainer: AnimalsContainer = try await requestManager.perform(AnimalsRequest.getAnimalsWith(page: 1, latitude: nil, longitude: nil))

      self.animals  = animalsContainer.animals
      await stopLoading()

    } catch {}
  }
}

struct AnimalsNearYouView_Previews: PreviewProvider {
  static var previews: some View {
    AnimalsNearYouView(animals: Animal.mock, isLoading: false)
  }
}
