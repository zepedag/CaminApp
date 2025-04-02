import SwiftUI

struct ActivityDetailView: View {
    var activity: PlantActivity

    var body: some View {
        // Customize this view to display the details of the activity
        VStack {
            Text("Activity Details")
                .font(.title)

            Divider()

            Text("Date: \(activity.date, formatter: itemFormatter)")
            Text("Watered: \(activity.watered ? "Yes" : "No")")
            Text("Sun Exposure: \(activity.sunExposure ? "Yes" : "No")")
            // Include image if available
            if let image = activity.dayImage {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                Text("No Image Available")
            }
        }
        .padding()
    }
}

// Helper to format the date
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()


struct DayBubble: View {
    @State private var showingDayDetail = false
    var date: Date
    var activities: [PlantActivity]

    var body: some View {
        let dailyActivity = activities.first { $0.date == date }

        VStack {
            Text(dayAbbreviation(date))
                .font(.caption)
                .padding(.top, 2)

            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .foregroundColor((dailyActivity?.watered == true || dailyActivity?.sunExposure == true) ? .clear : Color.gray.opacity(0.2))
                    .frame(width: 50, height: 100)

                HStack(spacing: 0) {
                    if dailyActivity?.watered == true {
                        Circle()
                            .foregroundColor(.blue)
                            .frame(width: dailyActivity?.sunExposure == true ? 15 : 30, height: 30)
                    }
                    if dailyActivity?.sunExposure == true {
                        Circle()
                            .foregroundColor(.yellow)
                            .frame(width: dailyActivity?.watered == true ? 15 : 30, height: 30)
                    }
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.gray, lineWidth: 0)
            )
        }
        .onTapGesture {
            showingDayDetail = true
        }
        .sheet(isPresented: $showingDayDetail) {
                    if let activity = dailyActivity {
                        ActivityDetailView(activity: activity)
                    } else {
                        Text("No activity for this day")
                    }
                }
    }
    
    private func dayAbbreviation(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEE"
        return dateFormatter.string(from: date)
    }
}



struct PlantView: View {
    @State private var showingDetail = false
    @State private var isShowingEdit = false
    @State private var selectedDate = Date()
    
    var myPlant = MyPlant(
        myPlant: Tomato,
        dayOfCreation:  Date() - 30 * 24 * 60 * 60,
        myPlantActivity: generateTomatoActivities(start: Date() - 30 * 24 * 60 * 60)
    )
    
           
    private let calendar = Calendar.current
    
    var plant: Plant
    private var daysInMonth: [Date] {
            guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else {
                return []
            }
            return calendar.generateDays(for: monthInterval)
        }
    

    var body: some View {
        VStack {
            NavigationLink(destination: EditPlantView(), isActive: $isShowingEdit) { EmptyView() }
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        Image(systemName: "leaf")
                            .font(Font.custom("SF Pro Display", size: 80).weight(.bold))
                            .foregroundColor(Color.primaryGreen)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .contentShape(Rectangle())
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 200)
            
            
            Button("Show plant information") {
                showingDetail = true
            }
            .sheet(isPresented: $showingDetail) {
                PlantInformationView(plant: plant)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(daysInMonth, id: \.self) { date in
                        DayBubble(date: date,  activities: myPlant.myPlantActivity)
                    }
                }
                .padding()
            }
            /*
            GeometryReader { geometry in
                VStack {
                    ScrollView {
                        /*
                        VStack {
                            DatePicker("Seleccionar fecha", selection: $selectedDate, displayedComponents: .date)
                                            .datePickerStyle(GraphicalDatePickerStyle()) // Estilo gráfico para el selector de fecha
                                            .padding()
                            // .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                        }*/
                    }
                    .background(Color.cream)
                    .clipShape(RoundedTopCorners(radius: 20))
                    .overlay(
                        RoundedTopCorners(radius: 20)
                            .stroke(Color.primaryGreen, lineWidth: 3)
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(.horizontal)
            }
             */
        }
        .navigationBarItems(trailing: Button(action: {
            isShowingEdit = true
        }) {
            Image(systemName: "pencil")
        })
        .navigationBarTitle(plant.alias, displayMode: .inline)
        .accentColor(.primaryGreen)
    }
}

struct RoundedTopCorners: Shape {
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct PlantInformationView: View {
    var plant: Plant

    var body: some View {
        VStack {
            Image(systemName: "leaf.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.primaryGreen)
            
            Text(plant.commonName)
                .font(.title)
            
            Text("General description")
            // TODO: Call the info description of the plant view
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.cream.edgesIgnoringSafeArea(.all)) // Usa Color.cream para el fondo
        .accentColor(.primaryGreen)
    }
    private func formattedDate(_ date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: date)
        }
        
        private func dayAbbreviation(_ date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EE"
            return dateFormatter.string(from: date).uppercased()
        }
    
}


struct DayIndicator: View {
    var date: Date
    var isSelected: Bool
    @Binding var activities: [PlantActivity]
    private let calendar = Calendar.current
    
    var body: some View {
        let isWatered = activities.contains(where: { $0.date == date && $0.watered })
        let isSunExposed = activities.contains(where: { $0.date == date && $0.sunExposure })
        
        return Text(calendar.isDateInToday(date) ? "T" : String(calendar.component(.day, from: date)))
            .padding(8)
            .background(isSelected ? Color.blue : (isWatered || isSunExposed ? Color.green : Color.gray.opacity(0.3)))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: isSelected ? 2 : 0)
            )
            .onTapGesture {
                // Actions when tapping the day indicator
            }
    }
}

// Helper extension to generate days in a month
extension Calendar {
    func generateDays(for interval: DateInterval) -> [Date] {
        var days: [Date] = []
        var date = interval.start
        
        while date <= interval.end {
            days.append(date)
            date = self.date(byAdding: .day, value: 1, to: date)!
        }
        
        return days
    }
}


struct PlantView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Intenta generar una vista de planta si es posible
            if let exampleGarden = generateExampleUsers().first?.gardens.first, let plant = exampleGarden.plants.first {
                PlantView(plant: plant.myPlant)
                    .previewLayout(.sizeThatFits)
                    .padding()
                    .previewDisplayName("Plant View")
            } else {
                // Muestra un mensaje si no hay plantas disponibles
                Text("No plant available")
                    .previewLayout(.sizeThatFits)
                    .padding()
                    .previewDisplayName("No Plant")
            }
        }
    }
}


