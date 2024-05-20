import ballerina/http;
import ballerina/io;

type Lecturer record{
    readonly string Staff_No;
    string Staff_Name;
    string Office_No;
    string CoursesName;
};

type Course readonly & record{
    int CourseCode;
    string CourseName;
    int NQF;
};
//Value for searches

type OfficeNo string;
type CourseName string;
table <Lecturer>key(Staff_No) staffRecordsTable=table[
    {Staff_No: "1",Staff_Name: "Talo",Office_No: "23",CoursesName: "Programming"},
    {Staff_No: "2",Staff_Name: "Olat",Office_No: "24",CoursesName: "Data Structures"},
    {Staff_No: "3",Staff_Name: "Lolina",Office_No: "26",CoursesName: "Intro to Computing"},
    {Staff_No: "4",Staff_Name: "John",Office_No: "27",CoursesName: "Archaetecture"}
];
service /Staff on new http:Listener(9090) {
    //Get functions
    resource function get getStaffMembers() returns table <Lecturer>key(Staff_No){
        return staffRecordsTable;
    }
        //get staff members by staffNo
    resource function get GetStaffByStaffNo(string Staff_No) returns Lecturer|string{
        foreach Lecturer lecturer in staffRecordsTable{
            if(lecturer.Staff_No===Staff_No){
                return lecturer;
            }
        }
        return Staff_No + "Does not exist";
    }
    //get staff members by coursename
    resource function get GetByCourseName(string Course_Name) returns Lecturer|string{
        foreach Lecturer lecturer in staffRecordsTable{
            if(lecturer.CoursesName===Course_Name){
                return lecturer;
            }
        }
        return Course_Name + "Does not exist";
    }
    //get staff members by officeno
    resource function get GetByOfficeNo(string Office_Num) returns Lecturer|string{
        foreach Lecturer lecturer in staffRecordsTable{
            if(lecturer.Office_No===Office_Num){
                return lecturer;
            }
        }
        return Office_Num + "Does not exist";
    }
    //Add a Lecturer
    resource function post addstaffRecord(Lecturer staffRecord) returns string{
        io:println(staffRecord);
        error? err=staffRecordsTable.add(staffRecord);
        if (err is error){
            return string `error, ${err.message()}`;
        }
        return string `${staffRecord.Staff_No} saved successfully`;
    }
    //delete staff members
    resource function delete DeleteStaff/[string staff_num]() returns string{
        staffRecordsTable=<table<Lecturer>key(Staff_No)>staffRecordsTable.filter((staffRecord)=>staffRecord.Staff_No != staff_num);
        table<Lecturer> staffRecordsTable2=table[];
        if (staffRecordsTable.length()===staffRecordsTable2.length()){
                    return staff_num + " not found.";
        }
        return staff_num + " successfuly deleted";
    }
    //update staff members record
    resource function put updateStaffMembers(Lecturer lecturer)returns string{
        io:println(lecturer);
        error? err=staffRecordsTable.put(lecturer);
        if(err is error){
            return string `Error,${err.message()}`;
        }
        return string `Error,${lecturer.Staff_No} saved successfully`;
    }
}
