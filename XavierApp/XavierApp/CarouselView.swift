//
//  CarouselView.swift
//  codeTutorial_carousel
//
//  Created by Christopher Guirguis on 3/17/20.
//  Copyright © 2020 Christopher Guirguis. All rights reserved.
//

import SwiftUI
import WebKit
import SwiftSoup

struct CarouselView: View {
    @ObservedObject var userSettings = UserSettings()

    @GestureState private var dragState = DragState.inactive
    @State var carouselLocation = 0

    var itemHeight: CGFloat
    var views: [AnyView]

    private func onDragEnded(drag: DragGesture.Value) {
        print("drag ended")
        let dragThreshold: CGFloat = 200
        if drag.predictedEndTranslation.width > dragThreshold || drag.translation.width > dragThreshold {
            carouselLocation = carouselLocation - 1
        } else if drag.predictedEndTranslation.width < (-1 * dragThreshold) || drag.translation.width < (-1 * dragThreshold) {
            carouselLocation = carouselLocation + 1
        }
    }

    var body: some View {

        // This vstack conttains buttons within an hstack,

        VStack {
            // Below is HStack with tthe menu and warning buttons.

                ZStack {
                //Text
                GeometryReader { gr in
                    ZStack {
                        HStack {

                            //Calendar Card
                            if (relativeLoc() + 1) % 3 == 0 {

                                VStack(alignment: .leading){

                                Text(getDate())
                                    .font(.system(size: 35, weight: .medium))
                                    .foregroundColor(.white)
                                    

                                }.offset(x: -gr.size.width/15 ,y:0)

                            }

                            //Lunch Card
                            if (relativeLoc() + 1) % 3 == 1 {
                                VStack(alignment: .leading){

                                Text(welcomeText())
                                    .font(.system(size: 35, weight: .medium))
                                    .foregroundColor(.white)
                                    

                                }.offset(x: -gr.size.width/30 ,y:0)

                            }

                            //Schedule Card
                            if (relativeLoc() + 1) % 3 == 2 {

//                                Text("")
//                                    .padding(180)

                                VStack{

                                Text(getLetterDay())
                                    .font(.system(size: 40, weight: .medium))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    

                                }

                            }
                        }

                        .frame(height: gr.size.height/2)
                    }
                    // .background(Color.red)

                        .frame(width: gr.size.width, height: gr.size.height/2)

                }
            }

            // MARK: HERE

            VStack {
                ZStack {
                    ForEach(0 ..< views.count) { i in
                        GeometryReader { gr in
                            VStack {

                                self.views[i]
                                    // Text("\(i)")

                                    .frame(width: 300, height: self.getHeight(i))
                                    .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 3)

                                    .opacity(self.getOpacity(i))
                                    .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                                    .offset(x: self.getOffset(i))
                                    .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))

                            }.frame(width: gr.size.width, height: gr.size.height)
                        }
                    }

                }.gesture(
                    DragGesture()
                        .updating($dragState) { drag, state, _ in
                            state = .dragging(translation: drag.translation)
                        }
                        .onEnded(onDragEnded)
                )

            }.zIndex(-100)

            // PageIndicators
            GeometryReader { geo in
                VStack {

                    HStack(alignment: .center) {
                        // 1st Circle
                        if (relativeLoc() + 1) % 3 == 0 {
                            Circle()
                                .fill(Color("Blue"))
                                .frame(width: geo.size.width / 40, height: geo.size.height / 10)
                        } else {
                            Circle()
                                .stroke()
                                .fill(Color.gray)
                                .frame(width: geo.size.width / 40, height: geo.size.height / 10)
                        }
                        // 2nd Circle
                        if (relativeLoc() + 1) % 3 == 1 {
                            Circle()
                                .fill(Color("Blue"))
                                .frame(width: geo.size.width / 40, height: geo.size.height / 10)
                        } else {
                            Circle()
                                .stroke()
                                .fill(Color.gray)
                                .frame(width: geo.size.width / 40, height: geo.size.height / 10)
                        }
                        // 3rd Circle
                        if (relativeLoc() + 1) % 3 == 2 {
                            Circle()
                                .fill(Color("Blue"))
                                .frame(width: geo.size.width / 40, height: geo.size.height / 10)
                        } else {
                            Circle()
                                .stroke()
                                .fill(Color.gray)
                                .frame(width: geo.size.width / 40, height: geo.size.height / 10)
                        }

                        // Text("\(page)")
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
            }.zIndex(-100)
        }

    }

    // Text Functions
    func getDate() -> String {
        // Declares variables for repetitive use
        let date = Date()
        let calendar = Calendar.current

        // Month integer number
        let month = calendar.component(.month, from: date)
        // Day of the Month
        
        let dayOfMonth = calendar.component(.day, from: date)
        // Weekday integer number
        let weekday = calendar.component(.weekday, from: date)
        // Year
        let year = calendar.component(.year, from: date)

        // Declaration of the monthWord and dayWord used in return statement
        var monthWord = ""
        var dayWord = ""

        // Arrays of Months and Weekdays
        let monthsArray = ["Jan.", "Feb.", "March", "April", "May", "June", "July", "Aug.", "Sept.", "Oct.", "Nov.", "Dec."]
        let daysArray = ["Sunday,", "Monday,", "Tuesday,", "Wednesday,", "Thursday,", "Friday,", "Saturday,"]

        // Month in string form
        monthWord = monthsArray[month - 1]
        // Day in string form
        dayWord = daysArray[weekday - 1]

        // suffix for the ending of the day of the month
        var suffix = ""

        if dayOfMonth == 1 {
            suffix = "st"
        } else if dayOfMonth == 2 {
            suffix = "nd"
        } else if dayOfMonth == 3 {
            suffix = "rd"
        } else {
            suffix = "th"
        }

        return "\(dayWord) \n\(monthWord) \(dayOfMonth)\(suffix) \(year)"
    }

    func getLetterDay() -> String {
        // Webscraping by TJ
        //F*** Xavier for removing the days from website. I guess it has to be done manually now until they can get their stuff together. Annoying. TODO: Database for live changes?
        let daysOrder = ["H\nDay","I\nDay","J\nDay","G\nDay","No\nClasses","No\nClasses","No\nClasses", "H\nDay","I\nDay","J\nDay","G\nDay", "H\nDay","I\nDay","J\nDay","G\nDay","H\nDay","No\nClasses","No\nClasses","No\nClasses","No\nClasses","No\nClasses","No\nClasses","No\nClasses","No\nClasses","No\nClasses", "I\nDay","J\nDay","G\nDay", "H\nDay","I\nDay", "No\nClasses","No\nClasses"]
        let date = Date()
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: date)
        
        return daysOrder[dayOfMonth-1]
    }

    func welcomeText() -> String {
        let name = userSettings.name
        let hour = Calendar.current.component(.hour, from: Date())
        var greeting = ""
        if hour < 12 {
            greeting = "Good Morning,"
        } else if hour < 18 {
            greeting = "Good Afternoon,"
        } else {
            greeting = "Good Evening,"
        }
        return " \(greeting) \n \(name)."
    }

    func relativeLoc() -> Int {
        return ((views.count * 10000) + carouselLocation) % views.count
    }

    func getHeight(_ i: Int) -> CGFloat {
        if i == relativeLoc() {
            return itemHeight
        } else {
            return itemHeight - 100
        }
    }

    func getOpacity(_ i: Int) -> Double {
        if i == relativeLoc()
            || i + 1 == relativeLoc()
            || i - 1 == relativeLoc()
            || i + 2 == relativeLoc()
            || i - 2 == relativeLoc()
            || (i + 1) - views.count == relativeLoc()
            || (i - 1) + views.count == relativeLoc()
            || (i + 2) - views.count == relativeLoc()
            || (i - 2) + views.count == relativeLoc() {
            return 1
        } else {
            return 0
        }
    }

    func getOffset(_ i: Int) -> CGFloat {
        // This sets up the central offset
        if i == relativeLoc() {
            // Set offset of cental
            return dragState.translation.width
        }
        // These set up the offset +/- 1
        else if
            i == relativeLoc() + 1
            ||
            (relativeLoc() == views.count - 1 && i == 0) {
            // Set offset +1
            return dragState.translation.width + (300 + 20)
        } else if
            i == relativeLoc() - 1
            ||
            (relativeLoc() == 0 && i == views.count - 1) {
            // Set offset -1
            return dragState.translation.width - (300 + 20)
        }
        // These set up the offset +/- 2
        else if
            i == relativeLoc() + 2
            ||
            (relativeLoc() == views.count - 1 && i == 1)
            ||
            (relativeLoc() == views.count - 2 && i == 0) {
            return dragState.translation.width + (2 * (300 + 20))
        } else if
            i == relativeLoc() - 2
            ||
            (relativeLoc() == 1 && i == views.count - 1)
            ||
            (relativeLoc() == 0 && i == views.count - 2) {
            // Set offset -2
            return dragState.translation.width - (2 * (300 + 20))
        }
        // These set up the offset +/- 3
        else if
            i == relativeLoc() + 3
            ||
            (relativeLoc() == views.count - 1 && i == 2)
            ||
            (relativeLoc() == views.count - 2 && i == 1)
            ||
            (relativeLoc() == views.count - 3 && i == 0) {
            return dragState.translation.width + (3 * (300 + 20))
        } else if
            i == relativeLoc() - 3
            ||
            (relativeLoc() == 2 && i == views.count - 1)
            ||
            (relativeLoc() == 1 && i == views.count - 2)
            ||
            (relativeLoc() == 0 && i == views.count - 3) {
            // Set offset -2
            return dragState.translation.width - (3 * (300 + 20))
        }
        // This is the remainder
        else {
            return 10000
        }
    }
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)

    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case let .dragging(translation):
            return translation
        }
    }

    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
