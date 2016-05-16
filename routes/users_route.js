var express = require('express');
var router = express.Router();
var userDal = require('../model/user_dal');

router.get('/all', function(req, res) {
  userDal.GetAll(function (err, result) {
        if (err) throw err;
        res.render('displayAllUsers.ejs', {rs: result});
      }
  );
});

router.get('/', function (req, res) {
    if (req.session.account != "undefined"){
        userDal.GetByID(req.session.account.Id, function (err, result) {
                if (err) throw err;

                console.log("results:", result);

                res.render('displaySingleUser.ejs', {rs: result, user_id: req.query.user_id});
            }
        );
    }
    else{
        res.render('login.ejs');
    }
});

router.get('/create', function(req, res) {
    userDal.GetAll(function (err, result) {
            if (err) throw err;
            res.render('createUser.ejs', {rs: result});
        }
    );
});

router.get('/submit', function(req,res){
    userDal.addUser(req, function (err, result){
            if (err) throw err;
            res.render('nothing.ejs', {rs: result});
        }
    );
});

router.get('/delete', function(req,res){
    console.log("-- REQEST --", req.query);
    userDal.delUser(req.query.user_id, function (err, result){
            if (err) throw err;
            res.render('displayAllUsers.ejs', {rs: result, del: true});
        }
    );
});

router.get('/grade', function(req,res){
    userDal.getCategories(req.query.enroll_id, function(err, result){
        if (err) throw err;
        var enrollID = req.query.enroll_id;
        var cat = result;
        userDal.getGrades(enrollID, function(err, result){
            if (err) throw err;
            var enrollID = req.query.enroll_id;
            console.log("grade report query",result);
            console.log("grade report cat",cat);
            console.log("grade report:", enrollID);
            res.render('gradeReport.ejs', {rs:{ }, category: cat, enroll: enrollID, grades: result});
        }
        );
    }
    );
});

router.get('/addGrade', function(req, res) {
    console.log("addGrade",req.query);
    userDal.addGrade(req.query, function(err, result){
            if (err) throw err;
            var enrollID = req.query.enroll_id;
            console.log("grade add query",result);
            console.log("grade add:", enrollID);
            userDal.getCategories(req.query.enroll_id, function(err, result){
                if (err) throw err;
                var enrollID = req.query.enroll_id;
                var cat = result;
                userDal.getGrades(enrollID, function(err, result){
                        if (err) throw err;
                        var enrollID = req.query.enroll_id;
                        console.log("grade report query",result);
                        console.log("grade report cat",cat);
                        console.log("grade report:", enrollID);
                        res.render('gradeReport.ejs', {rs:{ }, category: cat, enroll: enrollID, grades: result});
                    }
                );
            }
            );
        }
    );
});

router.get('/createCategory', function(req, res) {
    console.log("createCategory",req.query);
    res.render('createCategory.ejs', {rs: { }, enroll: req.query.enroll_id });
});

router.get('/deleteCategory', function(req, res) {
    console.log("deleteCategory",req.query.category_id);
    userDal.delCategory(req.query.category_id, function(err, result){
        if (err) throw err;
            userDal.getCategories(req.query.enroll_id, function(err, result){
                    if (err) throw err;
                    var enrollID = req.query.enroll_id;
                    console.log("grade report query",result);
                    console.log("grade report:", enrollID);
                    res.redirect("/");
                    res.render('gradeReport.ejs', {rs:{ }, category: result, enroll: enrollID});
                }
            );
    }
    );
});

module.exports = router;