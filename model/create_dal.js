var mysql   = require('mysql');
var db  = require('./db_connection.js');
var connection = mysql.createConnection(db.config);

exports.addUser = function(info, callback){
    var fn = "\"" + info.query.firstN + "\"";
    var mi = "\"" + info.query.middleI + "\"";
    var ln = "\"" + info.query.lastN + "\"";
    var username = "\"" + info.query.username + "\"";
    var email = "\"" + info.query.email + "\"";
    var pass = "\"" + info.query.password + "\"";
    console.log(username, email, fn, mi, ln);
    var query = "INSERT INTO Project_User (Username, Email, FirstName, MiddleInital, LastName, password) VALUES (" +
        username + "," + email + "," + fn + "," + mi + "," + ln + "," + pass + ")";
    console.log(query);
    connection.query(query,
        function (err, result) {
            if(err) {
                console.log(err);
                callback(true);
                return;
            }
            callback(false, result);
        }
    );
}

exports.addClass = function(info, callback){
    var dep = "\"" + info.query.dep + "\"";
    var classnum = "\"" + info.query.classnum + "\"";
    var name = "\"" + info.query.classname + "\"";
    console.log(dep, classnum, name);
    var query = "INSERT INTO Project_Class (Department, Class_Number, Name) VALUES (" +
        dep + "," + classnum + "," + name + ")";
    console.log(query);
    connection.query(query,
        function (err, result) {
            if(err) {
                console.log(err);
                callback(true);
                return;
            }
            callback(false, result);
        }
    );
}

exports.enroll = function(info, callback){
    console.log("info!!!", info.query);
    var userid = "\"" + info.session.account.Id + "\"";
    var sectionid = "\"" + info.query.sectionId + "\"";
    var query = "INSERT INTO Project_Enrollment (UserId, SectionId) VALUES (" +
        userid + "," + sectionid + ")";
    console.log(query);
    connection.query(query,
        function (err, result) {
            if(err) {
                console.log(err);
                callback(true);
                return;
            }
            callback(false, result);
        }
    );
}

exports.addSection = function(info, callback){
    console.log("info!!!", info.query);
    var teacher = "\"" + info.query.teacher + "\"";
    var classid = "\"" + info.query.classId + "\"";
    var building = "\"" + info.query.building + "\"";
    var roomnum = "\"" + info.query.roomnum + "\"";
    var query = "INSERT INTO Project_Section (Teacher, Building, RoomNumber, ClassId) VALUES (" +
        teacher + "," + building + "," + roomnum + "," + classid + ")";
    console.log(query);
    connection.query(query,
        function (err, result) {
            if(err) {
                console.log(err);
                callback(true);
                return;
            }
            callback(false, result);
        }
    );
}

exports.addCategory = function(info, callback){
    var name = "\"" + info.query.Name + "\"";
    var weight = "\"" + info.query.weight + "\"";
    var enrollId = "\"" + info.query.enroll_id + "\"";
    var query = "INSERT INTO Project_Category (CategoryName, Weight, EnrollmentId) VALUES (" +
        name + "," + weight + "," + enrollId + ")";
    console.log(query);
    connection.query(query,
        function (err, result) {
            if(err) {
                console.log(err);
                callback(true);
                return;
            }
            callback(false, result);
        }
    );
}