var express = require('express');
var router = express.Router();
var userDAL = require('../model/user_dal');

/* GET home page. */
router.get('/', function(req, res, next) {
    if (req.session.account != undefined){
        userDAL.GetByID(req.session.account.Id, function (err, result) {
                if (err) throw err;
                console.log('stuff i can use at main menu', result);
                res.render('displaySingleUser.ejs', {rs: result, user_id: req.query.user_id, account:req.session.account});
            }
        );
    }
    else{
        res.render('index', {rs: req});
    }
});

router.get('/authenticate', function(req, res) {
  console.log('req123', req.query);
  userDAL.GetByEmail(req.query.login_email, req.query.login_password, function (err, account) {
    console.log('Called authenticate function');
    if (err) {
      res.send(err);
    }
    else if (account == null) {
      res.send("User not found.");
    }
    else {
      req.session.account = account;
      //res.redirect(req.session.originalUrl);
      req.session.account = account;
      res.send(account);
    }
  });
});

router.get('/login', function(req, res, next) {
    res.render('authentication/login.ejs');
});

router.get('/logout', function(req, res) {
    req.session.destroy( function(err) {
        res.render('authentication/logout.ejs');
    });
});

module.exports = router;
