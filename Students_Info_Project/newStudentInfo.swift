//
//  StudentInfo.swift
//  Homework2
//
//  Created by Weiqi Wei on 15/9/3.
//  Copyright (c) 2015年 Weiqi Wei. All rights reserved.
//

import UIKit

class newStudentInfo: NSObject, NSCoding{
    var name: String
    var photodata: NSData
    var gender: String
    var country_or_state: String
    var department: String
    var programming_language: String
    var interests: String
    var completed: Bool
    var email: String
    var rating: Float = 0
    var group:String
    
    override init (){
        self.name = ""
        self.gender = "male"
        self.country_or_state = ""
        self.department = ""
        self.programming_language = ""
        self.interests = ""
        self.photodata = NSData()
        self.completed = false
        self.email = ""
        self.rating = 0
        self.group = ""
    }
    
    
    init(Name: String){
        self.name = Name
        let index = name_to_index[Name]
        let pictureName = Name + ".jpg"
        let image = UIImage(named: pictureName)
        let imagedata = UIImageJPEGRepresentation(image!, 1.0)
        self.photodata = imagedata!
        self.gender = GenderInfo[index!]
        self.country_or_state = Country_or_state[from_country_or_state[index!]]
        let department_index = from_department[index!]
        self.department = degree[department_index]
        self.programming_language = Programming_languages[index!]
        self.interests = Interests[index!]
        self.completed = false
        self.email = Email[index!]
        self.rating = 0
        self.group = ""
    }
    
    init(Name: String, Gender: String, Country: String, Department: String, Programming_languages: String, Interests: String, PhotoData: NSData, EMAIL: String, Group: String){
        self.name = Name
        self.gender = Gender
        self.country_or_state = Country
        self.department = Department
        self.programming_language = Programming_languages
        self.interests = Interests
        self.photodata = PhotoData
        self.email = EMAIL
        self.rating = 0
        GenderInfo.append(Gender)
        self.completed = false
        self.group = Group
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
    }
    
    func encodeWithCoder(coder: NSCoder) {
        // do not call super in this case
        coder.encodeObject(self.name, forKey: "nameLabel")
        coder.encodeObject(self.photodata, forKey: "photodataLabel")
        coder.encodeObject(self.gender, forKey: "genderLabel")
        coder.encodeObject(self.country_or_state, forKey: "country_or_stateLabel")
        coder.encodeObject(self.department, forKey: "departmentLabel")
        coder.encodeObject(self.programming_language, forKey: "programming_languageLabel")
        coder.encodeObject(self.interests, forKey: "interestsLabel")
        coder.encodeObject(self.completed, forKey: "completedLabel")
        coder.encodeObject(self.email, forKey: "emailLabel")
        coder.encodeObject(self.rating, forKey: "ratingLabel")
        coder.encodeObject(self.group, forKey: "groupLabel")
    }
    
    required init?(coder: NSCoder) {
        self.name = coder.decodeObjectForKey("nameLabel")! as! String
        self.photodata = coder.decodeObjectForKey("photodataLabel") as! NSData
        self.gender = coder.decodeObjectForKey("genderLabel") as! String
        self.country_or_state = coder.decodeObjectForKey("country_or_stateLabel") as! String
        self.department = coder.decodeObjectForKey("departmentLabel") as! String
        self.programming_language = coder.decodeObjectForKey("programming_languageLabel") as! String
        self.interests = coder.decodeObjectForKey("interestsLabel") as!String
        self.completed = coder.decodeObjectForKey("completedLabel") as!Bool
        self.email = coder.decodeObjectForKey("emailLabel") as! String
        self.rating = coder.decodeObjectForKey("ratingLabel") as! Float
        self.group = coder.decodeObjectForKey("groupLabel") as! String
        // do not call super init(coder:) in this case
    }
    
    func get_all_info()->(String, String){        // get all information of a student
        var result: String
        var Email: String
        var gen: String
        var is_he: Bool
        is_he = false
        var his_or_her: String
        var His_or_Her: String
        switch gender{
            case "Male":
                gen = "male"
                is_he = true
                his_or_her = "his"
                His_or_Her = "His"
            case "Female":
                gen = "female"
                is_he = false
                his_or_her = "her"
                His_or_Her = "Her"
            default:
                gen = "male"
                is_he = true
                his_or_her = "his"
                His_or_Her = "His"
        }
        var he_or_she: String
        he_or_she = is_he ? "He" : "She"
        result = name + " is a " + gen + " student " + country_or_state + ". " + he_or_she + " is " + department + " and " + his_or_her + " best two programming languages are " + programming_language + ". " +  His_or_Her + " interests outside school are " + interests + "."
        
        Email = self.email
        print(result)
        return (result, Email)
    }
    
    func copyIn(name: String, Country: String, Department: String, Programming_Languages: String, Interest: String) {
        self.name = name
        self.country_or_state = Country
        self.department = Department
        self.programming_language = Programming_Languages
        self.interests = Interest
    }

}