import SwiftUI

struct PlantStageDetailView: View {
    var stage: PlantStage

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(stage.stageName.rawValue)
                    .font(.title)
                Image("tip")
                    .resizable()
                    .scaledToFit()
                Text("Duration: \(stage.duration)")
                Text("Description: \(stage.description)")
                Text("Water Requirement: \(stage.waterRequirement)")
                // Agrega más detalles según necesites mostrar
            }
            .padding()
        }
        .navigationBarTitle(Text(stage.stageName.rawValue), displayMode: .inline)
    }
}

struct PlantStagesView: View {
    let stages: [PlantStage]

    var body: some View {
        List(stages, id: \.id) { stage in
            NavigationLink(destination: PlantStageDetailView(stage: stage)) {
                Text(stage.stageName.rawValue)
            }
        }
        .navigationBarTitle("Tomato Stages", displayMode: .inline)
    }
}

struct TomatoStageDetailView: View {
    let stages = TomatoStagesData.tomatoStages // Asegúrate de que esta variable tiene los datos necesarios
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(Array(stages.enumerated()), id: \.element.id) { (index, stage) in
                    VStack {
                        ScrollView(.vertical, showsIndicators: true) {
                            VStack(alignment: .leading, spacing: 5) {
                                // Todo tu contenido actual
                                Image("tomatoStage\(index)")
                                    .resizable()
                                    .frame(height: 200)
                                    .cornerRadius(12)
                                    .padding(.bottom, 10)
                                
                                Text(stage.stageName.rawValue)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Duration:")
                                        .font(
                                            Font.custom("SF Pro Display", size: 14)
                                                .weight(.semibold)
                                                .italic()
                                        )
                                        .foregroundColor(.primaryGreen)
                                    
                                    Text("\(stage.duration)")
                                        .font(Font.custom("SF Pro Display", size: 11))
                                        .foregroundColor(.black)
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(red: 0.38, green: 0.42, blue: 0.22).opacity(0.15))
                                .cornerRadius(12)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Description:")
                                        .font(
                                            Font.custom("SF Pro Display", size: 14)
                                                .weight(.semibold)
                                                .italic()
                                        )
                                        .foregroundColor(.primaryGreen)
                                    
                                    Text("\(stage.description)")
                                        .font(Font.custom("SF Pro Display", size: 11))
                                        .foregroundColor(.black)
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(red: 0.38, green: 0.42, blue: 0.22).opacity(0.15))
                                .cornerRadius(12)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Water Requirement:")
                                        .font(
                                            Font.custom("SF Pro Display", size: 14)
                                                .weight(.semibold)
                                                .italic()
                                        )
                                        .foregroundColor(.primaryGreen)
                                    
                                    Text("\(stage.waterRequirement)")
                                        .font(Font.custom("SF Pro Display", size: 11))
                                        .foregroundColor(.black)
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(red: 0.38, green: 0.42, blue: 0.22).opacity(0.15))
                                .cornerRadius(12)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Sunlight Requirement:")
                                        .font(
                                            Font.custom("SF Pro Display", size: 14)
                                                .weight(.semibold)
                                                .italic()
                                        )
                                        .foregroundColor(.primaryGreen)
                                    
                                    if stage.sunlightRequirement.1 == 0{
                                        Text("0 hours")
                                            .font(Font.custom("SF Pro Display", size: 11))
                                            .foregroundColor(.black)
                                    }
                                    else{
                                        Text("\(Int(stage.sunlightRequirement.0.rounded())) to \(Int(stage.sunlightRequirement.1.rounded())) hours")
                                            .font(Font.custom("SF Pro Display", size: 11))
                                            .foregroundColor(.black)
                                    }
                                    
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(red: 0.38, green: 0.42, blue: 0.22).opacity(0.15))
                                .cornerRadius(12)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Soil Composition:")
                                        .font(
                                            Font.custom("SF Pro Display", size: 14)
                                                .weight(.semibold)
                                                .italic()
                                        )
                                        .foregroundColor(.primaryGreen)
                                    
                                    Text("\(stage.soilComposition)")
                                        .font(Font.custom("SF Pro Display", size: 11))
                                        .foregroundColor(.black)
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(red: 0.38, green: 0.42, blue: 0.22).opacity(0.15))
                                .cornerRadius(12)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Volume:")
                                        .font(
                                            Font.custom("SF Pro Display", size: 14)
                                                .weight(.semibold)
                                                .italic()
                                        )
                                        .foregroundColor(.primaryGreen)
                                    
                                    Text("\(Int(stage.volume.rounded()))L")
                                        .font(Font.custom("SF Pro Display", size: 11))
                                        .foregroundColor(.black)
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(red: 0.38, green: 0.42, blue: 0.22).opacity(0.15))
                                .cornerRadius(12)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Draining Requirement:")
                                        .font(
                                            Font.custom("SF Pro Display", size: 14)
                                                .weight(.semibold)
                                                .italic()
                                        )
                                        .foregroundColor(.primaryGreen)
                                    
                                    Text("\(stage.drainingRequirement ? "Yes" : "No")")
                                        .font(Font.custom("SF Pro Display", size: 11))
                                        .foregroundColor(.black)
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(red: 0.38, green: 0.42, blue: 0.22).opacity(0.15))
                                .cornerRadius(12)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Temperature Range:")
                                        .font(
                                            Font.custom("SF Pro Display", size: 14)
                                                .weight(.semibold)
                                                .italic()
                                        )
                                        .foregroundColor(.primaryGreen)
                                    
                                    if let tempRange = stage.temperatureRange {
                                        Text("\(Int(tempRange.0))°C to \(Int(tempRange.1))°C")
                                            .font(Font.custom("SF Pro Display", size: 11))
                                            .foregroundColor(.black)
                                    }
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(red: 0.38, green: 0.42, blue: 0.22).opacity(0.15))
                                .cornerRadius(12)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Root Depth:")
                                        .font(
                                            Font.custom("SF Pro Display", size: 14)
                                                .weight(.semibold)
                                                .italic()
                                        )
                                        .foregroundColor(.primaryGreen)
                    
                                    Text("\(Int(stage.rootDepth))cm")
                                        .font(Font.custom("SF Pro Display", size: 11))
                                        .foregroundColor(.black)
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(red: 0.38, green: 0.42, blue: 0.22).opacity(0.15))
                                .cornerRadius(12)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Spacing:")
                                        .font(
                                            Font.custom("SF Pro Display", size: 14)
                                                .weight(.semibold)
                                                .italic()
                                        )
                                        .foregroundColor(.primaryGreen)
                    
                                    Text("\(Int(stage.spacing))cm")
                                        .font(Font.custom("SF Pro Display", size: 11))
                                        .foregroundColor(.black)
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(red: 0.38, green: 0.42, blue: 0.22).opacity(0.15))
                                .cornerRadius(12)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Notes:")
                                        .font(
                                            Font.custom("SF Pro Display", size: 14)
                                                .weight(.semibold)
                                                .italic()
                                        )
                                        .foregroundColor(.primaryGreen)
                    
                                    Text("\(stage.notes)")
                                        .font(Font.custom("SF Pro Display", size: 11))
                                        .foregroundColor(.black)
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(red: 0.38, green: 0.42, blue: 0.22).opacity(0.15))
                                .cornerRadius(12)
                            }
                        }
                        .padding(15)
                        .padding(.horizontal, -10)
                        .frame(width: 300, height: 650)
                        .clipped()
                    }
                    .padding()
                    .frame(width: 320, height: 650)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                }
            }
            .padding()
        }
    }
}



struct TomatoStageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TomatoStageDetailView()
    }
}
