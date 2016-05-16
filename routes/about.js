/**
 * Created by admin on 4/25/16.
 */
var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res) {
    res.render('about.ejs');
});

module.exports = router;