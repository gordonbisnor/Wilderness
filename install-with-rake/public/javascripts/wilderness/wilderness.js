// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

/* 
EXTENDS PROTOTYPE TO SET CHECKED WITH INVOKE
http://cardarella.blogspot.com/2008/04/prototypejs-and-dom-attribute.html
*/
var dom_manip_methods = {
 setDOMAttribute: function(element, attr, value){
  element = $(element);
  eval("element." + attr + "=" + value + ";");
  return element;
 },
 getDOMAttribute: function(element, attr){
  element = $(element);
  return eval("element." + attr + ";");
 }
}
Element.addMethods(dom_manip_methods);

/* TOGGLES CHECKBOXES FOR CONTROL (this) WITH CLASS NAMED IN ARGUMENT */
function toggleCheckBoxes(control,class_name) {
  $$(class_name).invoke('setDOMAttribute','checked',$(control).checked);
}

/* ACT ON CHECKED ITEMS */
function act_on_checked(items,path) {       
	var action = $('act-on-checked').value;
  var collection = $$("."+items).pluck('id');
	var ids = new Array;
	collection.each(function(item) { 
		id = item.split('[')[1].split(']')[0];
		value = $(item).getValue(); 
		if(value == 'on') { ids.push(id); }
		});
	if (action != '') {
  	new Ajax.Request(path + action +"?ids="+ids);
	} else {
		alert('Please select an action...');
	}
	return false;
}

function filter(item,path) {
	window.location.href = path + "/?filter_by=" + item.value;
	return false;
}