//
//  ContentView.swift
//  ScrambleWord
//
//  Created by Shomil Singh on 01/09/23.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var newWord = ""
    @State private var rootWord = ""
    @State private var showingError = false
    @State private var ErrorTitle = ""
    @State private var ErrorMessage = ""
    @State private var score=0
    var body: some View {
        NavigationView{
           
                
                
                List{
                    Section{
                        TextField("Enter new word", text: $newWord)
                            .autocapitalization(.none)
                            .onSubmit(addWord)
                    }
                    
                    Section{
                        ForEach(usedWords,id: \.self){ word in
                            HStack{
                                Image(systemName: "\(word.count).circle")
                                Text(word)
                                
                            }
                            
                        }
                        
                    }
                    Section{
                        Text("Score : \(score)")
                            .frame(maxWidth: .infinity)
                        
                    }
                    
                    
                    
                }
                .navigationTitle(Text(rootWord))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(){
                    ToolbarItem(placement: .principal)
                    {
                        
                        Text(rootWord)
                        .font(.largeTitle)
                        
                    }
                }
            
                .toolbar(){
                    ToolbarItemGroup(placement: .bottomBar)
                    {
                        
                        Button("New word!"){
                            clearList()
                            startGame()
                            
                        }
                        
                        
                    }
                }
                
                
                
                .onAppear(perform: startGame)
                .alert(ErrorTitle, isPresented: $showingError)
                {
                    Button("Ok",role: .cancel){}
                }
            message:{
                Text(ErrorMessage)
            }
            
            
        }
        
    
        
       
        
       
    }
    func addscore(word:String){
        score+=1+word.count
    }
    func ErrorType(title:String,message:String) {
        ErrorMessage=message
        ErrorTitle=title
        showingError=true
    }
    func clearList(){
        usedWords.removeAll()
    }
    func startGame(){
//        newWord.removeAll()
        score=0
        if let startURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startcontent = try? String(contentsOf: startURL){
                let allwords = startcontent.components(separatedBy: "\n")
                rootWord=allwords.randomElement() ?? "silkworm"
                return

            }
        }
        fatalError("start.txt could not be find in bundle.")

    }
    func count(word:String) -> Bool{
        if(word.count<=1){
            return false
            
        }
       
        return true
            
        
    }
    func startingWord(word:String) -> Bool{
        return !word.elementsEqual(rootWord)
    }
    func isOriginal(word:String) -> Bool{
        !usedWords.contains(word)
    }
    func isPossible(word:String) -> Bool{
        var temp=rootWord
        for letter in word{
            if let pos = temp.firstIndex(of: letter){
                temp.remove(at: pos)
            }
            else{
                return false
            }
            
        }
        return true
    }
    func isReal(word:String) -> Bool{
        let checker=UITextChecker()
        let range=NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    func addWord(){
        newWord=newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard isReal(word: newWord)else{
            ErrorType(title: "Word not Recognized", message: "Type real words ... Don't make your own")
            return
        }
        guard count(word: newWord)else{
            ErrorType(title: "Insufficient length", message: "Word should be larger than a letter")
            return
        }
        guard startingWord(word: newWord)else{
            ErrorType(title: "Starting word!", message: "Isn't it easy guess!")
            return
        }
        guard isOriginal(word: newWord)else{
            ErrorType(title: "Word used already", message: "Be more original")
            return
        }
        guard isPossible(word: newWord)else{
            ErrorType(title: "Word not possible", message: "You cannot spell \(newWord) from \(rootWord)")
            return
        }
       
        guard newWord.count>0 else {return }
        withAnimation{
            usedWords.insert(newWord, at: 0)
            }
        addscore(word: newWord)
        newWord=""
    }
    func test(){
        let word="Swift"
        let checker=UITextChecker()
        let range=NSRange(location: 0,length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        let allGood = misspelledRange.location == NSNotFound
        
    }
    func loadFile(){
        // url stores url like apple.com as well as the local urls as well like location of file
        // Bundle.main.url -> to find url of file
        // its optional so unwrap
        
        if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt"){
            // we found file in out bundle
            // this uses the concept of sandboxing
            // read the content of file using String(contentsOf:)
            // if somehow some error occur like file cannot be opened or anything thats why we use try? .
            if let fileContents = try? String(contentsOf: fileURL)
            {
                // now we got the string so use it as you want;
                
            }
            
        }
           
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
