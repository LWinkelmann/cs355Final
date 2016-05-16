var express = require('express');
var router = express.Router();
var createDal = require('../model/create_dal');

router.get('/user', function(req,res){
    createDal.addUser(req, function (err, result){
            if (err) throw err;
            else
                res.render('successfullAccountCreation', {rs: result, title: "Success!"});
        }
    );
});

router.get('/class', function(req,res){
    createDal.addClass(req, function (err, result){
            if (err) throw err;
            else
                res.render('successfullClassCreation', {rs: result, title: "Success!"});
        }
    );
});

router.get('/section', function(req,res){
    createDal.addSection(req, function (err, result){
            if (err) throw err;
            else
                res.render('successfullSectionCreation', {rs: result, title: "Success!"});
        }
    );
});

router.get('/enroll', function(req,res){
    createDal.enroll(req, function (err, result){
            if (err) throw err;
            else
                res.render('successfullEnrollment', {rs: result, title: "Success!"});
        }
    );
});

router.get('/category', function(req,res){
    createDal.addCategory(req, function (err, result){
            if (err) throw err;
            else
                res.render('successfullCategoryCreation', {rs: result, title: "Success!", enroll:req.query.enroll_id});
        }
    );
});

module.exports = router;