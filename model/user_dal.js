var mysql   = require('mysql');
var db  = require('./db_connection.js');

/* DATABASE CONFIGURATION */
var connection = mysql.createConnection(db.config);

exports.GetAll = function(callback) {
    connection.query('SELECT * FROM Project_User;',
        function (err, result) {
            if(err) {
                console.log(err);
                callback(true);
                return;
            }
            console.log(result);
            callback(false, result);
        }
    );
}


exports.GetByID = function(user_id, callback) {
    console.log(user_id);
    var query = 'SELECT * FROM users_classes WHERE Id=' + user_id;
    console.log(query);
    connection.query(query,
        function (err, result) {
            if(err) {
                console.log(err);
                callback(true);
                return;
            }
            console.log(result);
            callback(false, result);
        }
    );
}

exports.delUser = function(user_id, callback) {
    console.log(user_id);
    var query = 'DELETE FROM Project_User WHERE Id=' + user_id;
    console.log(query);
    connection.query(query,
        function (err, result) {
            if(err) {
                console.log(err);
                callback(true);
                return;
            }
            console.log(result);
            callback(false, result);
        }
    );
}

exports.GetByEmail = function(email, password, callback) {
    var query = 'CALL Account_GetByEmail(?, ?)';
    var query_data = [email, password];
    console.log('query', query);
    console.log('data', query_data);
    connection.query(query, query_data, function(err, result) {
        console.log('Result', result);
        if(err){
            callback(err, null);
        }
        else if(result[0].length == 1) {
            /* NOTE: Stored Procedure results are wrapped in an extra array
             * and only one user record should be returned,
             * so return only the one result
             */
            callback(err, result[0][0]);
        }
        else {
            console.log("Res: ", result);
            callback(err, null);
        }
    });
};

exports.getCategories = function(enrollment_id, callback) {
    var query = 'SELECT * FROM Project_Category c WHERE EnrollmentId = ' + enrollment_id + ";";
    console.log(query);
    connection.query(query,
        function (err, result) {
            if(err) {
                console.log(err);
                callback(true);
                return;
            }
            console.log(result, enrollment_id);
            callback(false, result);
        }
    );
};

exports.getGrades = function(enrollment_id, callback) {
    var query = 'SELECT * FROM Project_Grades c WHERE EnrollmentId = ' + enrollment_id + ";";
    console.log(query);
    connection.query(query,
        function (err, result) {
            if(err) {
                console.log(err);
                callback(true);
                return;
            }
            console.log(result, enrollment_id);
            callback(false, result);
        }
    );
};

exports.delCategory = function(category_Id, callback) {
    var query = 'DELETE FROM Project_Category WHERE Id=' + category_Id;
    console.log(query);
    connection.query(query,
        function (err, result) {
            if(err) {
                console.log(err);
                callback(true);
                return;
            }
            console.log(result, category_Id);
            callback(false, result);
        }
    );
};

exports.addGrade = function(info, callback){
    var score = "\"" + info.Score + "\"";
    var max = "\"" + info.MaxScore + "\"";
    var catId = "\"" + info.category_id + "\"";
    var enrollId = "\"" + info.enroll_id + "\"";
    var query = "INSERT INTO Project_Grades (Score, MaxScore, CategoryId, EnrollmentId) VALUES (" +
        score + "," + max + "," + catId + "," + enrollId + ")";
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
