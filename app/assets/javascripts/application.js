// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.bootstrap
//= require_tree .
//
var discount_value;
function disableDiscount() {
	document.getElementById('enrollment_discount').disabled = true;
	document.getElementById('enrollment_discount').checked = false;
}	
function enableDiscount() {
	document.getElementById('enrollment_discount').disabled = false;
}
function toggleDiscount() {
	if(document.getElementById('enrollment_discount').disabled) {
		document.getElementById('enrollment_discount').disabled = false;
		document.getElementById('enrollment_discount').checked = discount_value;
	}else{
		discount_value = document.getElementById('enrollment_discount').checked;
		document.getElementById('enrollment_discount').disabled = true;
		document.getElementById('enrollment_discount').checked = false;
	}
}

function checkAll(field)
{
for (i = 0; i < field.length; i++)
	field[i].checked = true ;
}

