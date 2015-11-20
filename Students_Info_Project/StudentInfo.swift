//
//  StudentInfo.swift
//  Homework2
//
//  Created by Weiqi Wei on 15/9/3.
//  Copyright (c) 2015年 Weiqi Wei. All rights reserved.
//

import UIKit

var Country_or_state :[String] = [
    "from China", "from South Africa", "from Washington", "from Kenya", "born in India, raised in New Jersey", "from Indiana", "from Florida", "from New York", "from Texas", "from North Carolina", "from Missouri"
]

var degree : [String] = [
    "an ECE 2nd year Master student",
    "an ECE 2nd year Master student and has a bachelor degree in Electrical Engineering",
    "an ECE second year master and has a bachelor degree in Electrical and information engineering",
    "has a Bachelor degree in Information Engineering",
    "a Master of Engineering student in ECE Department",
    "a CS 2nd Year Master student",
    "pursuing a Bachelor degree in CE and EE double major",
    "an ECE master student",
    "pursuing a Triple major degree in EE, CS and Math",
    "pursuing a Bachelor degree in CS and ECE double major",
    "an ECE 2nd year Master student and has a bachelor degree in Telecommunication",
    "pursuing a Bachelor degree in CS"
]

let name_to_index : [String : Int] = [
    "TC Dong": 0,
    "Weidong Duan": 1,
    "Shuai Fu": 2,
    "Shaoyi Han": 3,
    "Rahul Harikrishnan": 4,
    "Wenting Hu": 5,
    "Jingxiong Huang": 6,
    "Zhuo Jia": 7,
    "Deyu Jiao": 8,
    "Allan Kiplagat": 9,
    "Ashwin Kommajesula": 10,
    "Austin Kyker": 11,
    "Hao Li": 12,
    "Jiancheng Li": 13,
    "Guoshan Liu": 14,
    "Mingming Lu": 15,
    "Xin Lu": 16,
    "Chase Malik": 17,
    "Julien Mansier": 18,
    "Greg McKeon": 19,
    "Weichen Ning": 20,
    "Zachary Podbela": 21,
    "Scotty Shaw": 22,
    "Emmanuel Shiferaw": 23,
    "Weiqi Wei": 24,
    "Hao Wu": 25,
    "Boyang Xu": 26,
    "Shuai Yuan": 27,
    "Ran Zhou": 28,
    "Hong Jin":29
]
var GenderInfo: [String] = ["Female", "Male", "Male", "Female", "Male", "Female", "Male", "Male", "Male", "Male", "Male", "Male", "Male", "Male", "Female", "Male", "Male", "Male", "Male", "Male", "Male", "Male", "Male", "Male", "Male", "Male", "Male","Male", "Female", "Male"]
var from_country_or_state: [Int] = [1, 0, 0, 0, 2, 0, 0, 0, 0, 3, 4, 5, 0, 0, 0, 0, 0, 10, 6, 7, 0, 7, 8, 9, 0, 0, 0, 0, 0, 0]
var from_department: [Int] = [9, 0, 10, 0, 6, 0, 0, 0, 0, 7, 9, 9, 0, 0, 0, 0, 0, 8, 4, 9, 0, 9, 11, 9, 0, 0, 5, 0, 4, 0]
var Interests: [String] = ["violin and figure skating", "swimming and movies", "table tennis and piano", "piano and dancing", "cricket and hiking", "piano and computer games", "swimming and mobile phone games", "cooking and photoshooting", "choir and piano", "guitar and jogging","cooking and violin", "basketball and golf", "basketball and movies", "swimming and computer games", "piano and music", "basketball and workout", "running and table tennis", "video games and watch sports", "football and beer", "Netflix and baseball", "badminton and movie", "music and flying", "basketball and traveling", "reading and football", "soccer and table tennis", "tennis and movie", "soccer and basketball", "basketball and computer games", "violin and swimming", "computer games and basketball"
]
var Programming_languages: [String] = ["Java and C", "Java and C++", "C and Java", "C and C++", "Java and Python", "C++ and Java", "C++ and Python", "C++ and Java", "Java and C++", "Java and Ruby", "Java and C", "Java and JavaScript", "C++ and Java", "C and Java", "Java and C++", "C++ and java", "C++ and Go", "Java and C", "Java and C", "Java and Javascript", "C and C++", "Java and Python", "Java and Objective C", "Java and C#", "C++ and Java", "Java and C", "C and Java", "Java and C", "C and C++", "C++ and C"
]
var Email: [String] = ["td84@duke.edu", "wd37@duke.edu", "sf165@duke.edu", "sh335@duke.edu", "rh151@duke.edu", "wh89@duke.edu", "jh429@duke.edu", "zj18@duke.edu", "dj105@duke.edu",  "akk25@duke.edu", "ahk12@duke.edu", "amk66@duke.edu", "hl202@duke.edu", "jl578@duke.edu", "gl87@duke.edu", "ml297@duke.edu", "xl127@duke.edu", "crm49@duke.edu", "jm436@duke.edu", "grm19@duke.edu", "wn19@duke.edu", "zjp3@duke.edu", "sks6@duke.edu", "eas66@duke.edu", "ww85@duke.edu", "hw135@duke.edu", "bx15@duke.edu", "sy100@duke.edu", "rz49@duke.edu", "hj68@duke.edu"
]
var newStudentDescription: [String: String] = ["":""]
var newStudentPhoto: [String: String] = ["":""]
var newStudentEmail: [String: String] = ["":""]

func findCountryIndex(country: String)->Int{
    var index = 0
    for item in Country_or_state{
        if(item == country){
            break
        }
        else{
            index++
        }
    }
    return index
}

func findDegreeIndex(Degree: String)->Int{
    var index = 0
    for item in degree{
        if(item == Degree){
            break
        }
        else{
            index++;
        }
    }
    return index
}

class StudentInfo: NSObject {
    var name: String
    var gender: String
    var country_or_state: String
    var department: String
    var programming_language: String
    var interests: String
    var newPhotoName: String
    var completed: Bool
    var email: String
    var rating: Float
    override init (){
        self.name = ""
        self.gender = "male"
        self.country_or_state = ""
        self.department = ""
        self.programming_language = ""
        self.interests = ""
        self.newPhotoName = ""
        self.completed = false
        self.email = ""
        self.rating = 0
    }
    init(Name: String){
        self.name = Name
        let index = name_to_index[Name]
        if(index != nil ){
            self.gender = GenderInfo[index!]
            self.country_or_state = Country_or_state[from_country_or_state[index!]]
            let department_index = from_department[index!]
            self.department = degree[department_index]
            self.programming_language = Programming_languages[index!]
            self.interests = Interests[index!]
            self.newPhotoName = String()
            self.completed = false
            self.email = Email[index!]
        }
        else{
            self.gender = ""
            self.country_or_state = ""
            self.department = ""
            self.programming_language = ""
            self.interests = ""
            self.newPhotoName = ""
            self.completed = false
            self.email = ""
        }
        self.rating = 0
    }
    init(Name: String, Gender: String, Country: String, Department: String, Programming_languages: String, Interests: String, photoName: String, EMAIL: String){
        self.name = Name
        self.gender = Gender
        self.country_or_state = Country
        self.department = Department
        self.programming_language = Programming_languages
        self.interests = Interests
        self.newPhotoName = photoName
        newStudentPhoto[self.name] = photoName
        self.email = EMAIL
        self.rating = 0
        
        GenderInfo.append(Gender)
        self.completed = false
        let newCountryIndex = findCountryIndex(Country)
        if(newCountryIndex > Country_or_state.count){
            Country_or_state.append(Country)
            from_country_or_state.append(newCountryIndex)
        }
        else{
            from_country_or_state.append(newCountryIndex)
        }
        
        let newDegreeIndex = findDegreeIndex(Department)
        if(newDegreeIndex > degree.count){
            degree.append(Department)
            from_department.append(newDegreeIndex)
        }
        else{
            from_department.append(newDegreeIndex)
        }
        
        var gen: String
        var his_or_her: String
        var His_or_Her: String
        var He_or_She: String
        switch gender{
            case "Male": gen = "male"
                        He_or_She = "He"
                        his_or_her = "his"
                        His_or_Her = "His"
            case "Female": gen = "female"
                        He_or_She = "She"
                        his_or_her = "her"
                        His_or_Her = "Her"
            default: gen = "male"
                     He_or_She = "He"
                     his_or_her = "his"
                     His_or_Her = "His"
        }
        var a_or_an: String = "a "
        for item in department.characters{
            if(item == "E" || item == "e"){
                a_or_an = "an "
            }
            break
        }
        let studentDescription = name + " is a " + gen + " student from " + country_or_state + ". " + He_or_She + " is " + a_or_an + department + " student and " + his_or_her + " best two programming languages are " + programming_language + ". " +  His_or_Her + " interests outside school are " + interests + "."
        newStudentDescription[self.name] = studentDescription
        newStudentEmail[self.name] = EMAIL
    }
    func get_all_info()->(String, String, String){
        var result: String
        var photoName: String
        var Email: String
        if(name_to_index[self.name] != nil){
            var gen: String
            var is_he: Bool
            is_he = false
            var his_or_her: String
            var His_or_Her: String
            switch gender{
            case "Male": gen = "male"
            is_he = true
            his_or_her = "his"
            His_or_Her = "His"
            case "Female": gen = "female"
            is_he = false
            his_or_her = "her"
            His_or_Her = "Her"
            default: gen = "male"
            is_he = true
            his_or_her = "his"
            His_or_Her = "His"
            }
            var he_or_she: String
            he_or_she = is_he ? "He" : "She"
            result = name + " is a " + gen + " student " + country_or_state + ". " + he_or_she + " is " + department + " and " + his_or_her + " best two programming languages are " + programming_language + ". " +  His_or_Her + " interests outside school are " + interests + "."
        
            photoName = ""
            Email = self.email
            print(result)
        }
        else{
            let Name = self.name
            result = newStudentDescription[Name]!
            photoName = newStudentPhoto[Name]!
            Email = newStudentEmail[Name]!
        }
        return (result, photoName, Email)
    }
}