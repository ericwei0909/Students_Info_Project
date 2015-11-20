//
//  MasterViewController.swift
//  homework4
//
//  Created by Weiqi Wei on 15/9/20.
//  Copyright (c) 2015年 Physaologists. All rights reserved.
//

import UIKit

var studentNames = [ // MARK: store student names
    "TC Dong", // 0
    "Weidong Duan", // 1
    "Shuai Fu", // 2
    "Shaoyi Han", // 3
    "Rahul Harikrishnan", // 4
    "Wenting Hu", // 5
    "Jingxiong Huang", // 6
    "Zhuo Jia", // 7
    "Deyu Jiao", // 8
    "Allan Kiplagat", // 9
    "Ashwin Kommajesula", // 10
    "Austin Kyker", // 11
    "Hao Li", // 12
    "Jiancheng Li", // 13
    "Guoshan Liu", // 14
    "Mingming Lu", // 15
    "Xin Lu", // 16
    "Chase Malik", // 17
    "Julien Mansier", // 18
    "Greg McKeon", // 19
    "Weichen Ning", // 20
    "Zachary Podbela", // 21
    "Scotty Shaw", // 22
    "Emmanuel Shiferaw", // 23
    "Weiqi Wei", // 24
    "Hao Wu", // 25
    "Boyang Xu", // 26
    "Shuai Yuan", // 27
    "Ran Zhou", // 28
    "Hong Jin" // 29
]

// MARK: groupInfo
var group1: [Int] = [8, 25, 14]
var group2: [Int] = [4, 9, 18]
var group3: [Int] = [13, 7, 1]
var group4: [Int] = [6, 16, 19]
var group5: [Int] = [3, 26, 29]
var group6: [Int] = [27, 28, 0]
var group7: [Int] = [17, 11, 22]
var group8: [Int] = [24, 12, 23]
var group9: [Int] = [15, 2, 20]
var group10: [Int] = [5, 10, 21]

var groups = [group1, group2, group3, group4, group5, group6, group7, group8, group9, group10]

var groupName = ["WJL", "Si! Mas!", "Hello World", "Apple Farm", "HelloSiri", "Bug Free", "Shooting Guards", "Physaologists", "Apple Pie", "Cocoa"]

var groupNameIndex = ["WJL", "S M", "H W", "A F", "H S", "B F", "S G", "Phy", "A P", "Co"]

let DocumentsDirectory: AnyObject = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("students")
let GroupURL = DocumentsDirectory.URLByAppendingPathComponent("Groups")
let GroupNameURL = DocumentsDirectory.URLByAppendingPathComponent("GroupsName")
let GroupIndexURL = DocumentsDirectory.URLByAppendingPathComponent("GroupsIndex")

var students2 = [newStudentInfo]()

class MasterViewController: UITableViewController, UISearchResultsUpdating {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var students = [StudentInfo]()
    
    
    var filteredStudents = [String]()
    var resultSearchController = UISearchController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        if let savedStudents = loadStudents() {
            groups = (NSKeyedUnarchiver.unarchiveObjectWithFile(GroupURL.path!) as? [[Int]])!
            groupName = (NSKeyedUnarchiver.unarchiveObjectWithFile(GroupNameURL.path!) as? [String])!
            groupNameIndex = (NSKeyedUnarchiver.unarchiveObjectWithFile(GroupIndexURL.path!) as? [String])!
            print(groupNameIndex)
            students2 += savedStudents
            _ = students2.count
        }
        if(students2.count == 0){
            // MARK: Load the sample data.
            loadExsitData()
        }
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        
        self.definesPresentationContext = true
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        
        self.tableView.reloadData()
    }
    
    func saveStudents() {       //MARK: save all of the students' information, groups index information, group names and group name index to sandbox
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(students2, toFile: ArchiveURL.path!)
        print(ArchiveURL.path!)
        _ = NSKeyedArchiver.archiveRootObject(groups, toFile: GroupURL.path!)
        print(GroupURL.path!)
        _ = NSKeyedArchiver.archiveRootObject(groupName, toFile: GroupNameURL.path!)
        print(GroupNameURL.path!)
        _ = NSKeyedArchiver.archiveRootObject(groupNameIndex, toFile: GroupIndexURL.path!)
        if !isSuccessfulSave {
            print("Failed to save meals...", terminator: "")
        }
    }
    
    func loadExsitData(){
        for item in studentNames {
            self.students.append(StudentInfo(Name: item))
            students2.append(newStudentInfo(Name:item))
        }
    }
    
    func loadStudents() -> [newStudentInfo]?{
        return NSKeyedUnarchiver.unarchiveObjectWithFile(ArchiveURL.path!) as? [newStudentInfo]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.comming_string = "It can work"
                
                if(resultSearchController.active){
                    let student_index = findIndex(filteredStudents[indexPath.row])
                    let student = students2[student_index]
                    controller.requestedStudentInfo = student
                    controller.myRating = student.rating
                    
                }
                else{
                    let index = groups[indexPath.section][indexPath.row]
                    print("\(index) number line")
                    controller.requestedStudentInfo = students2[index]
                    controller.myRating = students2[index].rating
                    print("\(students2[index].rating) rating")
                }
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
            
            if(resultSearchController.active){
                // resultSearchController.active = false;
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.resultSearchController.active {
            return 1
        }
        else {
            return groupName.count
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.active {
            return self.filteredStudents.count
        }
        else {
            return groups[section].count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NameTableViewCell", forIndexPath: indexPath) as! NameTableViewCell
        print(indexPath.row)
        
        cell.backgroundColor = UIColor.blackColor()
        var student: newStudentInfo
        if self.resultSearchController.active {   // MARK: search active
            let student_index2 = findIndex(filteredStudents[indexPath.row])
            student = students2[student_index2]
            if(student.name == "Weiqi Wei" || student.name == "Hao Li" || student.name == "Emmanuel Shiferaw"){
                cell.nameLabel.text = student.name
                cell.nameLabel.textColor = UIColor.greenColor()
            }
            else{
                cell.nameLabel.text = student.name
                cell.nameLabel.textColor = UIColor.whiteColor()
            }
            let student_index = findIndex(filteredStudents[indexPath.row])
            student = students2[student_index]
            if(student.completed){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            else{
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        else {                                    // MARK: search is inactive
            student = students2[groups[indexPath.section][indexPath.row]]
            if(student.name == "Weiqi Wei" || student.name == "Hao Li" || student.name == "Emmanuel Shiferaw"){
                cell.nameLabel.text = student.name
                cell.nameLabel.textColor = UIColor.greenColor()
            }
            else{
                cell.nameLabel.text = student.name
                cell.nameLabel.textColor = UIColor.whiteColor()
            }
            if(student.completed){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            else{
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        return cell
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if(resultSearchController.active){
            let student_index = findIndex(self.filteredStudents[indexPath.row])
            let student = students2[student_index]
            if(student.completed == false){
                student.completed = true
            }
        }
        else{
            if(students2[groups[indexPath.section][indexPath.row]].completed == false){
                students2[groups[indexPath.section][indexPath.row]].completed = true
            }
        }
        saveStudents()
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    // MARK: customize the header cell
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupNameTableViewCell") as! GroupNameTableViewCell
        cell.backgroundColor = UIColor.grayColor()
        if self.resultSearchController.active {
            cell.groupNameLabel.text = "Searching Results"
            cell.groupNameLabel.textColor = UIColor.blackColor()
        }
        else {
            cell.groupNameLabel.text = groupName[section]
            cell.groupNameLabel.textColor = UIColor.blackColor()
        }
        return cell.contentView
    }
    // MARK: header height
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    // MARK: section index
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        
        return groupNameIndex
    }
    // MARK: Edit
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            groups[indexPath.section].removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // MARK: Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
        saveStudents()
        self.tableView.reloadData()
    }
    
    func findIndex(str: String)->Int{     // MARK: find student index in the student arrary
        var index: Int = 0
        for item in students2{
            if(item.name != str){
                index++;
            }
            else{
                break;
            }
        }
        return index
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {  // MAKR: find search results
        self.filteredStudents.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        var temp: [String] = []
        for array in groups{
            var studentGroup:[String] = []
            for item in array {
                studentGroup.append(students2[item].name)
                print(item)
            }
            let res = (studentGroup as NSArray).filteredArrayUsingPredicate(searchPredicate)
            temp = res as! [String]
            filteredStudents += temp
        }
        print(filteredStudents)
        self.tableView.reloadData()
    }
    
    func findGroupIndex(group: String)-> Int{   // MARK: find group index by searching group name in group arrary
        var index:Int = 0;
        for item in groupName{
            if(item == group){
                return index;
            }
            index++;
        }
        return index;
    }
    
    @IBAction func unwindFromAddInfo(segue: UIStoryboardSegue){      // MARK: go back from add info view
        let source: AddInfoViewController = segue.sourceViewController as! AddInfoViewController
        let student: StudentInfo = source.newStudent
        let student_new = source.new_student
        print(student.name)
        
        if(student.name != ""){
            let GroupIndex = findGroupIndex(student_new.group)
            if(GroupIndex < groups.count){
                groups[GroupIndex].append(students2.count)
            }
            else{
                groupName.append(student_new.group)
                groups.append([Int](arrayLiteral: students2.count))
                groupNameIndex.append(student_new.group)
            }
            students2.append(student_new)
        }
        
        self.tableView.reloadData()
        saveStudents()
    }
    
    @IBAction func unwindFromEdit(segue: UIStoryboardSegue) {       // MARK: go back from edit info view
        let source: EditViewController = segue.sourceViewController as! EditViewController
        let editedStudent:newStudentInfo = source.student
        
        
        let studentIndex = name_to_index[editedStudent.name]
        print(editedStudent.name)
        print(studentIndex)
        if(studentIndex != nil) {
            students2[studentIndex!].copyIn(editedStudent.name, Country: editedStudent.country_or_state, Department: editedStudent.department, Programming_Languages: editedStudent.programming_language, Interest: editedStudent.interests)
        }
        self.tableView.reloadData()
        saveStudents()
    }
}

