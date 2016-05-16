/**
 * Created by admin on 3/26/16.
 */
var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
    res.render('adminCP');
});

module.exports = router;
