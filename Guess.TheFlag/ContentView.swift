//
//  ContentView.swift
//  Guess.TheFlag
//
//  Created by Joshua Rosado Olivencia on 9/3/24.
//

// Guess.TheFlag
// 2 labels, showing the user what to do
// 3 flags, showing the user some options

import SwiftUI

struct TitleFont: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.largeTitle).bold()
            .foregroundColor(.black)
            .clipShape(.rect(cornerRadius: 10))
    }
}

extension View {
    func titleStyle() -> some View{
        modifier(TitleFont())
    }
}

struct AnimationEffect: ViewModifier{
    let animation360 : Double
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(.degrees(animation360), axis: (x: 1, y: 1, z: 2))
    }
}

extension View{
    func animating() -> some View{
        modifier(AnimationEffect(animation360: 360))
    }
}




struct ImageFlag: View{ // this struct will have all the modifiers for the flag image. Don't need to write the code over and over.
    
    var img: ImageResource // What is going to show
    
    var body: some View{
        Image(img)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}


struct ContentView: View {
    @State private var countries = ["Estonia", "France","Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var flagTapped = false
    @State private var currentScore = 0
    @State private var countryIndex = 0
    @State private var questionRounds = 0
    @State private var gameOver = false
    @State private var animation360 = 0.0
    
    
    var body: some View {
        ZStack{
            RadialGradient(stops:[
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location:0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ],center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack{
                
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing:15){
                    
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .titleStyle()
                        
                        
                    }
                    
                    ForEach(0..<3) { number in
                        Button
                        {
                            flagTapped(number)
                            withAnimation{
                                animation360 += 360
                                
                            }
                        }
                        
                        label: {
                            ImageFlag(img: ImageResource(name: countries[number],  bundle: .main))
                                
                        }
                        .rotation3DEffect(.degrees(animation360), axis: (x: 1, y: 1, z: 2))
                        
                    }
                    
                }
                
                
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(currentScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert("\(scoreTitle) ", isPresented: $showingScore){
            Button("Continue", action: gameLimit)
        } message: {
    Text("Your score is \(currentScore)")
        }
        .alert("Game Over!", isPresented: $gameOver){
                    Button("Restart", action: resetGame)
        } message: {
            Text("Final Score: \(currentScore) / 8")
        }
  
    }
    


        func flagTapped(_ number: Int){
            questionRounds += 1
            if number == correctAnswer{
                scoreTitle = "Correct"
                animation360 += 360
                currentScore += 1
            } else {
                countryIndex = number
                scoreTitle = "Wrong!, That's the flag of \(countries[countryIndex])  "
            }
            showingScore = true
        }
        func askQuestion(){
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
        func gameLimit(){
            for _ in 1..<9{
                if questionRounds < 8{
                    askQuestion()
                } else if questionRounds == 8 {
                    gameOver = true
                }
            }
        
    }
        func resetGame(){
            questionRounds = 0
            currentScore = 0
            askQuestion()
        }
    }

#Preview {
    ContentView()
}
