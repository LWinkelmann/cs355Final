var express = require('express');
var router = express.Router();
var classDal = require('../model/class_dal');

router.get('/all', function(req, res) {
    classDal.GetAll(function (err, result) {
            if (err) throw err;
            res.render('displayAllClasses.ejs', {rs: result});
        }
    );
});

router.get('/', function (req, res) {
    classDal.GetByID(req.query.class_id, function (err, result) {
            if (err) throw err;
            res.render('displayClassInfo.ejs', {rs: result});
        }
    );
});

router.get('/edit', function (req, res) {
    console.log(req);
    classDal.GetByID(req.query.class_id, function (err, result) {
            if (err) throw err;
            res.render('displayEditClassInfo.ejs', {rs: result, user_id: req.query.user_id});
        }
    );
});

router.get('/create', function(req, res) {
    classDal.GetAll(function (err, result) {
            if (err) throw err;
            res.render('createClass.ejs', {rs: result});
        }
    );
});



router.get('/enroll', function(req, res) {
    classDal.GetAllClassesAndSections(function (err,result) {
            if (err) throw err;
            classDal.GetAll(function (err,c) {
                if (err) throw err;
                console.log("klass", c);
                res.render('enrollinClass.ejs', {rs: result, user_id:req.session.account.Id, classes:c});
            });
        }
    );
});

router.get('/delete', function(req,res){
    console.log("-- REQEST --", req);
    classDal.delClass(req.query.class_id, function (err, result){
            if (err) throw err;
            res.redirect("/");
        }
    );
});

module.exports = router;