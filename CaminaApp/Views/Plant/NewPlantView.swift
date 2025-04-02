import SwiftUI

struct NewPlantView: View {
    @State private var gardenName: String = ""
    @State private var gardenDescription: String = ""
    @State private var selectedType: String = "Germination"
    @State private var growthStage: String = "Germination"
    
    // Buttons
    @State private var showingLocationPicker = false
    @State private var showingInfoAlert = Array(repeating: false, count: 4)
    
    let options = ["Potato", "Tomato", "Bean"]
    @State private var selectedStage = "Select a stage"
    @State private var showingPlantTypeCarousel = false
        @State private var selectedPlantType = "Select a type"
    let stages = ["Sprout", "Seedling", "Vegetative", "Flowering", "Ripening"]
    
    var color = Color.primaryGreen.opacity(0.15)

    let growthStages = ["Germination", "Seed", "Sprout", "Plant"]
    let filtrations = ["Yes", "No"]

    var body: some View {
            Form {
                    Section(header:
                        HStack {
                        Text("My new plant's name will be...")
                                .foregroundColor(.primaryGreen)
                                .font(Font.custom("SF Pro Display", size: 13))
                        
                            Spacer()
                        
                            Button(action: {
                                showingInfoAlert[0] = true
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.primaryGreen)
                            }
                            .alert("Plant's name", isPresented: $showingInfoAlert[0]) {
                                Button("OK", role: .cancel) { }
                            }
                            message: {
                                Text("Enter the alias of the plant you're adding, such as 'Tomato' or 'Basil'.")
                            }
                            .textCase(nil)
                        })
                    {
                        TextField("Name", text: $gardenName)
                            .listRowBackground(color)
                    }
                    
                    Section(header:
                        HStack {
                        Text("My new plant's description will be...")
                                .foregroundColor(.primaryGreen)
                                .font(Font.custom("SF Pro Display", size: 13))
                        
                            Spacer()
                        
                            Button(action: {
                                showingInfoAlert[1] = true
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.primaryGreen)
                            }
                            .alert("Plant's description", isPresented: $showingInfoAlert[1]) {
                                Button("OK", role: .cancel) { }
                            }
                            message: {
                                Text("Provide a brief description or any specific details about the plant, like characteristics you want to save")
                            }
                            .textCase(nil)
                        })
                    {
                        TextField("Description", text: $gardenDescription)
                            .listRowBackground(color)
                    }
                    
                    Section(header:
                        HStack {
                            Text("Its current growth stage is...")
                                .foregroundColor(.primaryGreen)
                                .font(Font.custom("SF Pro Display", size: 13))
                        
                            Spacer()
                        
                            Button(action: {
                                showingInfoAlert[2] = true
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.primaryGreen)
                            }
                            .alert("Growth state", isPresented: $showingInfoAlert[2]) {
                                Button("OK", role: .cancel) { }
                            }
                            message: {
                                Text("Select the current growth stage of the plant. This helps in providing appropriate care.")
                            }
                            .textCase(nil)

                        })
                    {
                        Menu {
                            ForEach(stages, id: \.self) { stage in
                                    Button(action: {
                                        selectedStage = stage
                                    }) {
                                        Text(stage)
                                    }
                                }

                        } label: {
                            HStack {
                                Text(selectedStage)
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .foregroundColor(selectedStage != "Select a stage" ? .black : .gray.opacity(0.6))
                            .background(Color.primaryGreen.opacity(0.15))
                            .cornerRadius(8)
                            .padding(.horizontal, -20)
                            .padding(.top, -15)
                        }
                    }
                    
                    Section(header:
                        HStack {
                            Text("It will be a...")
                                .foregroundColor(.primaryGreen)
                                .font(Font.custom("SF Pro Display", size: 13))
                        
                            Spacer()
                        
                            Button(action: {
                                showingInfoAlert[3] = true
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.primaryGreen)
                            }
                            .alert("Type of plant", isPresented: $showingInfoAlert[3]) {
                                Button("OK", role: .cancel) { }
                            }
                            message: {
                                Text("Choose the type or species of the plant if known. This can be helpful for tracking and care instructions.")
                            }
                            .textCase(nil)

                        })
                    {
                        Button(action: {
                            self.showingPlantTypeCarousel.toggle()
                        }) {
                            HStack {
                                Text(selectedPlantType)
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .foregroundColor(selectedPlantType != "Select a type" ? .black : .gray.opacity(0.6))
                            .background(Color.primaryGreen.opacity(0.15))
                            .cornerRadius(8)
                            .padding(.horizontal, -20)
                            .padding(.top, -15)
                        }
                    }
                    .sheet(isPresented: $showingPlantTypeCarousel) {
                        PlantTypeCarouselView(plantType: $selectedPlantType, plants: plantLibrary, onClose: {
                            self.showingPlantTypeCarousel = false  // Esto cierra la hoja
                        })
                    }
                    
                    Section {
                        HStack {
                            Spacer()
                            Button("Add Plant") {
                                print("Plant added successfully")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.primaryGreen)
                            .cornerRadius(10)
                            Spacer()
                        }
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Add new plant")
        }
}

struct PlantTypeCarouselView: View {
    @Binding var plantType: String
    var plants: [Plant]
    var onClose: () -> Void

    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 20) {
                        // Filtrar para incluir solo "Tomato" y "Potato"
                        ForEach(plants.filter { $0.commonName == "Tomato" || $0.commonName == "Potato" }, id: \.scientificName) { plant in
                            PlantCardView(plant: plant)
                                .frame(width: 350, height: 500)
                                .onTapGesture {
                                    self.plantType = plant.commonName
                                    onClose() // Cierra la vista al seleccionar
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Select Plant Type")
        }
    }
}



struct NewPlantView_Previews: PreviewProvider {
    static var previews: some View {
        NewPlantView()
    }
}
